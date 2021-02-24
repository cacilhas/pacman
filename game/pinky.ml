include Ghost.Prototype(struct

  let chase_target _ =
    let (x, y) = Pacman.xy `BOARD in
    match Pacman.gonna () with
    | `LEFT  -> (x-4, y)
    | `RIGHT -> (x+4, y)
    | `UP    -> (x, y-4)
    | `DOWN  -> (x, y+4)

  let scatter_target () = (2, -1)
end)
