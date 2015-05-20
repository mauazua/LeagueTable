system 'rm Gemfile' if File.exist?('Gemfile')
File.write('Gemfile', <<-GEMFILE)
  source 'https://rubygems.org'
GEMFILE

system 'bundle install'

require 'bundler'
Bundler.setup(:default)

require 'minitest/autorun'
require 'logger'

require './league_table.rb'

describe LeagueTable do
  before do
    @lt = LeagueTable.new
    @lt.push("Man Utd 3 - 0 Liverpool",
             "Real Mad 4 - 3 Liverpool",
             "Real Mad 3 - 1 Man Utd",
             "Chelsea 4 - 3 Bayern",
             "Real Mad 2 - 0 Chelsea",
             "Liverpool 2 - 2 Chelsea",
             "Man Utd 3 - 2 Bayern")
  end

  describe "find_scores" do
    before do
      @scores = @lt.find_scores("Liverpool")
    end

    it "takes correct amount of results" do
      @scores.size.must_equal(3)
    end

    it "takes proper results" do
      @scores.must_include("Liverpool 2 - 2 Chelsea")
      @scores.must_include("Man Utd 3 - 0 Liverpool")
      @scores.must_include("Real Mad 4 - 3 Liverpool")
    end

    it "do not takes unassociated results" do
      @scores.wont_include("Real Mad 2 - 0 Chelsea")
      @scores.wont_include("Man Utd 3 - 2 Bayern")
      @scores.wont_include("Chelsea 4 - 3 Bayern")
    end
  end

  describe "get_scores" do
    before do
      @goals_gained = @lt.get_scores("Man Utd")
      @goals_lost = @lt.get_scores("Man Utd", false)
    end

    it "gets goals earned for team" do
      @goals_gained.must_equal(["Man Utd 3", "1 Man Utd", "Man Utd 3"])
    end

    it "gets goals lost for opponent" do
      @goals_lost.must_equal(["0 Liverpool", "Real Mad 3", "2 Bayern"])
    end
  end

  it "get_goals_for returns sum of goals earned" do
    @lt.get_goals_for("Bayern").must_equal(5)
  end

  it "get_goals_against returns sum of goals conceeded" do
    @lt.get_goals_against("Bayern").must_equal(7)
  end

end
