type handle = int
type arg = Float of float
         | Int of int
         | Pair of int * int
         | String of string
type callback = arg list -> unit

let handles : (handle * (string * callback)) list ref = ref []

let next_handle () =
  List.map (fun (id, _) -> id) !handles
  |> List.fold_left max ~-1
  |> (+) 1

let connect signal cb =
  let id = next_handle () in
  handles := (id, (signal, cb)) :: !handles
; id

let get id = List.assoc id !handles

let filter_signal signal =
  fun (_, (name, cb)) -> if name = signal then Some cb else None

let emit signal args =
  List.filter_map (filter_signal signal) !handles
  |> List.iter (fun cb -> try (cb args) with e -> Printf.eprintf "%s" (Printexc.to_string e))

let disconnect signal id =
  let (name, _) = get id in
  if name != signal
  then Failure (Printf.sprintf "signal %s doesn't match handle %d" signal id) |> raise
; handles := List.remove_assoc id !handles
