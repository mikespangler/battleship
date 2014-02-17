Contestant
take_turn(state, ships_remaining)

  check current mode
      if mode === :hunt && number of hits > before --------->  NEW HIT
        mode === :left
      elsif L/R/U/D and length decreases (sunk a ship)   ------> SUNK
        mode === :hunt
      elsif L/R/U/D and if number of misses > before,   ---------> MISS
        switch_direction(self.mode)  # => mode === (next_mode)
      else (L/R/U/D and if number of hits > before)   ----------> HIT, not sunk
        mode = :left if mode === :new_hit

  case mode
    when :hunt
      *use algorithm to pick random shit

      break
    when :left
      break
    when :right

      break
    when :up

      break
    when :down

      break

  end



Hunt Mode Probability Algorithm

method: gather_possibilities

Hunt mode will use parity and calculate possible guesses as if on a checkerboard
