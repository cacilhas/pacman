class framing (period : float) (count : int) = object

  val mutable cur_i = 0
  val mutable acc   = 0.0

  method frame = cur_i

  method update dt =
    acc <- acc +. dt
  ; if acc >= period
    then begin
      acc <- acc -. period
    ; cur_i <- (succ cur_i) mod count
    end
end
