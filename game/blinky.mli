val looking  : unit -> Tmap.direction
val status   : unit -> Ghost.status
val xy       : [`BOARD | `SCREEN] -> int * int

(* Signals *)
val chstatus : Signal.arg list -> unit
val restart  : Signal.arg list -> unit
val update   : Signal.arg list -> unit
