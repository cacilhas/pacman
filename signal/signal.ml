type handle = int32
type arg = [ `Float of float
           | `Int of int
           | `Pair of int * int
           | `String of string
           ]
type callback = arg list -> unit

let debugging = ref false
let available = ref 0l

let debug st = debugging := st

let log_connect signal id =
  if !debugging
  then Printf.eprintf "connected signal %s with handle %ld\n" signal id

let log_disconnect signal id =
  if !debugging
  then Printf.eprintf "handle %ld disconnected from signal %s\n" id signal

let string_from_arg = function
  | `Float value  -> Printf.sprintf "%g" value
  | `Int value    -> Printf.sprintf "%d" value
  | `Pair (a, b)  -> Printf.sprintf "(%d, %d)" a b
  | `String value -> Printf.sprintf "\"%s\"" value

let log_emit signal args =
  if !debugging
  then let args_str = List.map string_from_arg args
                   |> String.concat ", " in
       Printf.eprintf "emitted: %s [%s]\n" signal args_str

let handles : (handle * (string * callback)) list ref = ref []

let next_handle () =
  let handle = !available in
  available := Int32.add handle 1l
; handle

let connect signal cb =
  let id = next_handle () in
  handles := (id, (signal, cb)) :: !handles
; log_connect signal id
; id

let get id = List.assoc id !handles

let filter_signal signal =
  fun (_, (name, cb)) -> if name = signal then Some cb else None

let emit signal args =
  log_emit signal args
; List.filter_map (filter_signal signal) !handles
  |> List.iter (fun cb -> try (cb args) with e -> Printf.eprintf "%s" (Printexc.to_string e))

let disconnect signal id =
  let (name, _) = get id in
  if name != signal
  then Failure (Printf.sprintf "signal %s doesn't match handle id %ld" signal id) |> raise
; handles := List.remove_assoc id !handles
; log_disconnect signal id
