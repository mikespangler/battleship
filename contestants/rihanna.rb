class RihannaPlayer
  attr_reader :name
  def initialize
    @name = "Battleship Starring RihannaBot"
    # @probability_grid = [
    #   [0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5],
    #   [0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5],
    #   [0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5],
    #   [0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5],
    #   [0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5],
    #   [0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5],
    #   [0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5],
    #   [0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5],
    #   [0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5],
    #   [0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5],
    # ]
    @turn_count = 0
    @hit_array = []
    @miss_array = []
    @probability_hash = [
      [ 0.5 => [0,0], 0.5 => [1,0], 0.5 => [2,0], 0.5 => [3,0], 0.5 => [4,0], 0.5 => [5,0], 0.5 => [6,0], 0.5 => [7,0], 0.5 => [8,0], 0.5 => [9,0]],
      [ 0.5 => [0,1], 0.5 => [1,1], 0.5 => [2,1], 0.5 => [3,1], 0.5 => [4,1], 0.5 => [5,1], 0.5 => [6,1], 0.5 => [7,1], 0.5 => [8,1], 0.5 => [9,1]],
      [ 0.5 => [0,2], 0.5 => [1,2], 0.5 => [2,2], 0.5 => [3,2], 0.5 => [4,2], 0.5 => [5,2], 0.5 => [6,2], 0.5 => [7,2], 0.5 => [8,2], 0.5 => [9,2]],
      [ 0.5 => [0,3], 0.5 => [1,3], 0.5 => [2,3], 0.5 => [3,3], 0.5 => [4,3], 0.5 => [5,3], 0.5 => [6,3], 0.5 => [7,3], 0.5 => [8,3], 0.5 => [9,3]],
      [ 0.5 => [0,4], 0.5 => [1,4], 0.5 => [2,4], 0.5 => [3,4], 0.5 => [4,4], 0.5 => [5,4], 0.5 => [6,4], 0.5 => [7,4], 0.5 => [8,4], 0.5 => [9,4]],
      [ 0.5 => [0,5], 0.5 => [1,5], 0.5 => [2,5], 0.5 => [3,5], 0.5 => [4,5], 0.5 => [5,5], 0.5 => [6,5], 0.5 => [7,5], 0.5 => [8,5], 0.5 => [9,5]],
      [ 0.5 => [0,6], 0.5 => [1,6], 0.5 => [2,6], 0.5 => [3,6], 0.5 => [4,6], 0.5 => [5,6], 0.5 => [6,6], 0.5 => [7,6], 0.5 => [8,6], 0.5 => [9,6]],
      [ 0.5 => [0,7], 0.5 => [1,7], 0.5 => [2,7], 0.5 => [3,7], 0.5 => [4,7], 0.5 => [5,7], 0.5 => [6,7], 0.5 => [7,7], 0.5 => [8,7], 0.5 => [9,7]],
      [ 0.5 => [0,8], 0.5 => [1,8], 0.5 => [2,8], 0.5 => [3,8], 0.5 => [4,8], 0.5 => [5,8], 0.5 => [6,8], 0.5 => [7,8], 0.5 => [8,8], 0.5 => [9,8]],
      [ 0.5 => [0,9], 0.5 => [1,9], 0.5 => [2,9], 0.5 => [3,9], 0.5 => [4,9], 0.5 => [5,9], 0.5 => [6,9], 0.5 => [7,9], 0.5 => [8,9], 0.5 => [9,9]]
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

  def add_last_action(state)
    @turn_count += 1
    y = -1
    state.each do |battle_row|
      y += 1
      x = -1
      battle_row.map do |coordinate|
        x += 1
        if coordinate == :hit && !@hit_array.include?([x,y])
          type = hit
          update_probability_grid(coordinate,type,state)
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

  def take_turn(state, ships_remaining)
    add_last_action(state)
    update_probability_grid(state)
    puts @unknown_array
    return [4,5] if @turn_count == 1

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
