class pacman = object (self)

  val mutable position = (0, 0)
  val mutable offset   = 0.0
  val mutable going    : Tmap.nullable_direction = `NONE
  val mutable required : Tmap.direction          = `UP
  val mutable lateral  : [`LEFT | `RIGHT]        = `LEFT

  method position = position

  method restart () =
    position <- (9, 15)
  ; offset   <- 0.0
  ; going    <- `NONE
  ; required <- `UP
  ; lateral  <- `LEFT

  initializer self#restart ()

  method go dir = required <- dir

  method looking = lateral

  method x (tpe : [`BOARD | `SCREEN]) =
    let (sx, _) = position in
    match tpe with
      | `BOARD  -> sx
      | `SCREEN -> sx*48 +
                  if going = `LEFT || going = `RIGHT
                  then int_of_float offset
                  else 0

  method y (tpe : [`BOARD | `SCREEN]) =
    let (_, sy) = position in
    match tpe with
      | `BOARD  -> sy
      | `SCREEN -> sy*48 +
                  if going = `UP || going = `DOWN
                  then int_of_float offset
                  else 0

  method private decide () =
    let (x, y) = position in
    [`Pair (x, y)] |> Signal.emit "gotta"
  ; let directions = Tmap.at `PACMAN position in
    if Float.abs offset < 20.0 && List.mem required directions
    then begin
      going <- (required :> Tmap.nullable_direction)
    ; if going = `LEFT
      then lateral <- `LEFT
      else if going = `RIGHT
      then lateral <- `RIGHT
    end
    else match going with
      | `NONE  -> ()
      | `UP    -> if not (List.mem `UP directions)
                  then going <- `NONE
      | `DOWN  -> if not (List.mem `DOWN directions)
                  then going <- `NONE
      | `LEFT  -> lateral <- `LEFT
                ; if not (List.mem `LEFT directions)
                  then going <- `NONE
      | `RIGHT -> lateral <- `RIGHT
                ; if not (List.mem `RIGHT directions)
                  then going <- `NONE

  method private fix_x () =
    let sx = self#x `BOARD in
    if sx < -1
    then begin
      position <- (21 + sx, 9) (* MAGIC NUMBER, see map.ml *)
    ; going <- `LEFT
    end
    else if sx > 21
    then begin
      position <- (21 - sx, 9) (* MAGIC NUMBER, see map.ml *)
    ; going <- `RIGHT
    end

  method private fix_offset () =
    let sx = self#x `BOARD
    and sy = self#y `BOARD in
    if offset <= -48.0
    then begin
      if going = `UP
      then position <- (sx, sy - 1)
      else begin
        position <- (sx - 1, sy)
      ; self#fix_x ()
      end
    ; offset <- offset +. 48.0
    end
    else if offset >= 48.0
    then begin
      if going = `DOWN
      then position <- (sx, sy + 1)
      else begin
        position <- (sx + 1, sy)
      ; self#fix_x ()
      end
    ; offset <- offset -. 48.00
    end
  ; self#decide ()

  method gonna = match going with
    | `NONE  -> (lateral :> Tmap.direction)
    | `LEFT  -> `LEFT
    | `RIGHT -> `RIGHT
    | `UP    -> `UP
    | `DOWN  -> `DOWN

  method update dt =
    let speed = dt *. (Globals.speed ()) in
    let speed = speed *. match going with
      | `UP   | `LEFT  -> -1.0
      | `DOWN | `RIGHT -> 1.0
      | `NONE          -> 0.0
    in
    offset <- offset +. speed
  ; if speed != 0.0
    then self#fix_offset ()
end

let player = new pacman

let go = player#go

let looking () = player#looking

let xy tpe = (player#x tpe, player#y tpe)

let gonna () = player#gonna

let restart _ = player#restart ()

let update = function
  | [`Float dt] -> player#update dt
  | _           -> ()

let connect_handles () =
  Signal.connect "levelup" restart  |> ignore
; Signal.connect "restart" restart  |> ignore
; Signal.connect "update"  update   |> ignore
