let chase_target () = Pacman.xy `BOARD

let ghost = new Ghost.ghost "blinky" (16, -1) chase_target

let do_chstatus = function
  | "scatter"    -> ghost#chstatus `SCATTER
  | "frightened" -> ghost#chstatus `FRIGHTENED
  | "eaten"      -> ghost#chstatus `EATEN
  | "chase"      -> ghost#chstatus `CHASE
  | _            -> ()

let chstatus = function
  | [Signal.String status] -> do_chstatus status
  | _ -> ()

let restart _ = ghost#restart ()

let update = function
  | [Signal.Float dt] -> ghost#update dt
  | _ -> ()

let looking () = ghost#looking

let status () = ghost#status

let xy tpe = ghost#xy tpe
