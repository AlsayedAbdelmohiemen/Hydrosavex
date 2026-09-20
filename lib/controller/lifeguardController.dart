import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hydrosavex/database/firebase.dart';
import 'package:hydrosavex/model/lifeguard.dart';

class LifeguardProvider with ChangeNotifier {
  List<Lifeguard> lifeguards = [];
  GetFirebase code = GetFirebase();
  String? userOrgCode;

  LifeguardProvider() {
    _getUserOrgCode();
  }

  void _getUserOrgCode() {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .snapshots()
          .listen((event) {
        if (event.exists && event.data()!.containsKey('orgCode')) {
          userOrgCode = event.get("orgCode");
          fetchData(); // Fetch data once we have the user's organization code
        } else {
          print('Error: orgCode does not exist in the user document.');
        }
      });
    } else {
      print('Error: User not logged in.');
    }
  }

  Future<void> fetchData() async {
    try {
      await Firebase.initializeApp();

      FirebaseFirestore.instance.collection('users').snapshots().listen((querySnapshot) {
        List<Lifeguard> loadedLifeguards = [];
        for (var document in querySnapshot.docs) {
          final data = document.data();

          if (data.containsKey('role') && data['role'] == "lifeguard" &&
              data.containsKey('deleted') && data['deleted'] == 0 &&
              data.containsKey('orgCode') && data['orgCode'] == userOrgCode) {

            loadedLifeguards.add(Lifeguard(
              id: document.id,
              orgCode: data['orgCode'] ?? '',
              role: data['role'] ?? '',
              email: data['email'] ?? '',
              username: data['username'] ?? '',
               switcher: data['subscriber'] ?? false,
              password: '', // Add appropriate value for password if needed
              profileImage: '', // Add appropriate value for profileImage if needed
              deleted: data['deleted'] ?? 0,
            ));
          }
        }
        lifeguards = loadedLifeguards;
        notifyListeners();
      });
    } catch (error) {
      print('Error fetching data: $error');
      notifyListeners();
    }
  }

  Future<void> updateData(String id, Map<String, dynamic> val) async {
    try {
      final userIndex = lifeguards.indexWhere((element) => element.id == id);
      if (userIndex == -1) return;

      await FirebaseFirestore.instance.collection('users').doc(id).update(val);

      if (val.containsKey('deleted')) lifeguards[userIndex].deleted = val['deleted'];
      if (val.containsKey('username')) lifeguards[userIndex].username = val['username'];

      notifyListeners();
    } catch (error) {
      print('Error updating data: $error');
      notifyListeners();
    }
  }
}
