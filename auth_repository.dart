import 'dart:developer' as dev;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat_app_flutter/data/models/user_model.dart';
import 'package:chat_app_flutter/data/services/base_repository.dart';

class AuthRepository extends BaseRepository {
  Stream<User?> get authStateChanges => auth.authStateChanges();

  Future<UserModel> signUp({
    required String username,
    required String email,
    required String phoneNumber,
    required String fullName,
    required String password,
  }) async {
    try {
      final formattedPhoneNumber =
          phoneNumber.replaceAll(RegExp(r'\s+'), '').trim();
       ///validation Function for email
      final emailExists = await checkEmailExists(email);
      if (emailExists) {
        throw "An account with the same email already exists";
      }

      // validation Function for phoneNumber
      final phoneNumberExists = await checkphoneNumberExists(formattedPhoneNumber);
      if (phoneNumberExists) {
        throw "An account with the same phoneNumber already exists";
      }
        // validation function for username
      final usernameExists = await checkUsernameExists(username);
      if (usernameExists) {
      throw "An account with the same username already exists";
      }

      final userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        throw "Failed to create user";
      }

      final user = UserModel(
        uid: userCredential.user!.uid,
        username: username,
        Email: email,
        FullName: fullName,
        phoneNumber: formattedPhoneNumber,
        fcmToken: "", // TODO: Replace with actual FCM token
      );

      await saveUserData(user);
      return user;
    } catch (e) {
      dev.log("Sign Up Error: $e");
      rethrow;
    }
  }

  Future<void> signOut() async {
    await auth.signOut();
  }

  Future<bool> checkEmailExists(String email) async {
    try {
      final methods = await auth.fetchSignInMethodsForEmail(email);
      return methods.isNotEmpty;
    } catch (e) {
      print("Error checking email: $e");
      return false;
    }
  }

  Future<bool> checkphoneNumberExists(String phoneNumber) async {
    try {
      final formattedPhoneNumber =
          phoneNumber.replaceAll(RegExp(r'\s+'), '').trim();
      final QuerySnapshot =
          await firestore
              .collection("users")
              .where("phoneNumber", isEqualTo: formattedPhoneNumber)
              .get();
      return QuerySnapshot.docs.isNotEmpty;
    } catch (e) {
      print("Error checking email: $e");
      return false;
    }
  }

  Future<bool> checkUsernameExists(String username) async {
    try {
      final formattedUsername = username.replaceAll(RegExp(r'\s+'), '').trim();
      final querySnapshot =
          await firestore
              .collection("users")
              .where("username", isEqualTo: formattedUsername)
              .get();
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print("Error checking username: $e");
      return false;
    }
  }

  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        throw "User not found";
      }

      final user = await getUserData(userCredential.user!.uid);
      return user;
    } catch (e) {
      dev.log("Sign In Error: $e");
      rethrow;
    }
  }

  Future<void> saveUserData(UserModel user) async {
    try {
      await firestore.collection("users").doc(user.uid).set(user.toMap());
    } catch (e) {
      dev.log("Save User Data Error: $e");
      throw "Failed to save user data";
    }
  }

  Future<UserModel> getUserData(String uid) async {
    try {
      final doc = await firestore.collection("users").doc(uid).get();
      if (!doc.exists) {
        throw "User data not found";
      }

      final userData = UserModel.fromFirestore(doc);
      return userData;
    } catch (e) {
      dev.log("Get User Data Error: $e");
      throw "Failed to fetch user data";
    }
  }
}
