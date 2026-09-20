import 'package:hydrosavex/model/user.dart';

class Medic extends User {
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
  final bool switcher;

  Medic({
    required this.id,
    required this.orgCode,
    required this.role,
    required this.email,
    required this.deleted,
    required this.username,
    required this.switcher,
    required super.password,
    required super.profileImage,
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

// Additional logic or methods can be added here
}
