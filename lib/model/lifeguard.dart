import 'package:hydrosavex/model/user.dart';

class Lifeguard extends User {
  @override
  final String id;
  @override
  final String orgCode;
  @override
  final String role;
  @override
  final String email;
  late final int deleted;
  @override
  final String username;
  bool switcher;

  Lifeguard({
    this.id = '',
    this.orgCode = '',
    this.role = '',
    this.email = '',
    this.deleted = 0,
    this.username = '',
    this.switcher = false,
    super.password = '',
    super.profileImage = '',
  }) : super(
          id: id,
          email: email,
          role: role,
          orgCode: orgCode,
          username: username,
        );

  // Getter methods
  @override
  String get getOrgCode => orgCode;
  String get getId => id;
  @override
  String get getRole => role;
  @override
  String get getEmail => email;
  @override
  String get getUsername => username;

// Additional methods or logic specific to Lifeguard can be added here
}
