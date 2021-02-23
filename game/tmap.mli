val at             : [`PACMAN | `GHOST] -> int * int -> [`UP | `DOWN | `LEFT | `RIGHT] list
val can_go         : int -> [`UP | `DOWN | `LEFT | `RIGHT] -> bool
val get_cell       : int * int -> int
val show_direction : [`UP | `DOWN | `LEFT | `RIGHT] -> string

val int_of_up    : int
val int_of_down  : int
val int_of_left  : int
val int_of_right : int
