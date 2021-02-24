type status = [ `CHASE
              | `EATEN
              | `FRIGHTENED
              | `SCATTER
              ]

type globals = {
  mutable chase_time      : float
; mutable frightened_time : float
; mutable highscore       : int
; mutable mode            : status
; mutable passed_time     : float
; mutable scatter_time    : float
; mutable score           : int
; mutable speed           : float
}

let g = {
  speed           = 200.0
; score           = 0
; highscore       = 0
; scatter_time    = 7.0
; chase_time      = 20.0
; frightened_time = 10.0
; passed_time     = 0.0
; mode            = `SCATTER
}

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

let update_highscore () =
  if g.score > g.highscore
  then g.highscore <- g.score

let speed () = g.speed

let score i =
  begin
    match i with
      | 0 -> ()
      | 3 -> g.score <- g.score + 5
      | v -> g.score <- succ g.score
            ; Signal.emit "scored" [`Int v]
  end
; update_highscore ()
; g.score * 10

let highscore () = 10 * g.highscore

let deal_with_collision = function
  | Some `FRIGHTENED -> score 10                  |> ignore
  | Some _           ->  Signal.emit "restart" [] |> ignore
  | None             -> ()

let collision = function
  | [`String status] -> deal_with_collision (status_of_string status)
  | _                -> ()

let scored = function
  | [`Int 2] -> Signal.emit "chstatus" [`String (string_of_status `FRIGHTENED)]
              ; g.passed_time <- 0.0
  | _ -> ()

let levelup _ =
    g.speed <- g.speed *. 0.25
  ; g.score <- g.score + 10
  ; update_highscore ()
  ; if g.scatter_time > 5.0
    then g.scatter_time <- g.scatter_time -. 0.4
  ; if g.frightened_time > 2.0
    then g.frightened_time <- g.frightened_time -. 1.0


let do_chstatus = function
  | Some status -> g.mode <- status
                 ; g.passed_time <- 0.0
  | _           -> ()

let chstatus = function
  | [`String status] -> do_chstatus (status_of_string status)
  | _                -> ()

let restart _ =
  g.speed           <- 200.0
; g.score           <- 0
; g.scatter_time    <- 7.0
; g.chase_time      <- 20.0
; g.frightened_time <- 10.0
; g.passed_time     <- 0.0
; g.mode            <- `SCATTER

let update = function
  | [`Float dt] -> g.passed_time <- g.passed_time +. dt
                 ; (match g.mode with
                    | `SCATTER    -> if g.passed_time >= g.scatter_time
                                    then Signal.emit "chstatus" [`String (string_of_status `CHASE)]
                    | `CHASE      -> if g.passed_time >= g.chase_time
                                    then Signal.emit "chstatus" [`String (string_of_status `SCATTER)]
                    | `FRIGHTENED -> if g.passed_time >= g.frightened_time
                                    then Signal.emit "chstatus" [`String (string_of_status `CHASE)]
                    | _           -> ()
                   )
  | _           -> ()

let connect_handles () =
  Signal.connect "chstatus"  chstatus  |> ignore
; Signal.connect "collision" collision |> ignore
; Signal.connect "levelup"   levelup   |> ignore
; Signal.connect "restart"   restart   |> ignore
; Signal.connect "scored"    scored    |> ignore
; Signal.connect "update"    update    |> ignore

let () = restart []
