include Ghost.Prototype(struct

  let chase_target _ =
    let (x, y) = Pacman.xy `BOARD in
    let (x, y) = match Pacman.gonna () with
      | `LEFT  -> (x-1, y)
      | `RIGHT -> (x+1, y)
      | `UP    -> (x, y-1)
      | `DOWN  -> (x, y+1)
    and (gx, gy) = Blinky.xy `BOARD in
    let dx = 2*x - gx
    and dy = 2*y - gy in
    (dx, dy)

  let scatter_target () = (16, 21)
end)
