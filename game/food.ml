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

let index_of_xy x y =
  if x < 0 || x > 18 || y < 0 || y > 20
  then 0
  else y*19 + x

let get_cell (x, y) = int_of_char map.(index_of_xy x y)

let eat = function
  | [Signal.Pair (x, y)] -> get_cell (x, y) |> Globals.score |> ignore
                          ; map.(index_of_xy x y) <- '\x00'
  | _ -> ()

let init () =
  String.iteri (fun i c -> map.(i) <- c) base

let () = init ()
