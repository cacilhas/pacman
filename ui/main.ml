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

let rec loop board =
  Sdlvideo.map_RGB (Screen.std ()) Sdlvideo.black |> Sdlvideo.fill_rect (Screen.std ())
; Sdlvideo.map_RGB board Sdlvideo.black |> Sdlvideo.fill_rect board
; Screen.render board
; Sdlvideo.flip (Screen.std ())
; begin
    match Sdlevent.wait_event() with
      | Sdlevent.KEYDOWN evt        -> if evt.keysym = Sdlkey.KEY_ESCAPE
                                       then exit 0
      | Sdlevent.VIDEORESIZE (w, h) -> assert (Screen.std () = Screen.resize (w, h))
      | _                           -> ()
  end
; loop board

let mainloop () =
  Sdl.init [`AUDIO; `EVENTTHREAD; `JOYSTICK; `TIMER; `VIDEO]
; at_exit Sdl.quit
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
  loop board
