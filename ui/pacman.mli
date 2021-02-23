val go        : Game.Tmap.direction -> unit
val gonna     : unit -> [`UP | `DOWN | `LEFT | `RIGHT | `NONE]
val render_on : Sdlvideo.surface -> unit
val update    : Signal.arg list -> unit
