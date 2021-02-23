val render_on :
  Sdlvideo.surface ->
  int * int ->
  [`BLINKY | `PINKY | `INKY | `CLYDE] ->
  Game.Ghost.status ->
  Game.Tmap.direction ->
  unit
val update : Signal.arg list -> unit
