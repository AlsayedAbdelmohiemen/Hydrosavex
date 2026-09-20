import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hydrosavex/database/firebase.dart';
import 'package:hydrosavex/model/medic.dart';
import 'dart:async';

class MedicProvider with ChangeNotifier {
  List<Medic> medic = [];
  GetFirebase code = GetFirebase();
  String? userOrgCode;
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  StreamSubscription<QuerySnapshot>? _subscription;
  bool _disposed = false; // Track whether the provider has been disposed

  MedicProvider() {
    _getUserOrgCode();
  }

  void _getUserOrgCode() {
    FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .snapshots()
        .listen((event) {
      if (event.data() != null) {
        userOrgCode = event.data()?["orgCode"];
        fetchData(); // Fetch data once we have the user's organization code
      }
    });
  }

  Future<void> fetchData() async {
    await Firebase.initializeApp();
    try {
      medic.clear(); // Clear the list before adding new data

      var snaps = FirebaseFirestore.instance.collection('users');
      _subscription = snaps.snapshots().listen((QuerySnapshot querySnapshot) {
        if (_disposed) return; // Prevent further actions if provider is disposed

        medic.clear(); // Clear again to prevent duplication
        for (var document in querySnapshot.docs) {
          var data = document.data() as Map<String, dynamic>?;

          if (data != null &&
              data.containsKey('role') &&
              data['role'] == "medic" &&
              data.containsKey('deleted') &&
              data['deleted'] == 0 &&
              data.containsKey('orgCode') &&
              data['orgCode'] == userOrgCode) {
            medic.add(Medic(
              id: document.id,
              orgCode: data['orgCode'] ?? '',
              role: data['role'] ?? '',
              email: data['email'] ?? '',
              username: data['username'] ?? '',
              switcher: data['subscriber'] ?? false,
              password: '', // Assign actual password value if needed
              profileImage: '', // Assign actual profile image value if needed
              deleted: data['deleted'] ?? 0,
            ));
          }
        }
        if (!_disposed) notifyListeners(); // Notify listeners if not disposed
      });
    } catch (error) {
      if (!_disposed) {
        print('Error fetching data: $error');
        notifyListeners();
      }
    }
  }

  Future<void> updateSubscriber(String id, bool subscriber) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection("users")
          .doc(id)
          .get();

      if (doc.exists) {
        var role = doc['role'] ?? ''; // Default to empty string if null
        var orgId = doc['orgId'] ?? ''; // Default to empty string if null

        if (subscriber == false) {
          await firebaseMessaging.unsubscribeFromTopic(orgId + role);
        } else {
          await firebaseMessaging.subscribeToTopic(orgId + role);
        }

        await FirebaseFirestore.instance
            .collection('users')
            .doc(id)
            .update({'subscriber': subscriber});
      } else {
        print('Error: User with ID $id does not exist.');
      }
    } catch (e) {
      print("Error updating 'subscriber' status: $e");
    }
  }

  Future<void> updateData(String id, Map<String, dynamic> val) async {
    try {
      final userIndex = medic.indexWhere((element) => element.id == id);
      if (userIndex == -1) return;

      await FirebaseFirestore.instance.collection('users').doc(id).update(val);

      if (!_disposed) {
        val.forEach((key, value) {
          if (key == 'deleted') medic[userIndex].deleted = value;
          if (key == 'username') medic[userIndex].username = value;
        });

        notifyListeners();
      }
    } catch (error) {
      if (!_disposed) {
        print('Error updating data: $error');
        notifyListeners();
      }
    }
  }

  @override
  void dispose() {
    _disposed = true;  // Mark the provider as disposed
    _subscription?.cancel(); // Cancel the Firestore subscription
    super.dispose();
  }
}
