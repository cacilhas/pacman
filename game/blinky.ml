let chase_target () = Pacman.xy `BOARD

let ghost = new Ghost.ghost "blinky" (16, -1) chase_target

let do_chstatus = function
  | Some status -> ghost#chstatus status
  | None        -> ()

let chstatus = function
  | [`String status] -> Ghost.status_of_string status |> do_chstatus
  | _ -> ()

let restart _ = ghost#restart ()

let update = function
  | [`Float dt] -> ghost#update dt
  | _ -> ()

let looking () = ghost#looking

let status () = ghost#status

let xy tpe = ghost#xy tpe
