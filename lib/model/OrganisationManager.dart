import 'package:hydrosavex/model/user.dart';

class OrganisationManager extends User {
  @override
  final String id;
  @override
  final String orgCode;
  @override
  final String role;
  late final String orgName;
  @override
  final String email;

  OrganisationManager({
    required this.id,
    required this.orgCode,
    required this.role,
    required this.orgName,
    required this.email,
    required super.username,
    required super.password,
    required super.profileImage,
  }) : super(
          id: id,
          email: email,
          role: role,
          orgCode: orgCode,
        );

  @override
  String get getOrgCode => orgCode;
  @override
  String get getRole => role;
}
