val x  : [`BOARD | `SCREEN] -> int
val y  : [`BOARD | `SCREEN] -> int
val xy : [`BOARD | `SCREEN] -> int * int

val go      : Tmap.direction -> unit
val gonna   : unit -> Tmap.direction
val looking : unit -> [`LEFT | `RIGHT]

(* Signals *)
val restart   : Signal.arg list -> unit
val update    : Signal.arg list -> unit
