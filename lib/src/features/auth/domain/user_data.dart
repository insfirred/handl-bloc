class UserData {
  final String id;
  final String name;
  final String email;

  const UserData({
    required this.id,
    required this.name,
    required this.email,
  });

  copyWith(
    String? newId,
    String? newName,
    String? newEmail,
  ) =>
      UserData(
        id: newId ?? id,
        name: newName ?? name,
        email: newEmail ?? email,
      );

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        id: json['id'],
        name: json['name'],
        email: json['email'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
      };
}
