val chstatus : Signal.arg list -> unit
val looking  : unit -> [`UP | `DOWN | `LEFT | `RIGHT]
val status   : unit -> [`SCATTER | `FRIGHTENED | `EATEN | `CHASE]
val update   : Signal.arg list -> unit
val xy       : [`BOARD | `SCREEN] -> int * int
