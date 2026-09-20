import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hydrosavex/model/OrganisationManager.dart';

class OrganizationManagerProvider with ChangeNotifier {
  List<OrganisationManager> orgManagers = [];
  bool _disposed = false; // Disposed flag to track if the provider is disposed

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  Future<void> fetchData() async {
    await Firebase.initializeApp();
    try {
      var snapshots = FirebaseFirestore.instance.collection('users').snapshots();

      snapshots.listen((QuerySnapshot querySnapshot) {
        if (_disposed) return;  // If disposed, don't do anything

        orgManagers.clear();  // Clear the list to avoid duplicates
        for (var document in querySnapshot.docs) {
          var data = document.data() as Map<String, dynamic>?;
          if (data != null && data['role'] == 'organisationManager') {
            orgManagers.add(OrganisationManager(
              id: document.id,
              orgCode: data['orgCode'] ?? '',
              role: data['role'] ?? '',
              email: data['email'] ?? '',
              orgName: data['organisationName'] ?? '',
              username: data['username'] ?? '',
              password: data['password'] ?? '',
              profileImage: data['profileImage'] ?? '',
            ));
          }
        }
        if (!_disposed) {
          notifyListeners();  // Only notify listeners if not disposed
        }
      });
    } catch (error) {
      if (!_disposed) {
        notifyListeners();  // Only notify listeners if not disposed
      }
    }
  }

  Future<void> updateData(String id, Map<String, dynamic> val) async {
    final userIndex = orgManagers.indexWhere((element) => element.id == id);
    if (userIndex == -1) return; // Ensure the manager exists

    try {
      // Update the user document in 'users' collection
      await FirebaseFirestore.instance.collection('users').doc(id).update(val);

      // Update local state
      var updatedValues = Map<String, dynamic>.from(val);
      for (final key in updatedValues.keys) {
        if (key == 'organisationName') {
          orgManagers[userIndex].orgName = updatedValues[key];

          // Update the organisation name in 'organisations' collection
          await FirebaseFirestore.instance
              .collection('organisations')
              .doc(orgManagers[userIndex].orgCode)
              .update({'organisationName': orgManagers[userIndex].orgName});
        }
      }

      if (!_disposed) {
        notifyListeners();  // Only notify listeners if not disposed
      }
    } catch (error) {
      print('Error updating organisation manager: $error');
    }
  }
}
