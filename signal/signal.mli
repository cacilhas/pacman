type handle
type arg = Float of float
         | Int of int
         | String of string
type callback = arg list -> unit

val emit       : string -> arg list -> unit
val get        : handle -> string * callback
val register   : string -> callback -> handle
val unregister : string -> handle -> unit
