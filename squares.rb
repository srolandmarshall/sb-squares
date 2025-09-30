require 'csv'

class Squares

  attr_accessor :teams, :players_list

  # initialize with optional inputs to allow non-interactive use in tests
  # options:
  #   :teams => {afc: 'AFC', nfc: 'NFC'}
  #   :players_list => {'name' => count}
  def initialize(options = {})
    @players_list = options[:players_list]
    @teams = options[:teams]
  end

  # Convenience runner to create and execute flow without auto-instantiation side-effects
  def self.run(options = {})
    name = options.delete(:name)
    output = options.delete(:output)
    instance = new(options)
    if instance.teams.nil? || instance.teams[:afc].to_s.empty? || instance.teams[:nfc].to_s.empty? || instance.players_list.nil? || instance.players_list.empty?
      if STDIN.tty?
        instance.interactive!
      else
        raise 'Missing required inputs (teams and/or players). Provide flags/options or run in an interactive terminal.'
      end
    end
    # If output not provided, build a semi-unique filename: {AFCTEAM}v{NFCTEAM}-{YEAR}[-{name}].csv
    if output.nil?
      afc = instance.teams[:afc] || 'AFC'
      nfc = instance.teams[:nfc] || 'NFC'
      year = Time.now.year
      base = "#{sanitize(afc)}v#{sanitize(nfc)}-#{year}"
      base += "-#{sanitize(name)}" if name && !name.to_s.empty?
      output = File.join('output', "#{base}.csv")
    end
    instance.squares(output: output)
    instance
  end

  def self.sanitize(str)
    return '' unless str
    str.to_s.gsub(/\s+/, '').gsub(/[^0-9A-Za-z_-]/, '')
  end

  def count_error(previous_method = nil)
    puts 'Wrong number of squares! Starting over.'
    Squares.method_defined?(previous_method.to_sym) ? public_send(previous_method) : entry_type_input
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

  def interactive!
    raise 'Interactive input is not available in this environment' unless STDIN.tty?
    @teams ||= team_input
    @players_list ||= begin
      entry_type_input
      @players_list
    end
  end

  # @params: players_list, {"name" => # of squares}
  # returns the list of players list if there are 100 squares
  # returns false if number of squares != 100
  def players_check(players_list = {"name": -1}, previous_method = "entry_type_input")
    # sum all values in players_list
    puts "Checking player counts..."
    total = players_list.values.inject(0, :+)
    total == 100 ? players_list : count_error(previous_method)
  end

  # returns a hash of players or starts over if there's not enough squares
  def player_input(players_list = {}, total_squares = 0)
    puts 'Enter Player Name and Number of Squares'
    loop do
      puts "Total Squares so far: #{total_squares}"
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

  def print_csv(squares_array, teams = {afc: "AFC", nfc: "NFC"}, output: 'squares.csv')
    puts 'Printing Squares...'
    nums = (0..9).to_a
    dir = File.dirname(output)
    Dir.mkdir(dir) unless Dir.exist?(dir)
    CSV.open(output, 'w') do |csv|
      csv << ["Across: #{teams[:afc]}\nDown: #{teams[:nfc]}"] + nums
      count = 0
      squares_array.each do |list|
        # don't mutate the list used elsewhere; write a new array
        csv << [nums[count]] + list
        count += 1
      end
    end
  end

  def squares(squares_list = [], output: 'output/squares.csv')
    @players_list.each do |k,v|
      squares_list += Array.new(v, k)
    end
    squares_list.shuffle!
    squares_array = squares_list.each_slice(10).to_a
    print_csv(squares_array, @teams, output: output)
  end
end

