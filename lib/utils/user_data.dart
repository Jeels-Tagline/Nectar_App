import 'package:nectar_app/main.dart';
import 'package:nectar_app/utils/users_info.dart';

class UserData {
  static String uid = '';
  static String displayName = '';
  static String email = '';
  static String city = '';
  static String location = '';
  static String phoneNumber = '';
  static String photo = '';

  static Future setUserData() async {
    uid = sharedPreferences!.getString(UsersInfo.userId) ?? '';
    displayName = sharedPreferences!.getString(UsersInfo.userDisplayName) ?? '';
    email = sharedPreferences!.getString(UsersInfo.userEmail) ?? '';
    city = sharedPreferences!.getString(UsersInfo.userCity) ?? '';
    location = sharedPreferences!.getString(UsersInfo.userLocation) ?? '';
    phoneNumber = sharedPreferences!.getString(UsersInfo.userPhoneNumber) ?? '';
    photo = sharedPreferences!.getString(UsersInfo.userPhoto) ?? '';
  }
}
