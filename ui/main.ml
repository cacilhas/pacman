module Screen : sig
  val height : int
  val render : Sdlvideo.surface -> unit
  val resize : int * int -> Sdlvideo.surface
  val std    : unit -> Sdlvideo.surface
  val width  : int

end = struct
  let height = 1008
  let width  = 912

  let resize (w, h) = Sdlvideo.set_video_mode ~w:w ~h:h ~bpp:32 [`DOUBLEBUF; `RESIZABLE]

  let lazy_screen = lazy (resize (width, height))
  let std ()      = Lazy.force lazy_screen

  let render_beige surface =
    let beige = Sdlvideo.map_RGB surface (225, 211, 186) in
    Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:410 ~y:402 ~w:96 ~h:12) surface beige
  ; Map_render.render_circle surface  8 8
  ; Map_render.render_circle surface 10 8

  let blit_surface surface =
    let info = Sdlvideo.surface_info (std ()) in
    let x = (info.w - width) / 2
    and y = (info.h - height) / 2 in
    let rect = Sdlvideo.rect ~x:x ~y:y ~w:width ~h:height in
    Sdlvideo.blit_surface ~src:surface ~dst:(std ()) ~dst_rect:rect ()

  let render surface =
    Map_render.render surface
  ; render_beige surface
  ; blit_surface surface
end

module Audio : sig
  val init  : unit -> unit
  val close : unit -> unit
  val wakka : unit -> Sdlmixer.chunk

end = struct
  let init () =
    Sdlmixer.open_audio ()
  ; Sdlmixer.setvolume_channel Sdlmixer.all_channels 0.8

  let close () = Sdlmixer.close_audio ()

  let lazy_wakka = lazy (Sdlmixer.load_string Wakka.data)
  let wakka ()   = Lazy.force lazy_wakka
end

let running = ref true

let update ticks = if ticks > 0
  then begin
    let dt = (float_of_int ticks) /. 1000.0 in
    Pacman.update dt
  end

let handle_keypress sym = match sym with
  | Sdlkey.KEY_ESCAPE -> running := false
                       ; Thread.exit ()
  | Sdlkey.KEY_LEFT   -> Pacman.go `LEFT
  | Sdlkey.KEY_RIGHT  -> Pacman.go `RIGHT
  | Sdlkey.KEY_UP     -> Pacman.go `UP
  | Sdlkey.KEY_DOWN   -> Pacman.go `DOWN
  | _                 -> ()

let rec handle_events () =
  begin
    match Sdlevent.wait_event() with
      | Sdlevent.KEYDOWN evt        -> handle_keypress evt.keysym
      | Sdlevent.VIDEORESIZE (w, h) -> assert (Screen.std () = Screen.resize (w, h))
      | _                           -> ()
  end
; handle_events ()

let rec loop board ticks last_tick =
  Sdlvideo.map_RGB (Screen.std ()) Sdlvideo.black |> Sdlvideo.fill_rect (Screen.std ())
; Sdlvideo.map_RGB board Sdlvideo.black |> Sdlvideo.fill_rect board
; update (ticks - last_tick)
; Pacman.render_on board
; Screen.render board
; Sdlvideo.flip (Screen.std ())
; Sdltimer.delay 33
; if !running
  then loop board (Sdltimer.get_ticks ()) ticks

let rec play () =
  begin
    match Pacman.going () with
      | `NONE -> ()
      | _     -> Audio.wakka () |> Sdlmixer.play_channel ~loops:1
  end
; Thread.delay 0.4
; if !running
  then play ()

let mainloop () =
  Sdl.init [`AUDIO; `EVENTTHREAD; `JOYSTICK; `TIMER; `VIDEO]
; at_exit Sdl.quit
; Audio.init ()
; at_exit Audio.close
; Sdlwm.set_caption ~title:"Kodumaro Pacman" ~icon:""
; Sdlevent.enable_events Sdlevent.all_events_mask
; Screen.std () |> ignore (* force screen to be created *)
; let board = Sdlvideo.create_RGB_surface [`HWSURFACE]
              ~w:Screen.width ~h:Screen.height ~bpp:32
              ~rmask:Screen_info.rmask
              ~gmask:Screen_info.gmask
              ~bmask:Screen_info.bmask
              ~amask:Screen_info.amask
  in
  Thread.create handle_events () |> ignore
; Thread.create play ()          |> ignore
; loop board (Sdltimer.get_ticks ()) 0
