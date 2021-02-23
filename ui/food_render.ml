let cells =
  let surface = Sdlvideo.create_RGB_surface [`HWSURFACE; `SRCALPHA]
                ~w:144 ~h:48 ~bpp:32
                ~rmask:Screen_info.rmask
                ~gmask:Screen_info.gmask
                ~bmask:Screen_info.bmask
                ~amask:Screen_info.amask
  in
  let dot    = Sdlvideo.map_RGB surface (240, 240, 192)
  and power  = Sdlvideo.map_RGB surface (240, 240, 64)
  and cherry = Sdlvideo.map_RGB surface (141, 10, 21)
  and cape   = Sdlvideo.map_RGB surface (64, 240, 0) in
  Circle.fill_circle surface ~x:24 ~y:24 ~radius:6 dot
; Circle.fill_sphere surface ~x:72 ~y:24 ~radius:10 power
; for i = 0 to 10 do
    let x = i + 104
    and y = 30 - (i / 2) in
    Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:x ~y:y ~w:4 ~h:2) surface cape
  ; let x = i + 115
    and y = 32 - (i * 3 / 2) in
    Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:x ~y:y ~w:4 ~h:2) surface cape
  done
; Circle.fill_sphere surface ~x:116 ~y:38 ~radius:8  cherry
; Circle.fill_sphere surface ~x:106 ~y:38 ~radius:10 cherry
; surface

let cycle = ref 0.0
let show  = ref true

let render_cell surface x y i =
  if i = 1 || (!show && i = 2) || i > 2
  then let src_rect = Sdlvideo.rect ~x:(48*(i-1)) ~y:0      ~w:48 ~h:48
       and dst_rect = Sdlvideo.rect ~x:(48*x)     ~y:(48*y) ~w:48 ~h:48 in
       Sdlvideo.blit_surface ~src:cells   ~src_rect:src_rect
                             ~dst:surface ~dst_rect:dst_rect ()

let update = function
  | [Signal.Float dt] ->
    cycle := !cycle +. dt
  ; if !cycle >= 0.25
    then begin
      cycle := !cycle -. 0.25
    ; show := not !show
    end
  | _ -> ()

let render surface =
  for y = 0 to 20 do
    for x = 0 to 18 do
      Game.Food.get_cell (x, y) |> render_cell surface x y
    done
  done
