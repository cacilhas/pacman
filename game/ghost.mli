class ghost : string -> int * int -> (ghost -> int * int) -> object

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


module type GHOST = sig

  val looking  : unit -> Tmap.direction
  val status   : unit -> Globals.status
  val xy       : [`BOARD | `SCREEN] -> int * int

  (* Signals *)
  val chstatus : Signal.arg list -> unit
  val restart  : Signal.arg list -> unit
  val update   : Signal.arg list -> unit
end


module type PROTOTYPE = sig

  val chase_target   : ghost -> int * int
  val scatter_target : unit -> int * int
end


module Prototype : functor (G : PROTOTYPE) -> GHOST
