val highscore : unit -> int
val score     : int -> int
val speed     : unit -> float

(* Signals *)
val collision : Signal.arg list -> unit
val restart   : Signal.arg list -> unit
val scored    : Signal.arg list -> unit
