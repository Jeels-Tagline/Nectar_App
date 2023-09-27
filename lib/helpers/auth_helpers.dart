// ignore_for_file: prefer_typing_uninitialized_variables, dead_code_catch_following_catch

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthHelper {
  FirebaseAuthHelper._();
  static final FirebaseAuthHelper firebaseAuthHelper = FirebaseAuthHelper._();

  static final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  static final GoogleSignIn googleSignIn = GoogleSignIn();

  String? verifyId;
  // jeels
  int? resendToken;

  Future<Map<String, dynamic>> logInAnonymously() async {
    Map<String, dynamic> data = {};

    try {
      UserCredential userCredential = await firebaseAuth.signInAnonymously();

      User? user = userCredential.user;

      data['user'] = user;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "admin-restricted-operation":
          data['msg'] = "This Service is Temporary Disabled.....";
          break;
      }
    }
    return data;
  }

  Future<Map<String, dynamic>> phoneLogin({
    required String phoneNumber,
  }) async {
    Map<String, dynamic> data = {};

    // jeels

    // await FirebaseAppCheck.instance.activate(
    //   androidProvider: AndroidProvider.playIntegrity,
    // );
    // await firebaseAuth.setSettings(appVerificationDisabledForTesting: true);

    await firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (credentials) async {
        await firebaseAuth.signInWithCredential(credentials);
      },
      codeSent: (verificationID, resendTokenn) async {
        verifyId = verificationID;
        // jeels
        resendToken = resendTokenn;
      },

      // jeels
      timeout: const Duration(seconds: 50),
      codeAutoRetrievalTimeout: (verificationID) {
        verificationID = verifyId!;
      },
      // jeels
      forceResendingToken: resendToken,

      verificationFailed: (e) {
        switch (e.code) {
          case "operation-not-allowed":
            data['msg'] = "This Service is Temporary Disabled.....";
            break;
          case "too-many-requests":
            data['msg'] = "Wait for 1 day.....";
            break;
          case "invalid-phone-number":
            data['msg'] = "Invalid Phone Number";
            break;
          case "channel-error":
            data['msg'] = "Channel Error";
        }
      },
    );

    return data;
  }

  Future<Map<String, dynamic>> verifyOTP({
    required String otp,
  }) async {
    Map<String, dynamic> data = {};
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verifyId!,
        smsCode: otp,
      );

      User? user = (await firebaseAuth.signInWithCredential(credential)).user;

      data['user'] = user;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "operation-not-allowed":
          data['msg'] = "This Service is Temporary Disabled.....";
          break;
        case "channel-error":
          data['msg'] = "IDK";
          break;
        case "invalid-verification-id":
          data['msg'] = "Invalid Verification Id";
          break;
        case "invalid-verification-code":
          data['msg'] = "OTP Wrong";
      }
    }

    return data;
  }

  Future<Map<String, dynamic>> signUp(
      {required String email, required String password}) async {
    Map<String, dynamic> data = {};

    try {
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      User? user = userCredential.user;

      data['user'] = user;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "operation-not-allowed":
          data['msg'] = "This Service is Temporary Disabled.....";
          break;
        case "weak-password":
          data['msg'] = "This password is too weak......";
          break;
        case "email-already-in-use":
          data['msg'] = "This account already exist......";
          break;
      }
    }

    return data;
  }

  Future<Map<String, dynamic>> signIn(
      {required String email, required String password}) async {
    Map<String, dynamic> data = {};

    try {
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      User? user = userCredential.user;
      data['user'] = user;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "operation-not-allowed":
          data['msg'] = "This Service is Temporary Disabled.....";
          break;
        case "user-not-found":
          data['msg'] = "User not registered......";
          break;
        case "wrong-password":
          data['msg'] = "Wrong password......";
          break;
      }
    }

    return data;
  }

  Future<Map<String, dynamic>> forgotPassword({required String email}) async {
    Map<String, dynamic> data = {};

    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
      data['user'] = "Accept";
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "operation-not-allowed":
          data['msg'] = "This Service is Temporary Disabled.....";
          break;
        case "user-not-found":
          data['msg'] = "User not registered......";
          break;
      }
    }

    return data;
  }

  Future<Map<String, dynamic>> signInWithGoogle() async {
    Map<String, dynamic> data = {};
    var credential;

    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    try {
      credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
    } catch (e) {
      // cancel google login
    }

    if (credential != null) {
      try {
        UserCredential userCredential =
            await firebaseAuth.signInWithCredential(credential);

        User? user = userCredential.user;

        data['user'] = user;
      } on FirebaseAuthException catch (e) {
        switch (e.code) {
          case "operation-not-allowed":
            data['msg'] = "This Service is Temporary Disabled.....";
            break;
        }
      }
    }

    return data;
  }

  // Future<Map<String, dynamic>> googleLogin() async {
  //   Map<String, dynamic> data = {};
  //   final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
  //   final GoogleSignInAuthentication? googleAuth =
  //       await googleUser?.authentication;
  //   final credential = GoogleAuthProvider.credential(
  //     accessToken: googleAuth?.accessToken,
  //     idToken: googleAuth?.idToken,
  //   );
  //   try {
  //     UserCredential userCredential =
  //         await firebaseAuth.signInWithCredential(credential);
  //     User? user = userCredential.user;
  //     data['user'] = user;
  //   } on FirebaseAuthException catch (e) {
  //     switch (e.code) {
  //       case "operation-not-allowed":
  //         data['msg'] = "This Service is Temporary Disabled.....";
  //         break;
  //     }
  //   }
  //   return data;
  // }

  Future<void> logOut() async {
    await firebaseAuth.signOut();
    await googleSignIn.signOut();
  }
}
