val go        : [`UP | `DOWN | `LEFT | `RIGHT] -> unit
val gonna     : unit -> [`UP | `DOWN | `LEFT | `RIGHT | `NONE]
val render_on : Sdlvideo.surface -> unit
val update    : float -> unit
