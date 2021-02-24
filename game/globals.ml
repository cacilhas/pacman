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

let the_speed                 = ref 0.0
let the_hs                    = ref 0
let the_score                 = ref 0
let scatter_time              = ref 0.0
let chase_time                = ref 0.0
let passed_time               = ref 0.0
let frightened_time           = ref 0.0
let current_mode : status ref = ref `SCATTER

let speed () = !the_speed

let update_highscore () =
  if !the_score > !the_hs
  then the_hs := !the_score

let score i =
  begin
    match i with
      | 0 -> ()
      | 3 -> the_score := !the_score + 5
      | v -> incr the_score
           ; Signal.emit "scored" [`Int v]
  end
; update_highscore ()
; !the_score * 10

let highscore () = !the_hs * 10

let deal_with_collision = function
  | Some `FRIGHTENED -> score 10                  |> ignore
  | Some _           ->  Signal.emit "restart" [] |> ignore
  | None             -> ()

let collision = function
  | [`String status] -> deal_with_collision (status_of_string status)
  | _                -> ()

let scored = function
  | [`Int 2] -> Signal.emit "chstatus" [`String (string_of_status `FRIGHTENED)]
              ; passed_time := 0.0
  | _ -> ()

let levelup _ =
  the_speed := !the_speed *. 0.25
; the_score := !the_score + 10
; update_highscore ()
; if !scatter_time > 5.0
  then scatter_time := !scatter_time -. 0.4
; if !frightened_time > 2.0
  then frightened_time := !frightened_time -. 1.0

let update_time dt =
  passed_time := !passed_time +. dt
; match !current_mode with
  | `SCATTER    -> if !passed_time >= !scatter_time
                   then Signal.emit "chstatus" [`String (string_of_status `CHASE)]
  | `CHASE      -> if !passed_time >= !chase_time
                   then Signal.emit "chstatus" [`String (string_of_status `SCATTER)]
  | `FRIGHTENED -> if !passed_time >= !frightened_time
                   then Signal.emit "chstatus" [`String (string_of_status `CHASE)]
  | _           -> ()

let do_chstatus = function
  | Some status -> current_mode := status
                 ; passed_time  := 0.0
  | _           -> ()

let chstatus = function
  | [`String status] -> do_chstatus (status_of_string status)
  | _                -> ()

let restart _ =
  the_speed       := 200.0
; the_score       := 0
; scatter_time    := 7.0
; chase_time      := 20.0
; frightened_time := 10.0
; passed_time     := 0.0
; current_mode    := `SCATTER

let update = function
  | [`Float dt] -> update_time dt
  | _           -> ()

let () = restart []
