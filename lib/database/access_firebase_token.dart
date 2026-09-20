import 'package:googleapis_auth/auth_io.dart';
import 'firebase_service_account.dart';

class AccessTokenFirebase {
  static String firebaseMessagingScope =
      "https://www.googleapis.com/auth/firebase.messaging";

  Future<String> getAccessToken() async {
    final client = await clientViaServiceAccount(
        ServiceAccountCredentials.fromJson(FirebaseServiceAccountConfig.credentials),
        [firebaseMessagingScope]);

    final accessToken = client.credentials.accessToken.data;
    return accessToken;
  }
}
