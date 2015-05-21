class LeagueTable < Array
  def find_scores(team)
    self.find_all {|score| score.include?(team)}
  end

  def get_scores(team, gained = true)
    goals = []
    find_scores(team).each {|s| goals << s.split("-")}
    if gained
      goals.flatten.delete_if {|f| !f.include?(team)}.each {|s| s.strip!}
    else
      goals.flatten.delete_if {|f| f.include?(team)}.each {|s| s.strip!}
    end
  end

  def calculate(points)
    return points.flatten.map(&:to_i).reduce(:+) if points.any?
    return 0 if points.empty?
  end

  def get_goals_for(team)
    points = []
    get_scores(team).each {|p| points << p.split(' ')}
    calculate(points)
  end

  def get_goals_against(team)
    points = []
    get_scores(team, false).each {|p| points << p.split(' ')}
    calculate(points)
  end

  def get_goals_difference(team)
    scored = get_goals_for(team)
    lost = get_goals_against(team)
    diff = scored - lost
  end

end
