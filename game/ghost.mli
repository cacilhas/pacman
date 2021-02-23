class ghost : string -> int * int -> (unit -> int * int) -> object

  method chstatus : Globals.status -> unit
  method looking  : Tmap.direction
  method name     : string
  method restart  : unit -> unit
  method status   : Globals.status
  method update   : float -> unit
  method x        : [`BOARD | `SCREEN] -> int
  method y        : [`BOARD | `SCREEN] -> int
  method xy       : [`BOARD | `SCREEN] -> int * int
end
