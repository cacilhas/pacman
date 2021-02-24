include Ghost.Prototype(struct

  let scatter_target () = (2, 21)

  let chase_target me =
    let (x, y) = Pacman.xy `BOARD
    and (gx, gy) = me#xy `BOARD in
    let dx = x - gx
    and dy = y - gy in
    let d = (dx*dx) + (dy*dy) in
    if d >= 16
    then (x, y)
    else scatter_target ()

end)
