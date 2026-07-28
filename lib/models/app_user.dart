class AppUser {
  const AppUser({
    this.id,
    required this.fullName,
    required this.username,
    required this.email,
    required this.phone,
    required this.bio,
  });

  final int? id;
  final String fullName;
  final String username;
  final String email;
  final String phone;
  final String bio;

  factory AppUser.fromMap(Map<String, Object?> map) {
    return AppUser(
      id: map['id'] as int?,
      fullName: map['full_name'] as String,
      username: map['username'] as String,
      email: map['email'] as String,
      phone: map['phone'] as String? ?? '',
      bio: map['bio'] as String? ?? '',
    );
  }
}
