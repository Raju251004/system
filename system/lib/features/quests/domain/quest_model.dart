class Quest {
  final String id;
  final String title;
  final String description;
  final int xp;
  final int gold;
  final String type; // PHYSICAL, TECHNICAL, STUDY
  final String difficulty;
  final bool isCompleted;
  final int? target;
  final String? unit;

  const Quest({
    required this.id,
    required this.title,
    required this.description,
    this.xp = 0,
    this.gold = 0,
    this.type = 'GENERAL',
    this.difficulty = 'E',
    this.isCompleted = false,
    this.target,
    this.unit,
  });

  factory Quest.fromJson(Map<String, dynamic> json) {
    return Quest(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      xp: (json['rewards']?['xp'] ?? 0) as int,
      gold: (json['rewards']?['gold'] ?? 0) as int,
      type: json['type'] as String? ?? 'GENERAL',
      difficulty: json['difficulty'] as String? ?? 'E',
      isCompleted: json['isCompleted'] as bool? ?? false,
      target: json['target'] as int?,
      unit: json['unit'] as String?,
    );
  }

  Quest copyWith({
    String? id,
    String? title,
    String? description,
    int? xp,
    int? gold,
    String? type,
    String? difficulty,
    bool? isCompleted,
  }) {
    return Quest(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      xp: xp ?? this.xp,
      gold: gold ?? this.gold,
      type: type ?? this.type,
      difficulty: difficulty ?? this.difficulty,
      isCompleted: isCompleted ?? this.isCompleted,
      target: target,
      unit: unit,
    );
  }
}
