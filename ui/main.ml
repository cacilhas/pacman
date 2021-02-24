module Screen : sig
  val init   : unit -> unit
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
    let beige = Sdlvideo.map_RGB surface (225, 211, 186)
    and dst_rect = Sdlvideo.rect ~x:410 ~y:402 ~w:96 ~h:12 in
    Sdlvideo.fill_rect ~rect:dst_rect surface beige
  ; Map_render.render_circle surface  8 8
  ; Map_render.render_circle surface 10 8

  let blit_surface surface =
    let info = Sdlvideo.surface_info (std ()) in
    let x = (info.w - width) / 2
    and y = (info.h - height) / 2 in
    let dst_rect = Sdlvideo.rect ~x:x ~y:y ~w:width ~h:height in
    Sdlvideo.blit_surface ~src:surface ~dst:(std ()) ~dst_rect:dst_rect ()

  let render surface =
    Map_render.render surface
  ; render_beige surface
  ; Food_render.render surface
  ; Pacman.render_on surface
  ; Ghost.render_on surface (Game.Blinky.xy `SCREEN) `BLINKY
      (Game.Blinky.status ()) (Game.Blinky.looking ())
  ; Ghost.render_on surface (Game.Pinky.xy `SCREEN) `PINKY
      (Game.Pinky.status ()) (Game.Pinky.looking ())
  ; Ghost.render_on surface (Game.Inky.xy `SCREEN) `INKY
      (Game.Inky.status ()) (Game.Inky.looking ())
  ; Ghost.render_on surface (Game.Clyde.xy `SCREEN) `CLYDE
      (Game.Clyde.status ()) (Game.Clyde.looking ())
  ; Game.Globals.score 0 |> Score_render.render surface (1, 0)
  ; Game.Globals.highscore () |> Score_render.render surface (15, 0)
  ; blit_surface surface

  let init () =
    Sdlwm.set_caption ~title:"Kodumaro Pacman" ~icon:""
  ; Sdlevent.enable_events Sdlevent.all_events_mask
  ; std () |> ignore (* force screen to be created *)
end

module Audio : sig
  val init        : unit -> unit
  val close       : unit -> unit
  val play_scored : Signal.arg list -> unit

end = struct
  let init () =
    Sdlmixer.open_audio ()
  ; Sdlmixer.setvolume_channel 1 0.6

  let close () = Sdlmixer.close_audio ()

  let lazy_wakka = lazy (Sdlmixer.load_string Wakka.data)
  let wakka ()   = Lazy.force lazy_wakka

  let play_scored _ =
    if not (Sdlmixer.playing_channel 1)
    then wakka () |> Sdlmixer.play_channel ~channel:1 ~loops:1
end

let running = ref true

let update ticks = if ticks > 0
  then let dt = (float_of_int ticks) /. 1000.0 in
       Signal.emit "update" [`Float dt]

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
    match Sdlevent.wait_event () with
      | Sdlevent.KEYDOWN evt        -> handle_keypress evt.keysym
      | Sdlevent.VIDEORESIZE (w, h) -> assert (Screen.std () = Screen.resize (w, h))
      | _                           -> ()
  end
; handle_events ()

let rec loop board ticks last_tick =
  Sdlvideo.map_RGB (Screen.std ()) Sdlvideo.black |> Sdlvideo.fill_rect (Screen.std ())
; Sdlvideo.map_RGB board Sdlvideo.black |> Sdlvideo.fill_rect board
; update (ticks - last_tick)
; Screen.render board
; Sdlvideo.flip (Screen.std ())
; Sdltimer.delay 33
; if !running
  then loop board (Sdltimer.get_ticks ()) ticks

let connect_handles () =
  (* Ghosts *)
  Signal.connect "chstatus" Game.Blinky.chstatus |> ignore
; Signal.connect "chstatus" Game.Clyde.chstatus  |> ignore
; Signal.connect "chstatus" Game.Inky.chstatus   |> ignore
; Signal.connect "chstatus" Game.Pinky.chstatus  |> ignore
; Signal.connect "levelup"  Game.Blinky.restart  |> ignore
; Signal.connect "levelup"  Game.Clyde.restart   |> ignore
; Signal.connect "levelup"  Game.Inky.restart    |> ignore
; Signal.connect "levelup"  Game.Pinky.restart   |> ignore
; Signal.connect "restart"  Game.Blinky.restart  |> ignore
; Signal.connect "restart"  Game.Clyde.restart   |> ignore
; Signal.connect "restart"  Game.Inky.restart    |> ignore
; Signal.connect "restart"  Game.Pinky.restart   |> ignore
; Signal.connect "update"   Game.Blinky.update   |> ignore
; Signal.connect "update"   Game.Clyde.update    |> ignore
; Signal.connect "update"   Game.Inky.update     |> ignore
; Signal.connect "update"   Game.Pinky.update    |> ignore
; Signal.connect "update"   Ghost.update         |> ignore

(* Pacman *)
; Signal.connect "gotta"     Game.Food.eat         |> ignore
; Signal.connect "levelup"   Game.Pacman.restart   |> ignore
; Signal.connect "restart"   Game.Pacman.restart   |> ignore
; Signal.connect "update"    Game.Pacman.update    |> ignore
; Signal.connect "update"    Pacman.update         |> ignore

  (* Score, board, etc *)
; Signal.connect "collision" Game.Globals.collision |> ignore
; Signal.connect "levelup"   Game.Food.restart      |> ignore
; Signal.connect "restart"   Game.Globals.restart   |> ignore
; Signal.connect "restart"   Game.Food.restart      |> ignore
; Signal.connect "scored"    Audio.play_scored      |> ignore
; Signal.connect "scored"    Game.Globals.scored    |> ignore
; Signal.connect "update"    Game.Globals.update    |> ignore
; Signal.connect "update"    Food_render.update     |> ignore

let start_sdl () =
  Sdl.init [`AUDIO; `EVENTTHREAD; `TIMER; `VIDEO]
; at_exit Sdl.quit
; Audio.init ()
; at_exit Audio.close
; Screen.init ()

let mainloop () =
  start_sdl ()
; connect_handles ()
; let board = Sdlvideo.create_RGB_surface [`HWSURFACE]
              ~w:Screen.width ~h:Screen.height ~bpp:32
              ~rmask:Screen_info.rmask
              ~gmask:Screen_info.gmask
              ~bmask:Screen_info.bmask
              ~amask:Screen_info.amask
  in
  Thread.create handle_events () |> ignore
; loop board (Sdltimer.get_ticks ()) 0
