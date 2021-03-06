class LeagueTable
  attr_accessor :matches

  def initialize
    @matches = []
  end

  def find_matches(team)
    matches.find_all {|score| score.include?(team)}
  end

  def get_scores(team, gained = true)
    goals = []
    find_matches(team).each {|score| goals << score.split("-").map(&:strip!)}

    return goals.flatten.delete_if {|f| !f.include?(team)} if gained
    goals.flatten.delete_if {|f| f.include?(team)}
  end

  def calculate(points)
    points = points.split(' ') if points.is_a?(String)
    points.each {|p| p.gsub!(/\D*/, '')}

    return 0 if points.empty?
    points.flatten.map(&:to_i).reduce(:+)
  end

  def get_goals_for(team)
    goals = get_scores(team)
    calculate(goals)
  end

  def get_goals_against(team)
    goals = get_scores(team, false)
    calculate(goals)
  end

  def get_goals_difference(team)
    scored = get_goals_for(team)
    lost = get_goals_against(team)
    diff = scored - lost
  end

  def check_winner(match)
    goal_counts = match.split('-')
    first_team = goal_counts.first.strip!
    second_team = goal_counts.last.strip!

    first_team_points = calculate(first_team)
    second_team_points = calculate(second_team)

    return first_team.sub(/\s\d/, '') if first_team_points > second_team_points
    return second_team.sub(/\d\s/, '') if second_team_points > first_team_points
    return 'draw' if first_team_points == second_team_points
  end

  def team_won?(match, team)
    check_winner(match).include?(team)
  end

  def draw?(match)
    check_winner(match).include?('draw')
  end

  def get_wins(team)
    wins = 0
    find_matches(team).each {|match| wins += 1 if team_won?(match, team)}
    wins
  end

  def get_losses(team)
    losses = 0
    find_matches(team).each {|match| losses += 1 unless team_won?(match, team) || draw?(match)}
    losses
  end

  def get_draws(team)
    draws = 0
    find_matches(team).each {|match| draws += 1 if draw?(match)}
    draws
  end

  def get_points(team)
    wins = get_wins(team)
    draws = get_draws(team)
    sum_of_points = 3*wins + draws #losses don't change amount of points, so they can be skipped in calculation
  end
end
