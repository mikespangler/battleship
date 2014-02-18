class RihannaPlayer
  attr_reader :name
  def initialize
    @name = "Battleship Starring RihannaBot"
    @x = 0
    @y = 0
    @next_x = 4
    @next_y = 5
    @previous_x = 0
    @previous_y = 0
    @turn_count = 0
    @first_hit_y = 0
    @first_hit_x = 0
    @turn_history_hash = {}
    @hit_array = []
    @miss_array = []
    @previous_ships_remaining =[]
    @mode = "hunt"
    @previous_hit_array = []
    @previous_miss_array = []
    @current_mode_array = ["right","left","down","up"]
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
          @previous_hit_array = @hit_array
          @hit_array << [x,y]
          @probability_hash.delete_if {|probability,coordinate_array| coordinate_array = [x,y] }
          @x = x
          @y = y
        else coordinate == :miss && !@miss_array.include?([x,y])
          @previous_miss_array = @miss_array
          @miss_array << [x,y]
          @probability_hash.delete_if {|probability,coordinate_array| coordinate_array = [x,y] }
          @x = x
          @y = y
        end
      end
    end    
  end

  def check_edges
    if @x == 0
      @mode = "right"
      @next_x = 1
    elsif @y == 0
      @mode = "down"
      @next_y = 1
    elsif @x == 9
      @mode = "left"
      @next_x = 8
    elsif @y == 9
      @mode = "up"
      @next_y = 8
    end
  end

  def next_hit
    case @mode
    when "right"
      @next_x = @x + 1
    when "left"
      @next_x = @x - 1
    when "up"
      @next_y = @y + 1
    when "down"
      @next_y = @y - 1
    end
  end

  def new_mode
    @mode = @current_mode_array.shift
    next_hit
  end

   def after_first_hit
    @first_hit_y = @y
    @first_hit_x = @x
    check_edges
    if @mode == "hunt"
      new_mode
    end
  end

  def hunt
    if @turn_count != 0
      #hunt
      @next_x = rand(10)
      @next_y = rand(10)
    end
    print @turn_count
  end

  def determine_mode(state,ships_remaining)
    if ships_remaining.count < @previous_ships_remaining.count
      @mode = "hunt"
      @current_mode_array = ["right","left","down","up"]
      @first_hit_y = 0
      @first_hit_x = 0
      hunt
    elsif @hit_array.count > @previous_hit_array.count && @mode == "hunt"
      after_first_hit
    elsif @hit_array.count > @previous_hit_array.count && @mode != "hunt"
      next_hit
    elsif @hit_array.count == @previous_hit_array.count && @mode != "hunt"
      new_mode
    else
      @mode = "hunt"
      hunt
    end
  end

  def take_turn(state, ships_remaining)
    add_last_action(state)
    determine_mode(state, ships_remaining)
    @previous_ships_remaining = ships_remaining
    @previous_x = @next_x
    @previous_y = @next_y
    return [@next_x,@next_y]
  end


end

# state is a representation of the known state of the opponent’s fleet, as modified by the player’s shots. It is given as an array of arrays; the inner arrays represent horizontal rows. Each cell may be in one of three states: :unknown, :hit, or :miss. E.g.

# [[:hit, :miss, :unknown, ...], [:unknown, :unknown, :unknown, ...], ...]
# # 0,0   1,0    2,0              0,1       1,1       2,1
# ships_remaining is an array of the ships remaining on the opponent's board, given as an array of numbers representing their lengths, longest first. For example, the first two calls will always be:

# [5, 4, 3, 3, 2]
# If the player is lucky enough to take out the length 2 ship on their first two turns, the third turn will be called with:

# [5, 4, 3, 3]
# and so on.

# take_turn must return an array of co-ordinates for the next shot. In the example above, we can see that the player has already played [0,0], yielding a hit, and [1,0], giving a miss. They can now return a reasonable guess of [0,1] for their next shot.
