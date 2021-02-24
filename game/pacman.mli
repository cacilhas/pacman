val connect_handles : unit -> unit
val go              : Tmap.direction -> unit
val gonna           : unit -> Tmap.direction
val looking         : unit -> [`LEFT | `RIGHT]
val xy              : [`BOARD | `SCREEN] -> int * int
