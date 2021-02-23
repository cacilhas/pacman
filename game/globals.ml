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
           ; Signal.emit "scored" [Int v]
  end
; if !the_score > !the_hs
  then the_hs := !the_score
; !the_score * 10

let highscore () = !the_hs * 10

let restart _ =
  the_speed := 200.0
; the_score := 0
