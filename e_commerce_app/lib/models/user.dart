class User {
  final String uuid;
  final String fullName;

  // final String token;
  // DateTime? expiryDate;
  final String email;
  final String password;

  User({
    required this.uuid,
    required this.fullName,
    // required this.token,
    // this.expiryDate,
    required this.email,
    required this.password,
  });

  User copyWith({
    String? uuid,
    // DateTime? expiryDate,
    String? email,
    String? password,
    String? fullName,
    // String? token,
  }) {
    return User(
      uuid: uuid ?? this.uuid,
      fullName: fullName ?? this.fullName,
      // token: token ?? this.token,
      // expiryDate: expiryDate ?? this.expiryDate,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': this.fullName,
      'email': this.email,
      'password': this.password,
      'uuid': this.uuid,
    };
  }
}
