class ghost name scater_target chase_target = object (self)

  val mutable going_out = true
  val mutable position  = (8, 9)
  val mutable last_pos  = (7, 9)
  val mutable target    = (9, 7)
  val mutable offset    = 0.0
  val mutable going      : [`UP | `DOWN | `LEFT | `RIGHT]             = `RIGHT
  val mutable the_status : [`SCATTER | `FRIGHTENED | `EATEN | `CHASE] = `SCATTER

  val show_status = function
    | `SCATTER    -> "scatter"
    | `FRIGHTENED -> "frightened"
    | `EATEN      -> "eaten"
    | `CHASE      -> "chase"

  method restart () =
    going_out  <- true
  ; position   <- (8, 9)
  ; last_pos   <- (7, 9)
  ; target     <- (9, 7)
  ; offset     <- 0.0
  ; going      <- `RIGHT
  ; the_status <- `SCATTER

  method name : string = name

  method looking = going

  method status = the_status

  method x (tpe : [`BOARD | `SCREEN]) =
    let (x, _) = position in
    match tpe with
      | `BOARD  -> x
      | `SCREEN -> x*48 +
                   if going = `LEFT || going = `RIGHT
                   then int_of_float offset
                   else 0

  method y (tpe : [`BOARD | `SCREEN]) =
    let (_, y) = position in
    match tpe with
      | `BOARD  -> y
      | `SCREEN -> y*48 +
                   if going = `UP || going = `DOWN
                   then int_of_float offset
                   else 0

  method xy (tpe : [`BOARD | `SCREEN]) = (self#x tpe, self#y tpe)

  method private runaway () =
    let (px, py) = Pacman.xy `BOARD
    and (x, y) = position in
    target <- (x*2 - px, y*2 - py)

  method private update_position new_position =
    last_pos <- position
  ; position <- new_position

  method private back =
    let (x, y) = position
    and (lx, ly) = last_pos in
    if lx < x
    then `LEFT
    else if lx > x
    then `RIGHT
    else if ly < y
    then `UP
    else `DOWN

  method private distance dir =
    let (x, y) = position
    and (tx, ty) = target in
    let (sx, sy) = match dir with
      | `UP    -> (x, y - 1)
      | `DOWN  -> (x, y + 1)
      | `LEFT  -> (x - 1, y)
      | `RIGHT -> (x + 1, y)
    in
    let dx = sx - tx
    and dy = sy - ty in
    dx*dx + dy*dy

  method private gohome () =
    if position = (8, 9)
    then begin
      self#chstatus `CHASE
    ; going_out <- true
    ; target <- (9, 7)
    end
    else if position = (9, 7)
    then target <- (8, 9)
    else begin
      let (x, y) = position in
      if y < 7 || y > 9 || x < 8 || x > 10
      then target <- (9, 7)
    end

  method private update_target () =
    if going_out
    then begin
      if position = target
      then (going_out <- false ; self#update_target ())
    end
    else match the_status with
      | `SCATTER    -> target <- scater_target
      | `FRIGHTENED -> self#runaway ()
      | `EATEN      -> self#gohome ()
      | `CHASE      -> target <- chase_target ()

  method private decide () =
    self#update_target ()
  ; let directions = Tmap.at `GHOST position
                  |> List.filter (fun d -> d != self#back)
                  |> List.map (fun d -> (self#distance d, d))
                  |> List.sort (fun (a, _) (b, _) -> compare a b)
                  |> List.map (fun (_, d) -> d) in
    match directions with
      | []     -> self#turnback ()
      | dir::_ -> going <- dir

  method private fix_x () =
    let sx = self#x `BOARD in
    if sx < -1
    then begin
      self#update_position (21 + sx, 9) (* MAGIC NUMBER, see map.ml *)
    ; going <- `LEFT
    end
    else if sx > 21
    then begin
      self#update_position (21 - sx, 9) (* MAGIC NUMBER, see map.ml *)
    ; going <- `RIGHT
    end

  method private fix_offset () =
    let (x, y) = self#xy `BOARD in
    if offset <= -48.0
    then begin
      if going = `UP
      then self#update_position (x, y-1)
      else (self#update_position (x-1, y) ; self#fix_x ())
    ; offset <- offset +. 48.0
    end
    else if offset >= 48.0
    then begin
      if going = `DOWN
      then self#update_position (x, y+1)
      else (self#update_position (x+1, y) ; self#fix_x ())
    ; offset <- offset -. 48.0
    end

  method private check_colision () =
    if position = Pacman.xy `BOARD && the_status != `EATEN
    then begin
      Signal.emit "collision" [Signal.String (show_status the_status)]
    ; if the_status = `FRIGHTENED
      then self#chstatus `EATEN
    end

  method private turnback () =
    going <- self#back
  ; let (x, y) = position in
    match going with
      | `UP    -> last_pos <- (x, y+1)
      | `DOWN  -> last_pos <- (x, y-1)
      | `LEFT  -> last_pos <- (x+1, y)
      | `RIGHT -> last_pos <- (x-1, y)

  method chstatus new_status =
    if new_status != the_status
    then (self#turnback () ; the_status <- new_status)

  method update dt =
    self#decide ()
  ; let speed = dt *. (Globals.speed ()) in
    let speed = speed *. match going with
      | `UP   | `LEFT  -> -1.0
      | `DOWN | `RIGHT -> 1.0
    in
    offset <- offset +. speed
  ; self#fix_offset ()
  ; self#check_colision ()
end
