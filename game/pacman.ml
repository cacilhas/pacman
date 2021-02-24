type pacman = {
  mutable position : int * int
; mutable offset   : float
; mutable going    : Tmap.nullable_direction
; mutable required : Tmap.direction
; mutable lateral  : [`LEFT | `RIGHT]
}

let attrs = {
  position = (0, 0)
; offset   = 0.0
; going    = `NONE
; required = `UP
; lateral  = `LEFT
}

let get_x (tpe : [`BOARD | `SCREEN]) =
  let (sx, _) = attrs.position in
  match tpe with
    | `BOARD  -> sx
    | `SCREEN -> sx*48 +
                if attrs.going = `LEFT || attrs.going = `RIGHT
                then int_of_float attrs.offset
                else 0

let get_y (tpe : [`BOARD | `SCREEN]) =
  let (_, sy) = attrs.position in
  match tpe with
    | `BOARD  -> sy
    | `SCREEN -> sy*48 +
                if attrs.going = `UP || attrs.going = `DOWN
                then int_of_float attrs.offset
                else 0

let xy tpe = (get_x tpe, get_y tpe)

let decide () =
  let (x, y) = attrs.position in
  [`Pair (x, y)] |> Signal.emit "gotta"
; let directions = Tmap.at `PACMAN attrs.position in
  if Float.abs attrs.offset < 20.0 && List.mem attrs.required directions
  then begin
    attrs.going <- (attrs.required :> Tmap.nullable_direction)
  ; if attrs.going = `LEFT
    then attrs.lateral <- `LEFT
    else if attrs.going = `RIGHT
    then attrs.lateral <- `RIGHT
  end
  else match attrs.going with
    | `NONE  -> ()
    | `UP    -> if not (List.mem `UP directions)
                then attrs.going <- `NONE
    | `DOWN  -> if not (List.mem `DOWN directions)
                then attrs.going <- `NONE
    | `LEFT  -> attrs.lateral <- `LEFT
              ; if not (List.mem `LEFT directions)
                then attrs.going <- `NONE
    | `RIGHT -> attrs.lateral <- `RIGHT
              ; if not (List.mem `RIGHT directions)
                then attrs.going <- `NONE

let fix_x () =
  let sx = get_x `BOARD in
  if sx < -1
  then begin
    attrs.position <- (21 + sx, Tmap.centre)
  ; attrs.going <- `LEFT
  end
  else if sx > 21
  then begin
    attrs.position <- (21 - sx, Tmap.centre)
  ; attrs.going <- `RIGHT
  end

let fix_offset () =
  let sx = get_x `BOARD
  and sy = get_y `BOARD in
  if attrs.offset <= -48.0
  then begin
    if attrs.going = `UP
    then attrs.position <- (sx, sy - 1)
    else begin
      attrs.position <- (sx - 1, sy)
    ; fix_x ()
    end
  ; attrs.offset <- attrs.offset +. 48.0
  end
  else if attrs.offset >= 48.0
  then begin
    if attrs.going = `DOWN
    then attrs.position <- (sx, sy + 1)
    else begin
      attrs.position <- (sx + 1, sy)
    ; fix_x ()
    end
  ; attrs.offset <- attrs.offset -. 48.00
  end
; decide ()

let gonna () = match attrs.going with
  | `NONE  -> (attrs.lateral :> Tmap.direction)
  | `LEFT  -> `LEFT
  | `RIGHT -> `RIGHT
  | `UP    -> `UP
  | `DOWN  -> `DOWN

let go dir = attrs.required <- dir

let looking () = attrs.lateral

let restart _ =
  attrs.position <- (9, 15)
; attrs.offset   <- 0.0
; attrs.going    <- `NONE
; attrs.required <- `UP
; attrs.lateral  <- `LEFT

let update = function
  | [`Float dt] -> let speed = dt *. (Globals.speed ()) in
                   let speed = speed *. match attrs.going with
                     | `UP   | `LEFT  -> -1.0
                     | `DOWN | `RIGHT -> 1.0
                     | `NONE          -> 0.0
                   in
                   attrs.offset <- attrs.offset +. speed
                 ; if speed != 0.0
                   then fix_offset ()
  | _           -> ()

let connect_handles () =
  Signal.connect "levelup" restart  |> ignore
; Signal.connect "restart" restart  |> ignore
; Signal.connect "update"  update   |> ignore

let () = restart []
