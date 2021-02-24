type status = [ `CHASE
              | `EATEN
              | `FRIGHTENED
              | `SCATTER
              ]

let status_of_string = function
  | "scatter"    -> Some `SCATTER
  | "frightened" -> Some `FRIGHTENED
  | "eaten"      -> Some `EATEN
  | "chase"      -> Some `CHASE
  | _            -> None

let string_of_status = function
  | `SCATTER    -> "scatter"
  | `FRIGHTENED -> "frightened"
  | `EATEN      -> "eaten"
  | `CHASE      -> "chase"

class globals = object (self)
  val mutable speed                 = 0.0
  val mutable highscore             = 0
  val mutable score                 = 0
  val mutable scatter_time          = 0.0
  val mutable chase_time            = 0.0
  val mutable passed_time           = 0.0
  val mutable frightened_time       = 0.0
  val mutable current_mode : status = `SCATTER

  method restart () =
    speed           <- 200.0
  ; score           <- 0
  ; scatter_time    <- 7.0
  ; chase_time      <- 20.0
  ; frightened_time <- 10.0
  ; passed_time     <- 0.0
  ; current_mode    <- `SCATTER

  initializer self#restart ()

  method speed = speed

  method highscore = highscore

  method reset_time () = passed_time <- 0.0

  method private update_highscore () =
    if score > highscore
    then highscore <- score

  method score i =
    begin
      match i with
        | 0 -> ()
        | 3 -> score <- score + 5
        | v -> score <- succ score
             ; Signal.emit "scored" [`Int v]
    end
  ; self#update_highscore ()
  ; score

  method levelup () =
    speed <- speed *. 0.25
  ; score <- score + 10
  ; self#update_highscore ()
  ; if scatter_time > 5.0
    then scatter_time <- scatter_time -. 0.4
  ; if frightened_time > 2.0
    then frightened_time <- frightened_time -. 1.0

  method chstatus status =
    current_mode <- status
  ; self#reset_time ()

  method update dt =
    passed_time <- passed_time +. dt
  ; match current_mode with
    | `SCATTER    -> if passed_time >= scatter_time
                    then Signal.emit "chstatus" [`String (string_of_status `CHASE)]
    | `CHASE      -> if passed_time >= chase_time
                    then Signal.emit "chstatus" [`String (string_of_status `SCATTER)]
    | `FRIGHTENED -> if passed_time >= frightened_time
                    then Signal.emit "chstatus" [`String (string_of_status `CHASE)]
    | _           -> ()
end

let g = new globals

let speed () = g#speed

let score i = 10 * g#score i

let highscore () = 10 * g#highscore

let deal_with_collision = function
  | Some `FRIGHTENED -> score 10                  |> ignore
  | Some _           ->  Signal.emit "restart" [] |> ignore
  | None             -> ()

let collision = function
  | [`String status] -> deal_with_collision (status_of_string status)
  | _                -> ()

let scored = function
  | [`Int 2] -> Signal.emit "chstatus" [`String (string_of_status `FRIGHTENED)]
              ; g#reset_time ()
  | _ -> ()

let levelup _ = g#levelup ()


let do_chstatus = function
  | Some status -> g#chstatus status
  | _           -> ()

let chstatus = function
  | [`String status] -> do_chstatus (status_of_string status)
  | _                -> ()

let restart _ = g#restart ()

let update = function
  | [`Float dt] -> g#update dt
  | _           -> ()

let connect_handles () =
  Signal.connect "chstatus"  chstatus  |> ignore
; Signal.connect "collision" collision |> ignore
; Signal.connect "levelup"   levelup   |> ignore
; Signal.connect "restart"   restart   |> ignore
; Signal.connect "scored"    scored    |> ignore
; Signal.connect "update"    update    |> ignore

let () = restart []
