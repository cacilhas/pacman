let map = String.concat ""
  [ "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
  ; "\x00\xAA\xCC\xCC\xEE\xCC\xCC\xCC\x66\x00\xAA\xCC\xCC\xCC\xEE\xCC\xCC\x66\x00"
  ; "\x00\x33\x00\x00\x33\x00\x00\x00\x33\x00\x33\x00\x00\x00\x33\x00\x00\x33\x00"
  ; "\x00\xBB\xCC\xCC\xFF\xCC\xEE\xCC\xDD\xCC\xDD\xCC\xEE\xCC\xFF\xCC\xCC\x77\x00"
  ; "\x00\x33\x00\x00\x33\x00\x33\x00\x00\x00\x00\x00\x33\x00\x33\x00\x00\x33\x00"
  ; "\x00\x99\xCC\xCC\x77\x00\x99\xCC\x66\x00\xAA\xCC\x55\x00\xBB\xCC\xCC\x55\x00"
  ; "\x00\x00\x00\x00\x33\x00\x00\x00\x33\x00\x33\x00\x00\x00\x33\x00\x00\x00\x00"
  ; "\x00\x00\x00\x00\x33\x00\xAA\xCC\xCD\xCC\xCD\xCC\x66\x00\x33\x00\x00\x00\x00"
  ; "\x00\x00\x00\x00\x33\x00\x33\x00\x00\xD0\x00\x00\x33\x00\x33\x00\x00\x00\x00"
  ; "\xCC\xCC\xCC\xCC\xFF\xCC\x77\x00\x80\xD0\x40\x00\xBB\xCC\xFF\xCC\xCC\xCC\xCC"
  ; "\x00\x00\x00\x00\x33\x00\x33\x00\x00\x00\x00\x00\x33\x00\x33\x00\x00\x00\x00"
  ; "\x00\x00\x00\x00\x33\x00\xBB\xCC\xCC\xCC\xCC\xCC\x77\x00\x33\x00\x00\x00\x00"
  ; "\x00\x00\x00\x00\x33\x00\x33\x00\x00\x00\x00\x00\x33\x00\x33\x00\x00\x00\x00"
  ; "\x00\xAA\xCC\xCC\xFF\xCC\xDD\xCC\x66\x00\xAA\xCC\xDD\xCC\xFF\xCC\xCC\x66\x00"
  ; "\x00\x33\x00\x00\x33\x00\x00\x00\x33\x00\x33\x00\x00\x00\x33\x00\x00\x33\x00"
  ; "\x00\x99\x66\x00\xBB\xCC\xEE\xCC\xCD\xCC\xCD\xCC\xEE\xCC\x77\x00\xAA\x55\x00"
  ; "\x00\x00\x33\x00\x33\x00\x33\x00\x00\x00\x00\x00\x33\x00\x33\x00\x33\x00\x00"
  ; "\x00\xAA\xDD\xCC\x55\x00\x99\xCC\x66\x00\xAA\xCC\x55\x00\x99\xCC\xDD\x66\x00"
  ; "\x00\x33\x00\x00\x00\x00\x00\x00\x33\x00\x33\x00\x00\x00\x00\x00\x00\x33\x00"
  ; "\x00\x99\xCC\xCC\xCC\xCC\xCC\xCC\xDD\xCC\xDD\xCC\xCC\xCC\xCC\xCC\xCC\x55\x00"
  ; "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
  ]

let int_of_up    = 1
let int_of_down  = 2
let int_of_left  = 4
let int_of_right = 8

let show_direction = function
  | `UP -> "up"
  | `DOWN -> "down"
  | `RIGHT -> "right"
  | `LEFT -> "left"

let can_go c direction = match direction with
  | `UP    -> c land int_of_up != 0
  | `DOWN  -> c land int_of_down != 0
  | `LEFT  -> c land int_of_left != 0
  | `RIGHT -> c land int_of_right != 0

let get_cell (x, y) =
  if x < 0 || x > 18 || y < 0 || y > 20
  then 255
  else int_of_char map.[y*19 + x]

let at actor position =
  let cell = get_cell position in
  let cell = match actor with
    | `GHOST  -> cell lsr 4
    | `PACMAN -> cell land 15
  in
  List.filter (can_go cell) [`UP; `DOWN; `LEFT; `RIGHT]


(*******************************************************************************
 * Tests
 *)

let%test_unit "map should be enclosed" =
  for y = 0 to 20 do
    if y != 9
    then begin
      let got = get_cell (0, y) in
      if got != 0
      then Failure (Printf.sprintf "expected 0 at 0,%d, got %d" y got) |> raise
    ; let got = get_cell (18, y) in
      if got != 0
      then Failure (Printf.sprintf "expected 0 at 18,%d, got %d" y got) |> raise
    end
  done
; for x = 0 to 18 do
  let got = get_cell (x, 0) in
  if got != 0
  then Failure (Printf.sprintf "expected 0 at %d,0, got %d" x got) |> raise
; let got = get_cell (x, 20) in
  if got != 0
  then Failure (Printf.sprintf "expected 0 at %d,18, got %d" x got) |> raise
  done
; for x = 2 to 16 do
    let got = get_cell (x, 19) in
    if (x = 8 || x = 10) && got != 221
    then Failure (Printf.sprintf "expected 221 at %d,19, got %d" x got) |> raise
    else if (x != 8 && x != 10) && got != 204
    then Failure (Printf.sprintf "expected 204 at %d,19, got %d" x got) |> raise
  done

let%test "map should have two exits" =
  (get_cell (0, 9) = 204) && (get_cell (18, 9) = 204)

let%test "can_go up" =
  (not (can_go 0 `UP))
  && (can_go 1 `UP)
  && (not (can_go 2 `UP))
  && (can_go 3 `UP)
  && (not (can_go 4 `UP))
  && (can_go 5 `UP)
  && (not (can_go 6 `UP))
  && (can_go 7 `UP)
  && (not (can_go 8 `UP))
  && (can_go 9 `UP)
  && (not (can_go 10 `UP))
  && (can_go 11 `UP)
  && (not (can_go 12 `UP))
  && (can_go 13 `UP)
  && (not (can_go 14 `UP))
  && (can_go 15 `UP)

let%test "can_go down" =
  (not (can_go 0 `DOWN))
  && (not (can_go 1 `DOWN))
  && (can_go 2 `DOWN)
  && (can_go 3 `DOWN)
  && (not (can_go 4 `DOWN))
  && (not (can_go 5 `DOWN))
  && (can_go 6 `DOWN)
  && (can_go 7 `DOWN)
  && (not (can_go 8 `DOWN))
  && (not (can_go 9 `DOWN))
  && (can_go 10 `DOWN)
  && (can_go 11 `DOWN)
  && (not (can_go 12 `DOWN))
  && (not (can_go 13 `DOWN))
  && (can_go 14 `DOWN)
  && (can_go 15 `DOWN)

let%test "can_go left" =
  (not (can_go 0 `LEFT))
  && (not (can_go 1 `LEFT))
  && (not (can_go 2 `LEFT))
  && (not (can_go 3 `LEFT))
  && (can_go 4 `LEFT)
  && (can_go 5 `LEFT)
  && (can_go 6 `LEFT)
  && (can_go 7 `LEFT)
  && (not (can_go 8 `LEFT))
  && (not (can_go 9 `LEFT))
  && (not (can_go 10 `LEFT))
  && (not (can_go 11 `LEFT))
  && (can_go 12 `LEFT)
  && (can_go 13 `LEFT)
  && (can_go 14 `LEFT)
  && (can_go 15 `LEFT)

let%test "can_go right" =
  (not (can_go 0 `RIGHT))
  && (not (can_go 1 `RIGHT))
  && (not (can_go 2 `RIGHT))
  && (not (can_go 3 `RIGHT))
  && (not (can_go 4 `RIGHT))
  && (not (can_go 5 `RIGHT))
  && (not (can_go 6 `RIGHT))
  && (not (can_go 7 `RIGHT))
  && (can_go 8 `RIGHT)
  && (can_go 9 `RIGHT)
  && (can_go 10 `RIGHT)
  && (can_go 11 `RIGHT)
  && (can_go 12 `RIGHT)
  && (can_go 13 `RIGHT)
  && (can_go 14 `RIGHT)
  && (can_go 15 `RIGHT)

let%test "pacman at 1, 1 should go left or down" =
  let options = at `PACMAN (1, 1) in
  (List.mem `RIGHT options)
  && (List.mem `DOWN options)
  && (not (List.mem `UP options))
  && (not (List.mem `LEFT options))

let%test "ghost at 1, 1 should go left or down" =
  let options = at `GHOST (1, 1) in
  (List.mem `RIGHT options)
  && (List.mem `DOWN options)
  && (not (List.mem `UP options))
  && (not (List.mem `LEFT options))

let%test "pacman at 8, 7 should go left, right, or up" =
  let options = at `PACMAN (8, 7) in
  (List.mem `RIGHT options)
  && (List.mem `LEFT options)
  && (List.mem `UP options)
  && (not (List.mem `DOWN options))

let%test "ghost at 8, 7 should go left or right" =
  let options = at `GHOST (8, 7) in
  (List.mem `RIGHT options)
  && (List.mem `LEFT options)
  && (not (List.mem `UP options))
  && (not (List.mem `DOWN options))
