include Ghost.Prototype(struct

  let chase_target (clyde : Ghost.ghost) =
    let (x, y) = Pacman.xy `BOARD
    and (gx, gy) = clyde#xy `BOARD in
    let dx = x - gx
    and dy = y - gy in
    let d = (dx*dx) + (dy*dy) in
    if d >= 16
    then (x, y)
    else (2, 21)

  let scatter_target () = (2, 21)

end)
