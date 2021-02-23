type handle
type arg = [ `Float of float
           | `Int of int
           | `Pair of int * int
           | `String of string
           ]
type callback = arg list -> unit

val debug      : bool -> unit
val emit       : string -> arg list -> unit
val get        : handle -> string * callback
val connect    : string -> callback -> handle
val disconnect : string -> handle -> unit
