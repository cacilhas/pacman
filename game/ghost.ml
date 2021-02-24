let home    = (8, 9)
let outside = (9, 7)

class ghost scatter_target chase_target = object (self)

  val mutable going_out = true
  val mutable position  = home
  val mutable last_pos  = (fst home - 1, snd home)
  val mutable target    = outside
  val mutable offset    = 0.0
  val mutable going      : Tmap.direction = `RIGHT
  val mutable the_status : Globals.status = `SCATTER

  method restart () =
    going_out  <- true
  ; position   <- home
  ; last_pos   <- (fst home - 1, snd home)
  ; target     <- outside
  ; offset     <- 0.0
  ; going      <- `RIGHT
  ; the_status <- `SCATTER

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
    if x <= 0 && lx >=18
    then `LEFT
    else if x >= 18 && lx <= 0
    then `RIGHT
    else if lx < x
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
    if position = home
    then begin
      self#chstatus `CHASE
    ; going_out <- true
    ; target <- outside
    end
    else if position = outside && target = outside
    then (target <- home; going <- `DOWN)
    else let (x, y) = position in
         if y < 8 || y > 9 || x < 8 || x > 10
         then target <- outside

  method private update_target () =
    if going_out
    then begin
      if position = target
      then (going_out <- false ; self#update_target ())
    end
    else match the_status with
      | `SCATTER    -> target <- scatter_target
      | `FRIGHTENED -> self#runaway ()
      | `EATEN      -> self#gohome ()
      | `CHASE      -> target <- chase_target (self :> ghost)

  method private add_home directions =
    if the_status = `EATEN
    then begin
      let (x, y) = position in
      if x = 9 && (y = 7 || y = 8)
      then `DOWN :: directions
      else directions
    end
    else directions

  method private frozen =
    if the_status = `FRIGHTENED
    then 0.75
    else 1.0

  method private remove_back d =
    let (x, _) = position in
    if x <= 0 || x >= 18
    then (d = `LEFT || d = `RIGHT) && d != self#back
    else d != self#back

  method private decide () =
    self#update_target ()
  ; let directions = Tmap.at `GHOST position
                  |> List.filter self#remove_back
                  |> List.map (fun d -> (self#distance d, d))
                  |> List.sort (fun (a, _) (b, _) -> compare a b)
                  |> List.map (fun (_, d) -> d)
                  |> self#add_home in
    match directions with
      | []     -> self#turnback ()
      | dir::_ -> going <- dir

  method private fix_x () =
    let sx = self#x `BOARD in
    if sx < -1
    then begin
      self#update_position (21 + sx, Tmap.centre)
    ; going <- `LEFT
    end
    else if sx > 21
    then begin
      self#update_position (21 - sx, Tmap.centre)
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
      Signal.emit "collision" [`String (Globals.string_of_status the_status)]
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
  ; let speed = dt *. (Globals.speed ()) *. self#frozen in
    let speed = speed *. match going with
      | `UP   | `LEFT  -> -1.0
      | `DOWN | `RIGHT -> 1.0
    in
    offset <- offset +. speed
  ; self#fix_offset ()
  ; self#check_colision ()
end


module type GHOST = sig

  val connect_handles : unit -> unit
  val looking         : unit -> Tmap.direction
  val status          : unit -> Globals.status
  val xy              : [`BOARD | `SCREEN] -> int * int
end


module type PROTOTYPE = sig

  val chase_target   : ghost -> int * int
  val scatter_target : unit -> int * int
end


module Prototype (G : PROTOTYPE) : GHOST = struct

  let me = new ghost (G.scatter_target ()) G.chase_target

  let do_chstatus = function
    | Some status -> me#chstatus status
    | None        -> ()

  let chstatus = function
    | [`String status] -> if me#status != `EATEN
                          then do_chstatus (Globals.status_of_string status)
    | _                -> ()

  let restart _ = me#restart ()

  let update = function
    | [`Float dt] -> me#update dt
    | _ -> ()

  let looking () = me#looking

  let status () = me#status

  let xy tpe = me#xy tpe

  let connect_handles () =
    Signal.connect "chstatus" chstatus |> ignore
  ; Signal.connect "levelup"  restart  |> ignore
  ; Signal.connect "restart"  restart  |> ignore
  ; Signal.connect "update"   update   |> ignore
end
