let numbers =
  let surface = Sdlvideo.create_RGB_surface [`HWSURFACE; `SRCALPHA]
                ~w:160 ~h:32 ~bpp:32
                ~rmask:Screen_info.rmask
                ~gmask:Screen_info.gmask
                ~bmask:Screen_info.bmask
                ~amask:Screen_info.amask
  in
  let color = Sdlvideo.map_RGB surface Sdlvideo.white in
  (* 0 *)
  Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:0  ~y:0  ~w:16 ~h:2)  surface color
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:0  ~y:0  ~w:2  ~h:32) surface color
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:14 ~y:0  ~w:2  ~h:32) surface color
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:0  ~y:30 ~w:16 ~h:2)  surface color
  (* 1 *)
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:30 ~y:0 ~w:2 ~h:32) surface color
  (* 2 *)
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:32 ~y:0  ~w:16 ~h:2)  surface color
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:32 ~y:0  ~w:2  ~h:16) surface color
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:32 ~y:15 ~w:16 ~h:2)  surface color
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:46 ~y:16 ~w:2  ~h:16) surface color
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:32 ~y:30 ~w:16 ~h:2)  surface color
  (* 3 *)
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:48 ~y:0  ~w:16 ~h:2) surface color
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:62 ~y:0  ~w:2 ~h:32) surface color
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:48 ~y:15 ~w:16 ~h:2) surface color
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:48 ~y:30 ~w:16 ~h:2) surface color
  (* 4 *)
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:64 ~y:0  ~w:2  ~h:16) surface color
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:78 ~y:0  ~w:2  ~h:32) surface color
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:64 ~y:15 ~w:16 ~h:2)  surface color
  (* 5 *)
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:80 ~y:0  ~w:16 ~h:2)  surface color
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:80 ~y:0  ~w:2  ~h:16) surface color
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:80 ~y:15 ~w:16 ~h:2)  surface color
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:94 ~y:16 ~w:2  ~h:16) surface color
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:80 ~y:30 ~w:16 ~h:2)  surface color
  (* 6 *)
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:96  ~y:0  ~w:16 ~h:2)  surface color
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:96  ~y:0  ~w:2  ~h:32) surface color
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:96  ~y:15 ~w:16 ~h:2)  surface color
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:110 ~y:16 ~w:2  ~h:16) surface color
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:96  ~y:30 ~w:16 ~h:2)  surface color
  (* 7 *)
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:112 ~y:0 ~w:16 ~h:2)  surface color
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:126 ~y:0 ~w:2  ~h:32) surface color
  (* 8 *)
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:128 ~y:0  ~w:16 ~h:2)  surface color
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:128 ~y:0  ~w:2  ~h:32) surface color
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:142 ~y:0  ~w:2  ~h:32) surface color
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:128 ~y:15 ~w:16 ~h:2)  surface color
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:128 ~y:30 ~w:16 ~h:2)  surface color
  (* 9 *)
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:144 ~y:0  ~w:16 ~h:2)  surface color
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:144 ~y:0  ~w:2  ~h:16) surface color
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:158 ~y:0  ~w:2  ~h:32) surface color
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:144 ~y:15 ~w:16 ~h:2)  surface color
; surface

let render surface (x, y) value =
  for g = 0 to 6 do
    let cur = (value / (int_of_float (10.0 ** float_of_int (6 - g)))) mod 10
    and dx = x*48 + 18*g
    and dy = y*48 + 8 in
    let src_rect = Sdlvideo.rect ~x:(cur*16) ~y:0  ~w:16 ~h:32
    and dst_rect = Sdlvideo.rect ~x:dx       ~y:dy ~w:18 ~h:32 in
    Sdlvideo.blit_surface ~src:numbers ~src_rect:src_rect
                          ~dst:surface ~dst_rect:dst_rect ()
  done
