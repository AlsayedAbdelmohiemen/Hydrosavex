import 'package:hydrosavex/model/user.dart';

class Home extends User {
  @override
  final String id;
  @override
  final String orgCode;
  @override
  final String role;
  late final String orgName;
  @override
  final String email;
  late final bool switcher; // Added switcher property

  Home({
    required this.id,
    required this.orgCode,
    required this.role,
    required this.orgName,
    required this.email,
    required this.switcher, // Initialize switcher in the constructor
    required super.username,
    required super.password,
    required super.profileImage,
  }) : super(
          id: id,
          email: email,
          role: role,
          orgCode: orgCode,
        );

  // Custom getters (if necessary)
  @override
  String get getOrgCode => orgCode;
  @override
  String get getRole => role;
}
