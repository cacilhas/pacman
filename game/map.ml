let map = String.concat ""
  [ "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
  ; "\x00\xAA\xCC\xCC\xEE\xCC\xCC\xCC\x66\x00\xAA\xCC\xCC\xCC\xEE\xCC\xCC\x66\x00"
  ; "\x00\x33\x00\x00\x33\x00\x00\x00\x33\x00\x33\x00\x00\x00\x33\x00\x00\x33\x00"
  ; "\x00\xBB\xCC\xCC\xFF\xCC\xEE\xCC\xDD\xCC\xDD\xCC\xEE\xCC\xFF\xCC\xCC\x77\x00"
  ; "\x00\x33\x00\x00\x33\x00\x33\x00\x00\x00\x00\x00\x33\x00\x33\x00\x00\x33\x00"
  ; "\x00\x99\xCC\xCC\x77\x00\x99\xCC\x66\x00\xAA\xCC\x55\x00\xBB\xCC\xCC\x55\x00"
  ; "\x00\x00\x00\x00\x33\x00\x00\x00\x33\x00\x33\x00\x00\x00\x33\x00\x00\x00\x00"
  ; "\x00\x00\x00\x00\x33\x00\xAA\xCC\xCD\xCC\xCD\xCC\xAA\x00\x33\x00\x00\x00\x00"
  ; "\xCC\xCC\xCC\xCC\xFF\xCC\x77\x00\x80\xD0\x40\x00\xBB\xFF\xCC\xCC\xCC\xCC\xCC"
  ; "\x00\x00\x00\x00\x33\x00\x33\x00\x00\x00\x00\x00\x33\x00\x33\x00\x00\x00\x00"
  ; "\x00\x00\x00\x00\x33\x00\xBB\xCC\xCC\xCC\xCC\xCC\x77\x00\x33\x00\x00\x00\x00"
  ; "\x00\xAA\xCC\xCC\xFF\xCC\xDD\xCC\x66\x00\xAA\xCC\xDD\xCC\xFF\xCC\xCC\x66\x00"
  ; "\x00\x33\x00\x00\x33\x00\x00\x00\x33\x00\x33\x00\x00\x00\x33\x00\x00\x33\x00"
  ; "\x00\x99\x66\x00\xBB\xCC\xEE\xCC\xCD\xCC\xCD\xCC\xEE\xCC\x77\x00\xAA\x55\x00"
  ; "\x00\x00\x33\x00\x33\x00\x33\x00\x00\x00\x00\x00\x33\x00\x33\x00\x33\x00\x00"
  ; "\x00\xAA\xDD\xCC\x55\x00\x99\xCC\x66\x00\xAA\xCC\x55\x00\x99\xCC\xDD\x66\x00"
  ; "\x00\x33\x00\x00\x00\x00\x00\x00\x33\x00\x33\x00\x00\x00\x00\x00\x00\x33\x00"
  ; "\x00\x99\xCC\xCC\xCC\xCC\xCC\xCC\xDD\xCC\xDD\xCC\xCC\xCC\xCC\xCC\xCC\x55\x00"
  ; "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
  ]

let can_go direction c = match direction with
  | `UP    -> c land 1 != 0
  | `DOWN  -> c land 2 != 0
  | `LEFT  -> c land 4 != 0
  | `RIGHT -> c land 8 != 0

let get_cell x y = int_of_char map.[y*19 + x]


(*******************************************************************************
 * Tests
 *)

let%test_unit "map should be enclosed" =
  for y = 0 to 18 do
    if y != 8
    then begin
      let got = get_cell 0 y in
      if got != 0
      then Failure (Printf.sprintf "expected 0 at 0,%d, got %d" y got) |> raise
    ; let got = get_cell 18 y in
      if got != 0
      then Failure (Printf.sprintf "expected 0 at 18,%d, got %d" y got) |> raise
    end
  done
; for x = 0 to 18 do
  let got = get_cell x 0 in
  if got != 0
  then Failure (Printf.sprintf "expected 0 at %d,0, got %d" x got) |> raise
; let got = get_cell x 18 in
  if got != 0
  then Failure (Printf.sprintf "expected 0 at %d,18, got %d" x got) |> raise
  done

let%test "map should have two exits" =
  (get_cell 0 8 = 204) && (get_cell 18 8 = 204)

let%test "can_go up" =
  (not (can_go `UP 0))
  && (can_go `UP 1)
  && (not (can_go `UP 2))
  && (can_go `UP 3)
  && (not (can_go `UP 4))
  && (can_go `UP 5)
  && (not (can_go `UP 6))
  && (can_go `UP 7)
  && (not (can_go `UP 8))
  && (can_go `UP 9)
  && (not (can_go `UP 10))
  && (can_go `UP 11)
  && (not (can_go `UP 12))
  && (can_go `UP 13)
  && (not (can_go `UP 14))
  && (can_go `UP 15)

let%test "can_go down" =
  (not (can_go `DOWN 0))
  && (not (can_go `DOWN 1))
  && (can_go `DOWN 2)
  && (can_go `DOWN 3)
  && (not (can_go `DOWN 4))
  && (not (can_go `DOWN 5))
  && (can_go `DOWN 6)
  && (can_go `DOWN 7)
  && (not (can_go `DOWN 8))
  && (not (can_go `DOWN 9))
  && (can_go `DOWN 10)
  && (can_go `DOWN 11)
  && (not (can_go `DOWN 12))
  && (not (can_go `DOWN 13))
  && (can_go `DOWN 14)
  && (can_go `DOWN 15)

let%test "can_go left" =
  (not (can_go `LEFT 0))
  && (not (can_go `LEFT 1))
  && (not (can_go `LEFT 2))
  && (not (can_go `LEFT 3))
  && (can_go `LEFT 4)
  && (can_go `LEFT 5)
  && (can_go `LEFT 6)
  && (can_go `LEFT 7)
  && (not (can_go `LEFT 8))
  && (not (can_go `LEFT 9))
  && (not (can_go `LEFT 10))
  && (not (can_go `LEFT 11))
  && (can_go `LEFT 12)
  && (can_go `LEFT 13)
  && (can_go `LEFT 14)
  && (can_go `LEFT 15)

let%test "can_go right" =
  (not (can_go `RIGHT 0))
  && (not (can_go `RIGHT 1))
  && (not (can_go `RIGHT 2))
  && (not (can_go `RIGHT 3))
  && (not (can_go `RIGHT 4))
  && (not (can_go `RIGHT 5))
  && (not (can_go `RIGHT 6))
  && (not (can_go `RIGHT 7))
  && (can_go `RIGHT 8)
  && (can_go `RIGHT 9)
  && (can_go `RIGHT 10)
  && (can_go `RIGHT 11)
  && (can_go `RIGHT 12)
  && (can_go `RIGHT 13)
  && (can_go `RIGHT 14)
  && (can_go `RIGHT 15)
