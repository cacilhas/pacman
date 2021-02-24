type status = [ `CHASE
              | `EATEN
              | `FRIGHTENED
              | `SCATTER
              ]

val connect_handles  : unit -> unit
val highscore        : unit -> int
val score            : int -> int
val speed            : unit -> float
val status_of_string : string -> status option
val string_of_status : status -> string
