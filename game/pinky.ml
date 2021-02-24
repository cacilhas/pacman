let chase_target _ =
  let (x, y) = Pacman.xy `BOARD in
  match Pacman.gonna () with
  | `LEFT  -> (x-4, y)
  | `RIGHT -> (x+4, y)
  | `UP    -> (x, y-4)
  | `DOWN  -> (x, y+4)

let ghost = new Ghost.ghost "pinky" (2, -1) chase_target

let do_chstatus = function
  | Some status -> ghost#chstatus status
  | None        -> ()

let chstatus = function
  | [`String status] -> do_chstatus (Globals.status_of_string status)
  | _                -> ()

let restart _ = ghost#restart ()

let update = function
  | [`Float dt] -> ghost#update dt
  | _ -> ()

let looking () = ghost#looking

let status () = ghost#status

let xy tpe = ghost#xy tpe
