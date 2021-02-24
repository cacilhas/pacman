val get_cell : int * int -> int

(* Signals *)
val eat     : Signal.arg list -> unit
val restart : Signal.arg list -> unit
val resting : unit -> int
