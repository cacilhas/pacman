let chase_target clyde =
  let (x, y) = Pacman.xy `BOARD
  and (gx, gy) = clyde#xy `BOARD in
  let dx = x - gx
  and dy = y - gy in
  let d = (dx*dx) + (dy*dy) in
  if d >= 16
  then (x, y)
  else (2, 21)

let ghost = new Ghost.ghost "clyde" (2, 21) chase_target

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
