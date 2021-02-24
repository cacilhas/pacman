let frames =
  let surface = Sdlvideo.create_RGB_surface [`HWSURFACE; `SRCALPHA]
                ~w:192 ~h:288 ~bpp:32
                ~rmask:Screen_info.rmask
                ~gmask:Screen_info.gmask
                ~bmask:Screen_info.bmask
                ~amask:Screen_info.amask
  in
  let blinky = Sdlvideo.map_RGB surface (255, 0, 0)
  and pinky = Sdlvideo.map_RGB surface (255, 184, 255)
  and inky = Sdlvideo.map_RGB surface (0, 255, 255)
  and clyde = Sdlvideo.map_RGB surface (255, 184, 82)
  and white = Sdlvideo.map_RGB surface Sdlvideo.white
  and blue = Sdlvideo.map_RGB surface Sdlvideo.blue in
  for i = 0 to 3 do (* ghosts *)
    Sdlhelpers.fill_semicircle surface ~x:(i*48+24) ~y:24 ~radius:23 blinky
  ; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:(i*48+1) ~y:24 ~w:46 ~h:18) surface blinky
  ; Sdlhelpers.fill_circle surface ~x:(i*48+12) ~y:22 ~radius:10 white
  ; Sdlhelpers.fill_circle surface ~x:(i*48+36) ~y:22 ~radius:10 white
  ; Sdlhelpers.fill_semicircle surface ~x:(i*48+24) ~y:72 ~radius:23 pinky
  ; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:(i*48+1) ~y:72 ~w:46 ~h:18) surface pinky
  ; Sdlhelpers.fill_circle surface ~x:(i*48+12) ~y:70 ~radius:10 white
  ; Sdlhelpers.fill_circle surface ~x:(i*48+36) ~y:70 ~radius:10 white
  ; Sdlhelpers.fill_semicircle surface ~x:(i*48+24) ~y:120 ~radius:23 inky
  ; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:(i*48+1) ~y:120 ~w:46 ~h:18) surface inky
  ; Sdlhelpers.fill_circle surface ~x:(i*48+12) ~y:118 ~radius:10 white
  ; Sdlhelpers.fill_circle surface ~x:(i*48+36) ~y:118 ~radius:10 white
  ; Sdlhelpers.fill_semicircle surface ~x:(i*48+24) ~y:168 ~radius:23 clyde
  ; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:(i*48+1) ~y:168 ~w:46 ~h:18) surface clyde
  ; Sdlhelpers.fill_circle surface ~x:(i*48+12) ~y:166 ~radius:10 white
  ; Sdlhelpers.fill_circle surface ~x:(i*48+36) ~y:166 ~radius:10 white
  ; Sdlhelpers.fill_semicircle surface ~x:(i*48+24) ~y:264 ~radius:23 blue
  ; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:(i*48+1) ~y:264 ~w:46 ~h:18) surface blue
  ; Sdlhelpers.fill_circle surface ~x:(i*48+12) ~y:262 ~radius:10 white
  ; Sdlhelpers.fill_circle surface ~x:(i*48+36) ~y:262 ~radius:10 white
  done
; for i = 0 to 3 do (* eyes *)
    Sdlhelpers.fill_circle surface ~x:6   ~y:(i*48+16) ~radius:6 blue
  ; Sdlhelpers.fill_circle surface ~x:30  ~y:(i*48+16) ~radius:6 blue
  ; Sdlhelpers.fill_circle surface ~x:54  ~y:(i*48+28) ~radius:6 blue
  ; Sdlhelpers.fill_circle surface ~x:78  ~y:(i*48+28) ~radius:6 blue
  ; Sdlhelpers.fill_circle surface ~x:114 ~y:(i*48+28) ~radius:6 blue
  ; Sdlhelpers.fill_circle surface ~x:138 ~y:(i*48+28) ~radius:6 blue
  ; Sdlhelpers.fill_circle surface ~x:162 ~y:(i*48+16) ~radius:6 blue
  ; Sdlhelpers.fill_circle surface ~x:186 ~y:(i*48+16) ~radius:6 blue
  done
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:0   ~y:42  ~w:6 ~h:5) surface blinky
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:12  ~y:42  ~w:6 ~h:5) surface blinky
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:24  ~y:42  ~w:6 ~h:5) surface blinky
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:36  ~y:42  ~w:5 ~h:5) surface blinky
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:55  ~y:42  ~w:6 ~h:5) surface blinky
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:66  ~y:42  ~w:6 ~h:5) surface blinky
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:78  ~y:42  ~w:6 ~h:5) surface blinky
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:90  ~y:42  ~w:5 ~h:5) surface blinky
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:96  ~y:42  ~w:6 ~h:5) surface blinky
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:108 ~y:42  ~w:6 ~h:5) surface blinky
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:120 ~y:42  ~w:6 ~h:5) surface blinky
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:132 ~y:42  ~w:5 ~h:5) surface blinky
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:150 ~y:42  ~w:6 ~h:5) surface blinky
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:162 ~y:42  ~w:6 ~h:5) surface blinky
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:174 ~y:42  ~w:6 ~h:5) surface blinky
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:186 ~y:42  ~w:5 ~h:5) surface blinky
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:0   ~y:90  ~w:6 ~h:5) surface pinky
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:12  ~y:90  ~w:6 ~h:5) surface pinky
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:24  ~y:90  ~w:6 ~h:5) surface pinky
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:36  ~y:90  ~w:5 ~h:5) surface pinky
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:55  ~y:90  ~w:6 ~h:5) surface pinky
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:66  ~y:90  ~w:6 ~h:5) surface pinky
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:78  ~y:90  ~w:6 ~h:5) surface pinky
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:90  ~y:90  ~w:5 ~h:5) surface pinky
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:96  ~y:90  ~w:6 ~h:5) surface pinky
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:108 ~y:90  ~w:6 ~h:5) surface pinky
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:120 ~y:90  ~w:6 ~h:5) surface pinky
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:132 ~y:90  ~w:5 ~h:5) surface pinky
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:150 ~y:90  ~w:6 ~h:5) surface pinky
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:162 ~y:90  ~w:6 ~h:5) surface pinky
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:174 ~y:90  ~w:6 ~h:5) surface pinky
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:186 ~y:90  ~w:5 ~h:5) surface pinky
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:0   ~y:138 ~w:6 ~h:5) surface inky
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:12  ~y:138 ~w:6 ~h:5) surface inky
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:24  ~y:138 ~w:6 ~h:5) surface inky
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:36  ~y:138 ~w:5 ~h:5) surface inky
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:55  ~y:138 ~w:6 ~h:5) surface inky
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:66  ~y:138 ~w:6 ~h:5) surface inky
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:78  ~y:138 ~w:6 ~h:5) surface inky
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:90  ~y:138 ~w:5 ~h:5) surface inky
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:96  ~y:138 ~w:6 ~h:5) surface inky
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:108 ~y:138 ~w:6 ~h:5) surface inky
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:120 ~y:138 ~w:6 ~h:5) surface inky
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:132 ~y:138 ~w:5 ~h:5) surface inky
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:150 ~y:138 ~w:6 ~h:5) surface inky
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:162 ~y:138 ~w:6 ~h:5) surface inky
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:174 ~y:138 ~w:6 ~h:5) surface inky
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:186 ~y:138 ~w:5 ~h:5) surface inky
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:0   ~y:186 ~w:6 ~h:5) surface clyde
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:12  ~y:186 ~w:6 ~h:5) surface clyde
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:24  ~y:186 ~w:6 ~h:5) surface clyde
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:36  ~y:186 ~w:5 ~h:5) surface clyde
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:55  ~y:186 ~w:6 ~h:5) surface clyde
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:66  ~y:186 ~w:6 ~h:5) surface clyde
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:78  ~y:186 ~w:6 ~h:5) surface clyde
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:90  ~y:186 ~w:5 ~h:5) surface clyde
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:96  ~y:186 ~w:6 ~h:5) surface clyde
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:108 ~y:186 ~w:6 ~h:5) surface clyde
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:120 ~y:186 ~w:6 ~h:5) surface clyde
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:132 ~y:186 ~w:5 ~h:5) surface clyde
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:150 ~y:186 ~w:6 ~h:5) surface clyde
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:162 ~y:186 ~w:6 ~h:5) surface clyde
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:174 ~y:186 ~w:6 ~h:5) surface clyde
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:186 ~y:186 ~w:5 ~h:5) surface clyde
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:0   ~y:282 ~w:6 ~h:5) surface blue
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:12  ~y:282 ~w:6 ~h:5) surface blue
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:24  ~y:282 ~w:6 ~h:5) surface blue
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:36  ~y:282 ~w:5 ~h:5) surface blue
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:55  ~y:282 ~w:6 ~h:5) surface blue
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:66  ~y:282 ~w:6 ~h:5) surface blue
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:78  ~y:282 ~w:6 ~h:5) surface blue
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:90  ~y:282 ~w:5 ~h:5) surface blue
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:96  ~y:282 ~w:6 ~h:5) surface blue
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:108 ~y:282 ~w:6 ~h:5) surface blue
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:120 ~y:282 ~w:6 ~h:5) surface blue
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:132 ~y:282 ~w:5 ~h:5) surface blue
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:150 ~y:282 ~w:6 ~h:5) surface blue
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:162 ~y:282 ~w:6 ~h:5) surface blue
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:174 ~y:282 ~w:6 ~h:5) surface blue
; Sdlvideo.fill_rect ~rect:(Sdlvideo.rect ~x:186 ~y:282 ~w:5 ~h:5) surface blue
  (* LEFT *)
; Sdlhelpers.fill_circle surface ~x:6  ~y:214 ~radius:6 blue
; Sdlhelpers.fill_circle surface ~x:30 ~y:214 ~radius:6 blue
  (* RIGHT *)
; Sdlhelpers.fill_circle surface ~x:66 ~y:214 ~radius:6 blue
; Sdlhelpers.fill_circle surface ~x:90 ~y:214 ~radius:6 blue
  (* UP *)
; Sdlhelpers.fill_circle surface ~x:108 ~y:208 ~radius:6 blue
; Sdlhelpers.fill_circle surface ~x:132 ~y:208 ~radius:6 blue
  (* DOWN *)
; Sdlhelpers.fill_circle surface ~x:156 ~y:220 ~radius:6 blue
; Sdlhelpers.fill_circle surface ~x:180 ~y:220 ~radius:6 blue
; surface

let cur_i = ref 0
let acc   = ref 0.0

let update = function
  | [`Float dt] -> acc := !acc +. dt
                 ; if !acc >= 0.12
                   then begin
                     acc := !acc -. 0.1
                   ; cur_i := (succ !cur_i) mod 4
                   end
  | _ -> ()

let current_frame i whereto =
  if i = 5
  then match whereto with
    | `UP    -> Sdlvideo.rect ~x:96  ~y:240 ~w:48 ~h:48
    | `DOWN  -> Sdlvideo.rect ~x:144 ~y:240 ~w:48 ~h:48
    | `LEFT  -> Sdlvideo.rect ~x:0   ~y:240 ~w:48 ~h:48
    | `RIGHT -> Sdlvideo.rect ~x:48  ~y:240 ~w:48 ~h:48
  else
  let x = !cur_i * 48
  and y = i * 48 in
  Sdlvideo.rect ~x:x ~y:y ~w:48 ~h:48

let frame_grp who how =
  if how = `EATEN
  then 4
  else if how = `FRIGHTENED
  then 5
  else
  match who with
    | `BLINKY -> 0
    | `PINKY  -> 1
    | `INKY   -> 2
    | `CLYDE  -> 3


let render_on surface (x, y) who how whereto =
  let i = frame_grp who how
  in
  let dst_rect = Sdlvideo.rect ~x:x ~y:y ~w:48 ~h:48
  and src_rect = current_frame i whereto in
  Sdlvideo.blit_surface ~src:frames  ~src_rect:src_rect
                        ~dst:surface ~dst_rect:dst_rect ()
