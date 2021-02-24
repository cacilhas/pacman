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

let the_speed  = ref 200.0
let the_hs     = ref 0
let the_score  = ref 0

let speed () = !the_speed

let score i =
  begin
    match i with
      | 0 -> ()
      | 3 -> the_score := !the_score + 5
      | v -> incr the_score
           ; Signal.emit "scored" [`Int v]
  end
; if !the_score > !the_hs
  then the_hs := !the_score
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
  | _ -> ()

let restart _ =
  the_speed := 200.0
; the_score := 0
