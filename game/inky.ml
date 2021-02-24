let chase_target _ =
  let (x, y) = Pacman.xy `BOARD in
  let (x, y) = match Pacman.gonna () with
    | `LEFT  -> (x-1, y)
    | `RIGHT -> (x+1, y)
    | `UP    -> (x, y-1)
    | `DOWN  -> (x, y+1)
  and (gx, gy) = Blinky.xy `BOARD in
  let dx = 2*x - gx
  and dy = 2*y - gy in
  (dx, dy)


let ghost = new Ghost.ghost "inky" (16, 21) chase_target

let do_chstatus = function
  | Some status -> ghost#chstatus status
  | None        -> ()

let chstatus = function
  | [`String status] -> if ghost#status != `EATEN
                        then do_chstatus (Globals.status_of_string status)
  | _                -> ()

let restart _ = ghost#restart ()

let update = function
  | [`Float dt] -> ghost#update dt
  | _ -> ()

let looking () = ghost#looking

let status () = ghost#status

let xy tpe = ghost#xy tpe
