val looking  : unit -> [`UP | `DOWN | `LEFT | `RIGHT]
val status   : unit -> [`SCATTER | `FRIGHTENED | `EATEN | `CHASE]
val xy       : [`BOARD | `SCREEN] -> int * int

(* Signals *)
val chstatus : Signal.arg list -> unit
val restart  : Signal.arg list -> unit
val update   : Signal.arg list -> unit
