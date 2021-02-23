val render_on :
  Sdlvideo.surface ->
  int * int ->
  [`BLINKY | `PINKY | `INKY | `CLYDE] ->
  [`SCATTER | `FRIGHTENED | `EATEN | `CHASE] ->
  [`UP | `DOWN | `LEFT | `RIGHT] ->
  unit
val update : Signal.arg list -> unit
