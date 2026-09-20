import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hydrosavex/model/home.dart';
import 'package:firebase_messaging/firebase_messaging.dart'; // Import Firebase Messaging

class HomeProvider with ChangeNotifier {
  List<Home> homes = [];
  String? userOrgCode;
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance; // Firebase Messaging instance

  HomeProvider() {
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
          // Fetch data only once we have the user's organization code
          fetchData();
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
      if (userOrgCode == null) {
        print('Error: userOrgCode is null. Data cannot be fetched.');
        return;
      }

      // Set up a Firestore listener for users collection
      FirebaseFirestore.instance
          .collection('users')
          .where('orgCode', isEqualTo: userOrgCode) // Filter by organization code
          .where('role', isEqualTo: 'home') // Filter by role
          .snapshots()
          .listen((querySnapshot) {
        List<Home> loadedHomes = [];

        for (var document in querySnapshot.docs) {
          final data = document.data();

          // Construct Home object from the Firestore data
          loadedHomes.add(Home(
            id: document.id,
            orgCode: data['orgCode'] ?? '',
            role: data['role'] ?? '',
            orgName: data['homeName'] ?? '',
            email: data['email'] ?? '',
            username: data['username'] ?? '',
            password: data['password'] ?? '',
            profileImage: data['profileImage'] ?? '',
            switcher: data['subscriber'] ?? false, // Handle switcher properly
          ));
        }

        homes = loadedHomes;
        notifyListeners();
      });
    } catch (error) {
      print('Error fetching home data: $error');
      notifyListeners();
    }
  }

  Future<void> updateData(String id, Map<String, dynamic> val) async {
    try {
      final homeIndex = homes.indexWhere((element) => element.id == id);
      if (homeIndex == -1) return;

      // Update Firestore document
      await FirebaseFirestore.instance.collection('users').doc(id).update(val);

      // Update local list with new data
      if (val.containsKey('orgName')) homes[homeIndex].orgName = val['orgName'];
      if (val.containsKey('username')) homes[homeIndex].username = val['username'];
      if (val.containsKey('subscriber')) homes[homeIndex].switcher = val['subscriber'];

      notifyListeners();
    } catch (error) {
      print('Error updating home data: $error');
      notifyListeners();
    }
  }

  Future<void> updateSubscriber(String id, bool subscriber) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection("users")
          .doc(id)
          .get();

      if (doc.exists) {
        // Extract the role and orgId from the document
        var role = doc['role'] ?? ''; // Default to empty string if null
        var orgCode = doc['orgCode'] ?? ''; // Default to empty string if null

        // Subscribe or unsubscribe from the topic based on the subscriber status
        if (subscriber == false) {
          await firebaseMessaging.unsubscribeFromTopic(orgCode + role);
        } else {
          await firebaseMessaging.subscribeToTopic(orgCode + role);
        }

        // Update Firestore document to reflect the new subscription status
        await FirebaseFirestore.instance
            .collection('users')
            .doc(id)
            .update({'subscriber': subscriber});

        print('Subscriber status updated successfully');
      } else {
        print('Error: User with ID $id does not exist.');
      }
    } catch (e) {
      print("Error updating 'subscriber' status: $e");
    }
  }
}
