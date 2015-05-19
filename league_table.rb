class LeagueTable < Array
  def find_scores(team)
    scores = []
    for score in self
      scores << score if score.include?(team)
    end
    scores
  end
end
