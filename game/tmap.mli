type direction = [ `UP
                 | `DOWN
                 | `LEFT
                 | `RIGHT
                 ]

type nullable_direction = [ `NONE
                          | `UP
                          | `DOWN
                          | `LEFT
                          | `RIGHT
                          ]

val at             : [`PACMAN | `GHOST] -> int * int -> direction list
val can_go         : int -> direction -> bool
val get_cell       : int * int -> int
val show_direction : direction -> string

val int_of_up    : int
val int_of_down  : int
val int_of_left  : int
val int_of_right : int
