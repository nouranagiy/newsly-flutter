class UserSession {
  final String uid;
  final String name;
  final String email;

  const UserSession({
    required this.uid,
    required this.name,
    required this.email,
  });
}

class UserProfile {
  final String uid;
  final String name;
  final String email;
  final List<String> preferredCategories;

  const UserProfile({
    required this.uid,
    required this.name,
    required this.email,
    this.preferredCategories = const [],
  });

  UserProfile copyWith({List<String>? preferredCategories}) {
    return UserProfile(
      uid: uid,
      name: name,
      email: email,
      preferredCategories: preferredCategories ?? this.preferredCategories,
    );
  }
}
