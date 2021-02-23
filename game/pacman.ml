let position = ref (9, 15)
let offset   = ref 0.0

let going      : Tmap.nullable_direction ref = ref `NONE
let required   : Tmap.direction ref          = ref `UP
let left_right : [`LEFT | `RIGHT] ref        = ref `LEFT

let go dir = required := dir

let looking () = !left_right

let restart _ =
  position   := (9, 15)
; offset     := 0.0
; going      := `NONE
; required   := `UP
; left_right := `LEFT

let x tpe =
  let (sx, _) = !position in
  match tpe with
    | `BOARD  -> sx
    | `SCREEN -> sx*48 +
                 if !going = `LEFT || !going = `RIGHT
                 then int_of_float !offset
                 else 0

let y tpe =
  let (_, sy) = !position in
  match tpe with
    | `BOARD  -> sy
    | `SCREEN -> sy*48 +
                 if !going = `UP || !going = `DOWN
                 then int_of_float !offset
                 else 0

let xy tpe = (x tpe, y tpe)

let decide () =
  let (x, y) = !position in
  [`Pair (x, y)] |> Signal.emit "gotta"
; let directions = Tmap.at `PACMAN !position in
  if Float.abs !offset < 20.0 && List.mem !required directions
  then begin
    going := (!required :> Tmap.nullable_direction)
  ; if !going = `LEFT
    then left_right := `LEFT
    else if !going = `RIGHT
    then left_right := `RIGHT
  end
  else match !going with
    | `NONE  -> ()
    | `UP    -> if not (List.mem `UP directions)
                then going := `NONE
    | `DOWN  -> if not (List.mem `DOWN directions)
                then going := `NONE
    | `LEFT  -> left_right := `LEFT
              ; if not (List.mem `LEFT directions)
                then going := `NONE
    | `RIGHT -> left_right := `RIGHT
              ; if not (List.mem `RIGHT directions)
                then going := `NONE

let fix_x () =
  let sx = x `BOARD in
  if sx < -1
  then begin
    position := (21 + sx, 9) (* MAGIC NUMBER, see map.ml *)
  ; going := `LEFT
  end
  else if sx > 21
  then begin
    position := (21 - sx, 9) (* MAGIC NUMBER, see map.ml *)
  ; going := `RIGHT
  end

let fix_offset () =
  let (sx, sy) = xy `BOARD in
  if !offset <= -48.0
  then begin
    if !going = `UP
    then position := (sx, sy - 1)
    else begin
      position := (sx - 1, sy)
    ; fix_x ()
    end
  ; offset := !offset +. 48.0
  end
  else if !offset >= 48.0
  then begin
    if !going = `DOWN
    then position := (sx, sy + 1)
    else begin
      position := (sx + 1, sy)
    ; fix_x ()
    end
  ; offset := !offset -. 48.00
  end
; decide ()

let gonna () = !going

let collision = function
  | [`String st] -> if st != "frightened"
                    then Signal.emit "restart" []
  | _ -> ()

let update = function
  | [`Float dt] -> let speed = dt *. (Globals.speed ()) in
                   let speed = speed *. match !going with
                     | `UP   | `LEFT  -> -1.0
                     | `DOWN | `RIGHT -> 1.0
                     | `NONE          -> 0.0
                   in
                   offset := !offset +. speed
                 ; if speed != 0.0
                   then fix_offset ()
  | _ -> ()
