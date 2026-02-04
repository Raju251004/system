class User {
  final String id;
  final String email;
  final String username;
  final int level;
  final int currentXp;
  final Map<String, dynamic> stats;
  final String status;
  final int streak;
  final bool isOnboardingCompleted;
  final String? profilePicture;
  final int hp;
  final int maxHp;
  final int currency;
  final List<String> titles;

  User({
    required this.id,
    required this.email,
    required this.username,
    required this.level,
    required this.currentXp,
    required this.stats,
    required this.status,
    required this.streak,
    required this.isOnboardingCompleted,
    this.profilePicture,
    this.hp = 100,
    this.maxHp = 100,
    this.currency = 0,
    this.titles = const [],
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      username: json['username'] ?? '',
      level: json['level'] ?? 1,
      currentXp: json['currentXp'] ?? 0,
      stats: json['stats'] ?? {},
      status: json['status'] ?? 'NORMAL',
      streak: json['streak'] ?? 0,
      isOnboardingCompleted: json['isOnboardingCompleted'] ?? false,
      profilePicture: json['profilePicture'],
      hp: json['hp'] ?? 100,
      maxHp: json['maxHp'] ?? 100,
      currency: json['currency'] ?? 0,
      titles: (json['titles'] as List?)?.map((e) => e.toString()).toList() ?? [],
    );
  }
  
  // Computed property for UI
  int get xpToNextLevel => level * 1000;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'level': level,
      'currentXp': currentXp,
      'stats': stats,
      'status': status,
      'streak': streak,
      'isOnboardingCompleted': isOnboardingCompleted,
      'isOnboardingCompleted': isOnboardingCompleted,
      'profilePicture': profilePicture,
      'hp': hp,
      'maxHp': maxHp,
      'currency': currency,
      'titles': titles,
    };
  }
}
