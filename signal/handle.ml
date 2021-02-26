type t = Uuidm.t

let create_chunk () =
  let res = Array.make 8 '\x00'
  and byte = Int64.of_int 0xff
  and salt = Int64.of_int32 0x7FFFFFFFl
             |> Int64.add Int64.one
             |> Random.int64 in
    for i = 0 to 3 do
      res.(i) <- (  Int64.shift_right_logical salt (i*8)
                 |> Int64.logand byte
                 |> Int64.to_int
                 |> char_of_int
                 )
    done
  ; res

let calculate_seed () =
  Random.self_init ()
; let res = Array.make 16 '\x00'
  and salt = create_chunk () in
  for i = 0 to 7 do
    res.(i) <- salt.(i)
  done
; let salt = create_chunk () in
  for i = 0 to 7 do
    res.(i+8) <- salt.(i)
  done
; Bytes.init 16 (fun i -> res.(i))

let seed = lazy (calculate_seed ())

let next () : t = Lazy.force seed |> Uuidm.v4
