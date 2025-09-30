# frozen_string_literal: true

require 'open3'
require 'fileutils'
require 'csv'

RSpec.describe 'CLI' do
  let(:script_path) { File.expand_path('../../bin/squares', __FILE__) }
  let(:fixture) { File.expand_path('fixtures/players.csv', __dir__) }
  let(:out) { File.expand_path('out.csv', __dir__) }
  let(:output_dir) { File.expand_path('../../output', __dir__) }
  before(:each) do
    FileUtils.rm_rf(output_dir)
    FileUtils.mkdir_p(output_dir)
    File.delete(out) if File.exist?(out)
  end

  after(:each) do
    FileUtils.rm_rf(output_dir)
    File.delete(out) if File.exist?(out)
  end

  it 'calls Squares.run with expected options for CSV + flags' do
    ARGV.replace(["--csv=#{fixture}", "--afc=TeamA", "--nfc=TeamB", "--output=#{out}"])

    called = nil
    allow(Squares).to receive(:run) do |args|
      called = args
      double('squares_instance')
    end

    load script_path

    expect(called).to be_a(Hash)
    expect(called[:teams]).to eq({ afc: 'TeamA', nfc: 'TeamB' })
    expect(called[:players_list]).to be_a(Hash)
    expect(called[:output]).to eq(out)
  end

  context '--name flag' do
    it 'passes name through to Squares.run' do
      ARGV.replace(["--csv=#{fixture}", "--afc=TeamA", "--nfc=TeamB", "--name=myrun"])

      captured = nil
      allow(Squares).to receive(:run) do |args|
        captured = args
        double('squares_instance')
      end

      load script_path

      expect(captured).to be_a(Hash)
      expect(captured[:teams]).to eq({ afc: 'TeamA', nfc: 'TeamB' })
      expect(captured[:players_list]).to be_a(Hash)
      expect(captured[:name]).to eq('myrun')
    end
  end
end
