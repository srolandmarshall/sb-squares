# frozen_string_literal: true

require 'csv'
require_relative '../squares'

RSpec.describe Squares do
  let(:teams) { { afc: 'TeamA', nfc: 'TeamB' } }

  before(:each) do
    Dir.glob(File.expand_path('../output/*', __dir__)).each { |f| File.delete(f) }
  end

  after(:each) do
    Dir.glob(File.expand_path('../output/*', __dir__)).each { |f| File.delete(f) }
  end

  it 'creates a 10x10 grid CSV with header when run non-interactively' do
    # create players that sum to 100
    players = {}
    # 10 players with 10 squares each
    (1..10).each { |i| players["P#{i}"] = 10 }

    instance = Squares.run(teams: teams, players_list: players)

    expect(instance).to be_a(Squares)
  # find the generated file by the naming convention
  afc_s = Squares.sanitize(teams[:afc])
  nfc_s = Squares.sanitize(teams[:nfc])
  year = Time.now.year
  pattern = File.join('output', "#{afc_s}v#{nfc_s}-#{year}*.csv")
  files = Dir.glob(pattern)
  expect(files).not_to be_empty
  rows = CSV.read(files.first)
    # header + 10 rows
    expect(rows.size).to eq(11)
    # each row should have 11 columns (label + 10 nums)
    expect(rows.first.size).to eq(11)
    expect(rows[1].size).to eq(11)

  # total player cells should equal 100 (10 rows * 10 cols)
  player_cells = rows[1..-1].flat_map { |r| r[1..-1] }
  expect(player_cells.size).to eq(100)
  # ensure only the provided player names appear (in this test we used 10 players P1..P10)
  expect(player_cells.uniq - players.keys).to be_empty
  end
end
