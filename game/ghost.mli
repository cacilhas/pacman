class ghost : string -> int * int -> (unit -> int * int) -> object

  method chstatus : [`SCATTER | `FRIGHTENED | `EATEN | `CHASE] -> unit
  method looking  : [`UP | `DOWN | `LEFT | `RIGHT]
  method name     : string
  method restart  : unit -> unit
  method status   : [`SCATTER | `FRIGHTENED | `EATEN | `CHASE]
  method update   : float -> unit
  method x        : [`BOARD | `SCREEN] -> int
  method y        : [`BOARD | `SCREEN] -> int
  method xy       : [`BOARD | `SCREEN] -> int * int
end

val status_of_string : string -> [`SCATTER | `FRIGHTENED | `EATEN | `CHASE] option
val string_of_status : [`SCATTER | `FRIGHTENED | `EATEN | `CHASE] -> string
