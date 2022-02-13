require 'csv'

class Squares

  attr_accessor :teams, :players_list

  def initialize
    @players_list = []
    @teams = team_input
    entry_type_input
    squares
  end

  def count_error(previous_method = nil)
    puts 'Wrong number of squares! Starting over.'
    Squares.method_defined?(previous_method) ? public_send(previous_method) : entry_type_input
  end

  def team_input
    puts 'Who is the AFC contender?'
    afc_name = gets.strip
    puts 'Who is the NFC contender?'
    nfc_name = gets.strip
    { afc: afc_name, nfc: nfc_name }
  end

  def entry_type_input
    puts 'Manual Entry or CSV? (type M or CSV)'
    input = gets.strip
    case input
    when /M(ANUAL)?/i
      @players_list = player_input
    when /CS?V?/i
      @players_list = import_csv('./players.csv')
    else
      puts 'Type either M or CSV'
    end
  end

  # @params: players_list, {"name" => # of squares}
  # returns the list of players list if there are 100 squares
  # returns false if number of squares != 100
  def players_check(players_list = {"name": -1}, previous_method = "entry_type_input")
    # sum all values in players_list
    puts "Checking player counts..."
    players_list.values.inject(:+) == 100 ? players_list : count_error(previous_method)
  end

  # returns a hash of players or starts over if there's not enough squares
  def player_input(players_list = {}, total_squares = 0)
    puts 'Enter Player Name and Number of Squares'
    loop do
      puts 'Player Name:'
      name = gets.strip
      puts 'Number of Squares:'
      squares = gets.strip.to_i
      total_squares += squares
      if squares <= 0
        puts 'You need at least one square!'
      else
        players_list[name] = squares
        break if total_squares >= 100
      end
    end
    players_check(players_list, "player_input")
  end

  # @params: path: path to csv file
  # returns a hash of players and their squares, or makes them start over if there's not enough squares
  def import_csv(path)
    players_list = {}
    puts "Importing #{path}..."
    CSV.read(path, headers: true).each do |row|
      players_list[row['name']] = row['sqs'].to_i
    end
    players_check(players_list, "entry_type_input")
  end

  def print_csv(squares_array, teams = {afc: "AFC", nfc: "NFC"})
    puts 'Printing Squares...'
    nums = Array.new([*0..9])
    CSV.open('squares.csv', 'w') do |csv|
      csv << ["Across: #{teams[:afc]}\nDown: #{teams[:nfc]}"] + nums
      count = 0
      squares_array.each do |list|
        csv << list.unshift(nums[count])
        count += 1
      end
    end
  end

  def squares(squares_list = [])
    @players_list.each do |k,v|
      squares_list += Array.new(v, k)
    end
    squares_list.shuffle!
    squares_array = squares_list.each_slice(10).to_a
    print_csv(squares_array, @teams)
  end
end

Squares.new
