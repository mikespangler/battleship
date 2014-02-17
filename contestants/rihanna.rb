class RihannaPlayer
  attr_reader :name

  def initialize
    @name = "Battleship Starring RihannaBot"
    @mode = :hunt
    @saved_state = [
      [:unknown, :unknown, :unknown, :unknown, :unknown, :unknown, :unknown, :unknown, :unknown, :unknown],
      [:unknown, :unknown, :unknown, :unknown, :unknown, :unknown, :unknown, :unknown, :unknown, :unknown],
      [:unknown, :unknown, :unknown, :unknown, :unknown, :unknown, :unknown, :unknown, :unknown, :unknown],
      [:unknown, :unknown, :unknown, :unknown, :unknown, :unknown, :unknown, :unknown, :unknown, :unknown],
      [:unknown, :unknown, :unknown, :unknown, :unknown, :unknown, :unknown, :unknown, :unknown, :unknown],
      [:unknown, :unknown, :unknown, :unknown, :unknown, :unknown, :unknown, :unknown, :unknown, :unknown],
      [:unknown, :unknown, :unknown, :unknown, :unknown, :unknown, :unknown, :unknown, :unknown, :unknown],
      [:unknown, :unknown, :unknown, :unknown, :unknown, :unknown, :unknown, :unknown, :unknown, :unknown],
      [:unknown, :unknown, :unknown, :unknown, :unknown, :unknown, :unknown, :unknown, :unknown, :unknown],
      [:unknown, :unknown, :unknown, :unknown, :unknown, :unknown, :unknown, :unknown, :unknown, :unknown]
    ]
    @probability_hash = [
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    ]
  end

  def new_game
    # This is called whenever a game starts. It must return the initial positioning of the fleet as an array of 5 arrays, one for each ship. The format of each array is:
    # [x, y, length, orientation]
    # where x and y are the top left cell of the ship, length is its length (2-5), and orientation is either :across or :down.
    carrier      = [0,9,5,:across]
    battleship   = [3,7,4,:across]
    cruiser      = [7,5,3,:down]
    sub          = [4,3,3,:across]
    patrol_boat  = [9,8,2,:down]
    return [battleship, patrol_boat, cruiser, sub, carrier]
  end

  def take_turn(state, ships_remaining)
    add_last_action(state)
    update_probability_grid(state)
    puts @unknown_array
    return [4,5] if @turn_count == 1

  end


  def add_last_action(state)  
    y = -1
    state.each do |battle_row|
      y += 1
      x = -1
      battle_row.map do |coordinate|
        x += 1
        if coordinate == :hit && !@hit_array.include?([x,y])
          @hit_array << [x,y]
          @unknown_array.delete_if {|probability,coordinate_array| coordinate_array = [x,y] }
        end
        if coordinate == :miss && !@miss_array.include?([x,y])
          type = miss
          update_probability_grid(coordinate,type,state)
          @miss_array << [x,y]
          @unknown_array.delete_if {|probability,coordinate_array| coordinate_array = [x,y] }
        end
      end
    end    
  end

  def update_probability_grid(coordinate,type,state)

  end

end

    # && hit_array
    #       @probability_grid[x][y] = 0
    #       @probability_grid[x][y+1] = .99
    #       @probability_grid[x][y-1] = .99
    #       @probability_grid[x+1][y] = .99
    #       @probability_grid[x-1][y] = .99
# state is a representation of the known state of the opponent’s fleet, as modified by the player’s shots. It is given as an array of arrays; the inner arrays represent horizontal rows. Each cell may be in one of three states: :unknown, :hit, or :miss. E.g.

# [[:hit, :miss, :unknown, ...], [:unknown, :unknown, :unknown, ...], ...]
# # 0,0   1,0    2,0              0,1       1,1       2,1
# ships_remaining is an array of the ships remaining on the opponent's board, given as an array of numbers representing their lengths, longest first. For example, the first two calls will always be:

# [5, 4, 3, 3, 2]
# If the player is lucky enough to take out the length 2 ship on their first two turns, the third turn will be called with:

# [5, 4, 3, 3]
# and so on.

# take_turn must return an array of co-ordinates for the next shot. In the example above, we can see that the player has already played [0,0], yielding a hit, and [1,0], giving a miss. They can now return a reasonable guess of [0,1] for their next shot.
