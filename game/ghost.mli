type status = [ `CHASE
              | `EATEN
              | `FRIGHTENED
              | `SCATTER
              ]

class ghost : string -> int * int -> (unit -> int * int) -> object

  method chstatus : status -> unit
  method looking  : Tmap.direction
  method name     : string
  method restart  : unit -> unit
  method status   : status
  method update   : float -> unit
  method x        : [`BOARD | `SCREEN] -> int
  method y        : [`BOARD | `SCREEN] -> int
  method xy       : [`BOARD | `SCREEN] -> int * int
end

val status_of_string : string -> status option
val string_of_status : status -> string
