type status = [ `CHASE
              | `EATEN
              | `FRIGHTENED
              | `SCATTER
              ]

val highscore        : unit -> int
val score            : int -> int
val speed            : unit -> float
val status_of_string : string -> status option
val string_of_status : status -> string

(* Signals *)
val collision : Signal.arg list -> unit
val restart   : Signal.arg list -> unit
val scored    : Signal.arg list -> unit
