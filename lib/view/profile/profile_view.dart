import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hydrosavex/controller/home.dart';
import 'package:hydrosavex/database/firebase.dart';
import 'package:hydrosavex/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:hydrosavex/controller/lifeguardController.dart';
import 'package:hydrosavex/controller/medicController.dart';
import 'package:hydrosavex/controller/organizationManagerController.dart';
import '../../utils/constants/colors.dart';
import '../../utils/helpers/custom_loading.dart';
import '../../utils/helpers/helper_functions.dart';
import 'widgets/profile_avatar.dart';
import 'widgets/profile_edit_button.dart';
import 'widgets/profile_edit_dialog.dart';
import 'widgets/profile_field_tile.dart';

class Profile extends StatefulWidget {
  final String type;
  const Profile(this.type, {super.key});
  static const String routeName = "profile";
  @override
  _Profile createState() => _Profile(type);
}

class _Profile extends State<Profile> {
  final String accType;

  _Profile(this.accType);

  GetFirebase fb = GetFirebase();
  var userList;
  bool prog = true;
  bool err = false;
  var update;
  String? _imageUrl;
  File? uImage;
  var user_id;
  int? userIndex;
  var ref;

  @override
  void initState() {
    super.initState();

    if (accType == 'lifeguard') {
      Provider.of<LifeguardProvider>(context, listen: false)
          .fetchData()
          .then((value) {
        if (!mounted) return;
        setState(() {
          prog = false;
        });
      });
      update = Provider.of<LifeguardProvider>(context, listen: false);
    } else if (accType == 'medic') {
      Provider.of<MedicProvider>(context, listen: false)
          .fetchData()
          .then((value) {
        if (!mounted) return;
        setState(() {
          prog = false;
        });
      });
      update = Provider.of<MedicProvider>(context, listen: false);
    } else if (accType == 'org') {
      Provider.of<OrganizationManagerProvider>(context, listen: false)
          .fetchData()
          .then((value) {
        if (!mounted) return;
        setState(() {
          prog = false;
        });
      });
      update = Provider.of<OrganizationManagerProvider>(context, listen: false);
    } else if (accType == 'home') {
      Provider.of<HomeProvider>(context, listen: false)
          .fetchData()
          .then((value) {
        if (!mounted) return;
        setState(() {
          prog = false;
        });
      });
      update = Provider.of<HomeProvider>(context, listen: false);
    }

    user_id = GetFirebase().getUserID;
    ref = GetFirebase().fbStorage.child('user' + user_id + '.png');
    ref.getDownloadURL().then((loc) {
      if (!mounted) return;
      setState(() {
        _imageUrl = loc;
      });
    }).catchError((error) {
      if (!mounted) return;
      setState(() {
        _imageUrl = null;
      });
    });
  }

  Future<void> getImage() async {
    final picker = ImagePicker();
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, maxWidth: 600);

    if (pickedFile != null) {
      if (!mounted) return;
      setState(() {
        uImage = File(pickedFile.path);
        _imageUrl = '';
      });

      String filename = "user" + user_id + '.png';
      var firebaseStorageRef = GetFirebase().fbStorage.child(filename);

      try {
        var taskSnapshot = await firebaseStorageRef.putFile(uImage!);
        var downloadUrl = await taskSnapshot.ref.getDownloadURL();
        if (!mounted) return;
        setState(() {
          _imageUrl = downloadUrl;
        });
      } on FirebaseException catch (e) {
        print('Error uploading image: $e');
        if (!mounted) return;
        setState(() {});
      }
    }
  }

  void _showEditOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.image),
              title: Text(AppLocalizations.of(context)!.edit_image),
              onTap: () {
                Navigator.pop(context);
                getImage();
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: Text(AppLocalizations.of(context)!.edit_name),
              onTap: () {
                Navigator.pop(context);
                final isOrg = userList[userIndex!].role == 'organisationManager';
                final dialogType = isOrg
                    ? AppLocalizations.of(context)!.organization_name
                    : AppLocalizations.of(context)!.username;
                final initialVal = isOrg
                    ? (userList[userIndex!].orgName ?? '')
                    : (userList[userIndex!].username ?? '');

                ProfileEditDialog.show(
                  context: context,
                  type: dialogType,
                  initialValue: initialVal,
                  onSubmitted: (newVal) {
                    update.updateData(
                      user_id,
                      isOrg ? {'organisationName': newVal} : {'username': newVal},
                    );
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final dark = SHelperFunctions.isDarkMode(context);
    if (!prog && userList == null) {
      err = true;
    }

    if (accType == "lifeguard") {
      userList =
          Provider.of<LifeguardProvider>(this.context, listen: true).lifeguards;
      user_id = GetFirebase().getUserID;
      userIndex = userList.indexWhere((element) => element.id == user_id);
    } else if (accType == "medic") {
      userList = Provider.of<MedicProvider>(this.context, listen: true).medic;
      user_id = GetFirebase().getUserID;
      userIndex = userList.indexWhere((element) => element.id == user_id);
    } else if (accType == "org") {
      userList =
          Provider.of<OrganizationManagerProvider>(this.context, listen: true)
              .orgManagers;
      user_id = GetFirebase().getUserID;
      userIndex = userList.indexWhere((element) => element.id == user_id);
    } else if (accType == "home") {
      userList = Provider.of<HomeProvider>(this.context, listen: true).homes;
      user_id = GetFirebase().getUserID;
      userIndex = userList.indexWhere((element) => element.id == user_id);
    }

    if (userIndex == null || userIndex == -1) {
      return Scaffold(
        body: Container(
          color: dark ? SColors.dark : SColors.primaryBackground,
          child: const Center(
            child: CustomLoading(),
          ),
        ),
      );
    }

    return err
        ? WillPopScope(
            onWillPop: () async {
              return Navigator.canPop(context);
            },
            child: Scaffold(
              body: AlertDialog(
                title: const Text('Error'),
                content: const Text('Error while fetching data!'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Exit'),
                  ),
                ],
              ),
            ),
          )
        : WillPopScope(
            onWillPop: () async {
              return Navigator.canPop(context);
            },
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                elevation: 0,
                leading: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Transform.scale(
                    scale: 0.7,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF1980B8),
                          width: 1.8,
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Color(0xFF1980B8),
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ),
                centerTitle: true,
                title: Text(
                  AppLocalizations.of(context)!.profile1,
                  style: const TextStyle(
                    fontSize: 25,
                    letterSpacing: 1.5,
                    color: Color(0xFF0C76B0),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              body: prog
                  ? Scaffold(
                      body: Container(
                        color: dark ? SColors.dark : SColors.primaryBackground,
                        child: const Center(
                          child: CustomLoading(),
                        ),
                      ),
                    )
                  : ListView(
                      padding: const EdgeInsets.all(20),
                      children: [
                        Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            Container(
                              alignment: Alignment.topCenter,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ProfileAvatar(
                                    imageUrl: _imageUrl,
                                    localImage: uImage,
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 30),
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ProfileFieldTile(
                                hintText: userList[userIndex!].role ==
                                        'organisationManager'
                                    ? userList[userIndex!].orgName
                                    : userList[userIndex!].username,
                                type: userList[userIndex!].role ==
                                        'organisationManager'
                                    ? AppLocalizations.of(context)!
                                        .organization_name
                                    : AppLocalizations.of(context)!.name,
                              ),
                              ProfileFieldTile(
                                hintText: userList[userIndex!].email,
                                type: AppLocalizations.of(context)!.email,
                              ),
                              const SizedBox(height: 32),
                              ProfileEditButton(
                                onTap: () => _showEditOptions(context),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
            ),
          );
  }
}
