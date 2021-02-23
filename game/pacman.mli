val x  : [`BOARD | `SCREEN] -> int
val y  : [`BOARD | `SCREEN] -> int
val xy : [`BOARD | `SCREEN] -> int * int

val go      : [`UP | `DOWN | `LEFT | `RIGHT] -> unit
val gonna   : unit -> [`UP | `DOWN | `LEFT | `RIGHT | `NONE]
val looking : unit -> [`LEFT | `RIGHT]

(* Signals *)
val collision : Signal.arg list -> unit
val restart   : Signal.arg list -> unit
val update    : Signal.arg list -> unit
