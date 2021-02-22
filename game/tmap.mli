val at       : [`PACMAN | `GHOST] -> int * int -> [`UP | `DOWN | `LEFT | `RIGHT] list
val can_go   : int -> [`UP | `DOWN | `LEFT | `RIGHT] -> bool
val get_cell : int * int -> int
