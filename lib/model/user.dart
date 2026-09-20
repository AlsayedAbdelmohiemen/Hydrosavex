

class User {
  String id;
  String username;
  String role;
  String orgCode;
  String email;
  String password;
  String profileImage;

  User({
    this.id = "",
    required this.username,
    required this.role,
    required this.orgCode,
    required this.email,
    required this.password,
    required this.profileImage,
  });

  User.fromJson(Map<String, dynamic> json)
      : this(
    id: json['id'],
    username: json['username'],
    role: json['role'],
    orgCode: json['orgCode'],
    email: json['email'],
    password: json['password'],
    profileImage: json['profileImage'],
  );

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "username": username,
      "role": role,
      "orgCode": orgCode,
      "email": email,
      "password": password,
      "profileImage": profileImage,
    };
  }

  String get getUsername {
    return username;
  }

  String get getEmail {
    return email;
  }

  String get getRole {
    return role;
  }

  String get getOrgCode {
    return orgCode;
  }

  String get getProfileImage {
    return profileImage;
  }
}
