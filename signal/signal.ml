type handle = int32
type arg = [ `Float of float
           | `Int of int
           | `Pair of int * int
           | `String of string
           ]
type callback = arg list -> unit
type handle_wrap = handle * (string * callback)

class handle_store = object (self)


  val mutable debugging = false
  val mutable available = 0l
  val mutable handles : handle_wrap list = []

  val string_from_arg = function
    | `Float value  -> Printf.sprintf "%g" value
    | `Int value    -> Printf.sprintf "%d" value
    | `Pair (a, b)  -> Printf.sprintf "(%d, %d)" a b
    | `String value -> Printf.sprintf "\"%s\"" value

  method debugging = debugging

  method private next_handle =
    let handle = available in
    available <- Int32.succ handle
  ; handle

  method set_debug st = debugging <- st

  method private log_connect signal id =
    if debugging
    then Printf.eprintf "connected signal %s with handle %ld\n" signal id

  method private log_disconnect signal id =
    if debugging
    then Printf.eprintf "handle %ld disconnected from signal %s\n" id signal

  method private filter_signal signal =
    fun (_, (name, cb)) -> if name = signal then Some cb else None

  method private log_emit signal (args : arg list) =
    if debugging
    then let args_str = List.map string_from_arg args
                        |> String.concat ", " in
         Printf.eprintf "emitted: %s [%s]\n" signal args_str

  method add_handle signal cb =
    let id = self#next_handle in
    handles <- (id, (signal, cb)) :: handles
  ; self#log_connect signal id
  ; id

  method get_handle id = List.assoc id handles

  method emit_signal signal args =
    self#log_emit signal args
  ; List.filter_map (self#filter_signal signal) handles
    |> List.iter (fun cb -> try (cb args) with e -> Printf.eprintf "%s" (Printexc.to_string e))

  method remove_handle signal id =
    let (name, _) = self#get_handle id in
    if name != signal
    then Failure (Printf.sprintf "signal %s doesn't match handle id %ld" signal id) |> raise
  ; handles <- List.remove_assoc id handles
  ; self#log_disconnect signal id
end

let internal = new handle_store

let debug = internal#set_debug

let connect = internal#add_handle

let get = internal#get_handle

let emit = internal#emit_signal

let disconnect = internal#remove_handle
