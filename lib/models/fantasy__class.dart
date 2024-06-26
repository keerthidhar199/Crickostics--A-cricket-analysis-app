

/// Custom business object class which contains properties to hold the detailed
/// information about the employee which will be rendered in datagrid.
///
class Bat_Fantasy_Player {
  /// Creates the employee class with required details.
  Bat_Fantasy_Player(this.player, this.runs, this.sr, this.category, this.team);

  final String player;
  final int runs;
  final double sr;
  final String category;
  final String team;
}

class Bowl_Fantasy_Player {
  /// Creates the employee class with required details.
  Bowl_Fantasy_Player(
      this.player, this.wickets, this.econ, this.category, this.team);

  final String player;
  final int wickets;
  final double econ;
  final String category;
  final String team;
}

class Pship_Fantasy_Player {
  /// Creates the employee class with required details.
  Pship_Fantasy_Player(
      this.player1, this.player2, this.runs, this.sr, this.category, this.team);

  final String player2;
  final String player1;
  final int runs;
  final double sr;
  final String category;
  final String team;
}
