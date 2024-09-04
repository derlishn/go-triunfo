class User {
  final String uid;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final String? gender;
  final String role;
  final bool isActive;
  final DateTime createdAt;

  User({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoUrl,
    this.gender,
    required this.role,
    required this.isActive,
    required this.createdAt,
  });
}
