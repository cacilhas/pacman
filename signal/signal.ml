type handle = int32
type arg = [ `Float of float
           | `Int of int
           | `Pair of int * int
           | `String of string
           ]
type callback = arg list -> unit
type handle_wrap = handle * (string * callback)

type storage_t = {
  mutable debug     : bool
; mutable available : handle
; mutable handles   : handle_wrap list
}

let storage = {
  debug     = false
; available = 0l
; handles   = []
}

let string_from_arg = function
  | `Float value  -> Printf.sprintf "%g" value
  | `Int value    -> Printf.sprintf "%d" value
  | `Pair (a, b)  -> Printf.sprintf "(%d, %d)" a b
  | `String value -> Printf.sprintf "\"%s\"" value

let next_handle () =
  let handle = storage.available in
  storage.available <- Int32.succ handle
; handle

let log_connect signal id =
  if storage.debug
  then Printf.eprintf "connected signal %s with handle %ld\n" signal id

let log_disconnect signal id =
  if storage.debug
  then Printf.eprintf "handle %ld disconnected from signal %s\n" id signal

let log_emit signal (args : arg list) =
  if storage.debug
  then let args_str = List.map string_from_arg args
                      |> String.concat ", " in
        Printf.eprintf "emitted: %s [%s]\n" signal args_str

let filter_signal signal (_, (name, cb)) =
  if name = signal
  then Some cb
  else None

let get id = List.assoc id storage.handles

let debug level = storage.debug <- level

let connect signal cb =
  let id = next_handle () in
  storage.handles <- (id, (signal, cb)) :: storage.handles
; log_connect signal id
; id

let emit signal args =
  log_emit signal args
; List.filter_map (filter_signal signal) storage.handles
  |> List.iter (fun cb -> try (cb args) with e -> Printf.eprintf "%s" (Printexc.to_string e))

let disconnect signal id =
  let (name, _) = get id in
  if name != signal
  then Failure (Printf.sprintf "signal %s doesn't match handle id %ld" signal id) |> raise
; storage.handles <- List.remove_assoc id storage.handles
; log_disconnect signal id
