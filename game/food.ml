let base = String.concat ""
  [ "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
  ; "\x00\x01\x01\x01\x01\x01\x01\x01\x01\x00\x01\x01\x01\x01\x01\x01\x01\x01\x00"
  ; "\x00\x02\x00\x00\x01\x00\x00\x00\x01\x00\x01\x00\x00\x00\x01\x00\x00\x02\x00"
  ; "\x00\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x00"
  ; "\x00\x01\x00\x00\x01\x00\x01\x00\x00\x00\x00\x00\x01\x00\x01\x00\x00\x01\x00"
  ; "\x00\x01\x01\x01\x01\x00\x01\x01\x00\x00\x00\x01\x01\x00\x01\x01\x01\x01\x00"
  ; "\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00"
  ; "\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00"
  ; "\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00"
  ; "\x00\x00\x00\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x01\x01\x01\x00\x00\x00"
  ; "\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00"
  ; "\x00\x00\x00\x00\x01\x00\x00\x00\x00\x03\x00\x00\x00\x00\x01\x00\x00\x00\x00"
  ; "\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00"
  ; "\x00\x01\x01\x01\x01\x01\x01\x01\x01\x00\x01\x01\x01\x01\x01\x01\x01\x01\x00"
  ; "\x00\x01\x00\x00\x01\x00\x00\x00\x01\x00\x01\x00\x00\x00\x01\x00\x00\x01\x00"
  ; "\x00\x02\x01\x00\x01\x01\x01\x01\x01\x00\x01\x01\x01\x01\x01\x00\x01\x02\x00"
  ; "\x00\x00\x01\x00\x01\x00\x01\x00\x00\x00\x00\x00\x01\x00\x01\x00\x01\x00\x00"
  ; "\x00\x01\x01\x01\x01\x00\x01\x01\x01\x00\x01\x01\x01\x00\x01\x01\x01\x01\x00"
  ; "\x00\x01\x00\x00\x00\x00\x00\x00\x01\x00\x01\x00\x00\x00\x00\x00\x00\x01\x00"
  ; "\x00\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x00"
  ; "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
  ]

let map = Array.init (String.length base) (fun _ -> '\x00')

class cherry = object (self)

  val mutable show_cherry = false
  val mutable cherry_time = 0.0

  method shown = show_cherry

  method time = cherry_time

  method reset ~show =
    cherry_time <- 0.0
  ; show_cherry <- show

  method update dt =
    cherry_time <- cherry_time +. dt
  ; if show_cherry
    then begin
      if cherry_time > 8.0
      then self#reset ~show:false
    end
    else begin
      if cherry_time > 12.0 && Random.int 100 > 90
      then self#reset ~show:true
    end
end

let the_cherry = new cherry

let resting () = Array.map int_of_char map
              |> Array.map (fun e -> if e = 3 then 0 else e)
              |> Array.fold_left Int.add 0

let index_of_xy x y =
  if x < 0 || x > 18 || y < 0 || y > 20
  then 0
  else y*19 + x

let get_cell (x, y) = match int_of_char map.(index_of_xy x y) with
  | 3     -> if the_cherry#shown
             then 3
             else 0
  | value -> value

let eaten i =
  if map.(i) = '\x03'
  then the_cherry#reset ~show:false
  else map.(i) <- '\x00'

let eat = function
  | [`Pair (x, y)] -> get_cell (x, y) |> Globals.score |> ignore
                    ; eaten (index_of_xy x y)
                    ; if resting () = 0
                      then Signal.emit "levelup" []
  | _              -> ()

let restart _ =
  String.iteri (fun i c -> map.(i) <- c) base

let update = function
  | [`Float dt] -> the_cherry#update dt
  | _           -> ()

let connect_handles () =
  Signal.connect "gotta"   eat     |> ignore
; Signal.connect "levelup" restart |> ignore
; Signal.connect "restart" restart |> ignore
; Signal.connect "update"  update  |> ignore

let () = restart []
