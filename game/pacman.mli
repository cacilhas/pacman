val x  : [`BOARD | `SCREEN] -> int
val y  : [`BOARD | `SCREEN] -> int
val xy : [`BOARD | `SCREEN] -> int * int

val go       : [`UP | `DOWN | `LEFT | `RIGHT] -> unit
val gonna    : unit -> [`UP | `DOWN | `LEFT | `RIGHT | `NONE]
val pointing : unit -> [`LEFT | `RIGHT]
val update   : float -> unit
