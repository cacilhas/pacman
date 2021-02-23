let frames =
  let surface = Sdlvideo.create_RGB_surface [`HWSURFACE; `SRCALPHA]
                ~w:288 ~h:48 ~bpp:32
                ~rmask:Screen_info.rmask
                ~gmask:Screen_info.gmask
                ~bmask:Screen_info.bmask
                ~amask:Screen_info.amask
  in
  let color = Sdlvideo.map_RGB surface Sdlvideo.yellow
  and bg = Sdlvideo.map_RGB surface Sdlvideo.black
  and eye = Sdlvideo.map_RGB surface Sdlvideo.white in
  for i = 0 to 5 do
    Circle.fill_sphere surface ~x:(i*48 + 24) ~y:24 ~radius:22 color
  ; Circle.fill_circle surface ~x:(i*48 + 24) ~y:12 ~radius:3 bg
  ; Circle.fill_circle surface ~x:(i*48 + 24) ~y:12 ~radius:2 eye
  done
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:24  ~y:23 ~w:24 ~h:2) surface bg
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:144 ~y:23 ~w:24 ~h:2) surface bg
; for x = 0 to 24 do
    let h = x / 2 in
    let y = 24 - h/2 in
    Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:(72+x)  ~y:y ~w:1 ~h:h) surface bg
  ; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:(168-x) ~y:y ~w:1 ~h:h) surface bg
  done
; for x = 0 to 24 do
    let h = x in
    let y = 24 - h/2 in
    Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:(120+x) ~y:y ~w:1 ~h:h) surface bg
  ; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:(216-x) ~y:y ~w:1 ~h:h) surface bg
  done
; surface

let cur_i = ref 0
let acc   = ref 0.0

let update dt =
  Game.Pacman.update dt
; acc := !acc +. dt
; if !acc >= 0.1
  then begin
    acc := !acc -. 0.1
  ; cur_i := (succ !cur_i) mod 4
  end

let current_frame () =
  let frame = match !cur_i with
    | 3 -> 1
    | v -> v
  in
  match Game.Pacman.pointing () with
    | `LEFT  -> Sdlvideo.rect ~x:(frame*48+144) ~y:0 ~w:48 ~h:48
    | `RIGHT -> Sdlvideo.rect ~x:(frame*48)     ~y:0 ~w:48 ~h:48

let go dir = Game.Pacman.go dir

let gonna = Game.Pacman.gonna

let render_on surface =
  let (x, y) = Game.Pacman.xy `SCREEN in
  let dst_rect = Sdlvideo.rect ~x:x ~y:y ~w:48 ~h:48
  and src_rect = current_frame () in
  Sdlvideo.blit_surface ~src:frames  ~src_rect:src_rect
                        ~dst:surface ~dst_rect:dst_rect ()
