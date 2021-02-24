val connect_handles : unit -> unit
val go              : Tmap.direction -> unit
val gonna           : unit -> Tmap.direction
val looking         : unit -> [`LEFT | `RIGHT]
val x               : [`BOARD | `SCREEN] -> int
val y               : [`BOARD | `SCREEN] -> int
val xy              : [`BOARD | `SCREEN] -> int * int
