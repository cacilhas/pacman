let walls =
  let surface = Sdlvideo.create_RGB_surface [`HWSURFACE; `SRCALPHA]
                ~w:240 ~h:48 ~bpp:32
                ~rmask:Screen_info.rmask
                ~gmask:Screen_info.gmask
                ~bmask:Screen_info.bmask
                ~amask:Screen_info.amask
  in
  let color = Sdlvideo.map_RGB surface (84, 128, 192)
  and bg = Sdlvideo.map_RGB surface Sdlvideo.black in
  (* 0 = lonely *)
  Sdlhelpers.fill_circle surface ~x:24 ~y:24 ~radius:6 color
; Sdlhelpers.fill_circle surface ~x:24 ~y:24 ~radius:4 bg
  (* 48 = UP *)
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:66  ~y:0  ~w:12 ~h:24)
    surface color
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:68  ~y:0  ~w:8  ~h:24)
    surface bg
  (* 96 = DOWN *)
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:114 ~y:24 ~w:12 ~h:24)
    surface color
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:116 ~y:24 ~w:8  ~h:24)
    surface bg
  (* 144 = LEFT *)
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:144 ~y:18 ~w:24 ~h:12)
    surface color
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:144 ~y:20 ~w:24 ~h:8)
    surface bg
  (* 192 = RIGHT *)
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:216 ~y:18 ~w:24 ~h:12)
    surface color
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:216 ~y:20 ~w:24 ~h:8)
    surface bg
; surface


let render_circle surface x y =
  let dst_rect = Sdlvideo.rect ~x:(x*48) ~y:(y*48) ~w:48 ~h:48
  and src_rect = Sdlvideo.rect ~x:0 ~y:0 ~w:48 ~h:48 in
  Sdlvideo.blit_surface ~src:walls   ~src_rect:src_rect
                        ~dst:surface ~dst_rect:dst_rect ()


let render_cell surface x y =
  render_circle surface x y
; let dst_rect = Sdlvideo.rect ~x:(x*48) ~y:(y*48) ~w:48 ~h:48
  and n = Game.Tmap.get_cell (x, y - 1)
  and s = Game.Tmap.get_cell (x, y + 1)
  and e = Game.Tmap.get_cell (x - 1, y)
  and w = Game.Tmap.get_cell (x + 1, y) in
  if n*s*e*w = 0 && n+s+e+w != 0
  then begin
    if n = 0
    then Sdlvideo.blit_surface
           ~src:walls   ~src_rect:(Sdlvideo.rect ~x:48 ~y:0 ~w:48 ~h:48)
           ~dst:surface ~dst_rect:dst_rect ()
;   if s = 0
    then Sdlvideo.blit_surface
           ~src:walls   ~src_rect:(Sdlvideo.rect ~x:96 ~y:0 ~w:48 ~h:48)
           ~dst:surface ~dst_rect:dst_rect ()
;   if e = 0
    then Sdlvideo.blit_surface
           ~src:walls   ~src_rect:(Sdlvideo.rect ~x:144 ~y:0 ~w:48 ~h:48)
           ~dst:surface ~dst_rect:dst_rect ()
;   if w = 0
    then Sdlvideo.blit_surface
           ~src:walls   ~src_rect:(Sdlvideo.rect ~x:192 ~y:0 ~w:48 ~h:48)
           ~dst:surface ~dst_rect:dst_rect ()
  end

let render surface =
  for y = 0 to 20 do
    for x = 0 to 18 do
      if Game.Tmap.get_cell (x, y) = 0
      then render_cell surface x y
    done
  done
