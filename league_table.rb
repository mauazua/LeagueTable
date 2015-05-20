class LeagueTable < Array
  def find_scores(team)
    self.find_all {|score| score.include?(team)}
  end
end
