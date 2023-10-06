// ignore_for_file: use_build_context_synchronously, library_prefixes

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nectar_app/helpers/auth_helpers.dart';
import 'package:nectar_app/helpers/firestore_helpers.dart';
import 'package:nectar_app/main.dart';
import 'package:nectar_app/models/globals/globals.dart';
import 'package:nectar_app/utils/language_path.dart';
import 'package:nectar_app/utils/screens_path.dart';
import 'package:nectar_app/utils/user_data.dart';
import 'package:nectar_app/utils/users_info.dart';
import 'package:nectar_app/views/components/common_expansion_tile.dart';
import 'package:nectar_app/views/components/common_scaffold_messenger.dart';
import 'package:nectar_app/views/components/common_show_dialog.dart';
import 'package:nectar_app/views/components/common_small_body_text.dart';
import 'package:nectar_app/views/components/common_textfield.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final GlobalKey<FormState> updateFormKey = GlobalKey<FormState>();
  // String userId = "";
  XFile? imageXFile;
  bool selectLanguage = false;
  String language = 'gu';
  // File? imageXFile;

  final TextEditingController usernameController = TextEditingController();

  Future<String?> getFromGallery({required String oldUrl}) async {
    imageXFile = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 40);

    // New Update
    if (imageXFile != null) {
      String? userImageUrl;
      fStorage.Reference reference;

      CommonShowDialog.show(context: context);
      String fileName = DateTime.now().microsecondsSinceEpoch.toString();
      if (oldUrl.isEmpty) {
        reference = fStorage.FirebaseStorage.instance.ref().child(fileName);
      } else {
        reference = fStorage.FirebaseStorage.instance.refFromURL(oldUrl);
      }

      fStorage.UploadTask uploadTask =
          reference.putFile(File(imageXFile!.path));
      fStorage.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
      await taskSnapshot.ref.getDownloadURL().then((url) async {
        setState(() {
          userImageUrl = url;
        });
      });

      CommonShowDialog.close(context: context);
      return userImageUrl!;
    }
    return null;
  }

  // Future<String> updateImage({required String oldUrl}) async {
  // String? userImageUrl;
  // fStorage.Reference reference;
  // CommonShowDialog.show(context: context);
  // String fileName = DateTime.now().microsecondsSinceEpoch.toString();
  // if (oldUrl.isEmpty) {
  //   reference = fStorage.FirebaseStorage.instance.ref().child(fileName);
  // } else {
  //   reference = fStorage.FirebaseStorage.instance.refFromURL(oldUrl);
  // }
  // fStorage.UploadTask uploadTask = reference.putFile(File(imageXFile!.path));
  // fStorage.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
  // await taskSnapshot.ref.getDownloadURL().then((url) async {
  //   setState(() {
  //     userImageUrl = url;
  //   });
  // });
  // CommonShowDialog.close(context: context);
  // return userImageUrl!;
  // }

  // getUserId() async {
  //   userId = sharedPreferences!.getString(UsersInfo.userId) ?? '';

  //   setState(() {});
  // }

  @override
  void initState() {
    super.initState();
    // getUserId();
    language = sharedPreferences!.getString(LanguagePath.isLanguage) ?? 'en';
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.only(top: h * 0.09),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: w * 0.04, right: w * 0.04),
                    child: Row(
                      children: [
                        Expanded(
                          child: CircleAvatar(
                            radius: 34,
                            backgroundColor: Globals.greenColor,
                            child: CircleAvatar(
                              radius: 32,
                              backgroundColor: Colors.grey.shade300,
                              backgroundImage: (UserData.photo == "")
                                  ? const NetworkImage(
                                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcStsRVE2OpWFMYeY5S1bXG5J4UXp-FkBHGpUM5YDpIsXVWPw2ZdmLUzIitofNwhB_7cahk&usqp=CAU")
                                  : NetworkImage(UserData.photo),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: w * 0.03,
                        ),
                        Expanded(
                          flex: 4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    UserData.displayName,
                                    style: const TextStyle(
                                        fontSize: 20, height: 1),
                                  ),
                                  SizedBox(
                                    width: w * 0.02,
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      await validateUpdate(
                                        id: UserData.uid,
                                        username: UserData.displayName,
                                        image: UserData.photo,
                                        h: h,
                                      );

                                      setState(() {});
                                    },
                                    child: Icon(
                                      Icons.edit,
                                      color: Globals.greenColor,
                                      size: 22,
                                    ),
                                  ),
                                ],
                              ),
                              if (UserData.email.isNotEmpty)
                                CommonSmallBodyText(
                                  text: UserData.email,
                                  color: Colors.grey,
                                )
                              else
                                CommonSmallBodyText(
                                  text: UserData.phoneNumber,
                                  color: Colors.grey,
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: h * 0.02),
                    child: const Divider(),
                  ),
                  CommonExpansionTile(
                    onTap: () {
                      Navigator.pushNamed(context, ScreensPath.ordersScreen);
                    },
                    title: AppLocalizations.of(context)!.orders,
                    icon: const Icon(Icons.shopping_bag_outlined),
                  ),
                  CommonExpansionTile(
                    title: AppLocalizations.of(context)!.myDetails,
                    icon: const Icon(Icons.badge_outlined),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                          context, ScreensPath.getLocationScreen);
                    },
                    child: CommonExpansionTile(
                      title: AppLocalizations.of(context)!.deliveryAddress,
                      icon: const Icon(Icons.location_on_outlined),
                    ),
                  ),
                  CommonExpansionTile(
                    title: AppLocalizations.of(context)!.paymentMethods,
                    icon: const Icon(Icons.credit_card),
                  ),
                  CommonExpansionTile(
                    onTap: () {
                      setState(() {
                        selectLanguage = !selectLanguage;
                      });
                    },
                    title: AppLocalizations.of(context)!.language,
                    icon: const Icon(Icons.language),
                  ),
                  if (selectLanguage)
                    Container(
                      width: w,
                      color: Colors.green.shade50,
                      child: Padding(
                        padding:
                            EdgeInsets.only(left: w * 0.05, right: w * 0.05),
                        child: Column(
                          children: [
                            ListTile(
                              title:
                                  Text(AppLocalizations.of(context)!.english),
                              leading: Radio(
                                value: LanguagePath.english,
                                groupValue: language,
                                onChanged: (value) async {
                                  setState(() {
                                    language = value!;
                                  });
                                  CommonShowDialog.show(context: context);
                                  await sharedPreferences!.setString(
                                      LanguagePath.isLanguage,
                                      LanguagePath.english);
                                  MyNectarApp.setLocale(
                                    context,
                                    const Locale(LanguagePath.english),
                                  );
                                  CommonShowDialog.close(context: context);
                                },
                              ),
                            ),
                            ListTile(
                              title:
                                  Text(AppLocalizations.of(context)!.gujarati),
                              leading: Radio(
                                value: LanguagePath.gujarati,
                                groupValue: language,
                                onChanged: (value) async {
                                  setState(() {
                                    language = value!;
                                  });
                                  CommonShowDialog.show(context: context);
                                  await sharedPreferences!.setString(
                                      LanguagePath.isLanguage,
                                      LanguagePath.gujarati);
                                  MyNectarApp.setLocale(
                                    context,
                                    const Locale(LanguagePath.gujarati),
                                  );
                                  CommonShowDialog.close(context: context);
                                },
                              ),
                            ),
                            ListTile(
                              title: Text(AppLocalizations.of(context)!.urdu),
                              leading: Radio(
                                value: LanguagePath.urdu,
                                groupValue: language,
                                onChanged: (value) async {
                                  setState(() {
                                    language = value!;
                                  });
                                  CommonShowDialog.show(context: context);
                                  await sharedPreferences!.setString(
                                      LanguagePath.isLanguage,
                                      LanguagePath.urdu);
                                  MyNectarApp.setLocale(
                                    context,
                                    const Locale(LanguagePath.urdu),
                                  );
                                  CommonShowDialog.close(context: context);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  CommonExpansionTile(
                    title: AppLocalizations.of(context)!.notifications,
                    icon: const Icon(Icons.notifications_on_outlined),
                  ),
                  CommonExpansionTile(
                    title: AppLocalizations.of(context)!.help,
                    icon: const Icon(Icons.help_outline),
                  ),
                  CommonExpansionTile(
                    title: AppLocalizations.of(context)!.about,
                    icon: const Icon(Icons.error_outline),
                  ),
                  SizedBox(
                    height: h * 0.12,
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(
                  left: w * 0.04,
                  right: w * 0.04,
                  bottom: h * 0.02,
                ),
                child: GestureDetector(
                  onTap: () async {
                    FirebaseAuthHelper.firebaseAuthHelper.logOut();

                    await sharedPreferences!
                        .setBool(UsersInfo.userLogin, false);
                    await sharedPreferences!.setString(UsersInfo.userId, '');
                    await sharedPreferences!
                        .setString(UsersInfo.userDisplayName, '');
                    await sharedPreferences!.setString(UsersInfo.userCity, '');
                    await sharedPreferences!
                        .setString(UsersInfo.userLocation, '');
                    await sharedPreferences!.setString(UsersInfo.userEmail, '');
                    await sharedPreferences!
                        .setString(UsersInfo.userPhoneNumber, '');
                    await sharedPreferences!.setString(UsersInfo.userPhoto, '');

                    Navigator.pushNamedAndRemoveUntil(
                        context, ScreensPath.onbordingScreen, (route) => false);
                  },
                  child: Container(
                    height: h * 0.07,
                    width: w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          left: w * 0.06,
                          top: h * 0.021,
                          child: Icon(
                            Icons.logout,
                            color: Globals.greenColor,
                          ),
                        ),
                        Center(
                          child: Text(
                            AppLocalizations.of(context)!.logOut,
                            style: TextStyle(
                              fontSize: 17,
                              color: Globals.greenColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  validateUpdate({
    required String id,
    required String username,
    required String image,
    required h,
  }) {
    usernameController.text = username;
    String showImage = image;
    bool firstTime = true;
    String? newImageUrl;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(builder: (context, setstatePhoto) {
        return AlertDialog(
          title: Center(
            child: Text(
              "${AppLocalizations.of(context)!.update} ${AppLocalizations.of(context)!.myDetails}",
              style: TextStyle(
                color: Globals.greenColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          content: Form(
            key: updateFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (firstTime)
                  GestureDetector(
                    onTap: () async {
                      String? data = await getFromGallery(oldUrl: image);

                      newImageUrl = data;

                      setstatePhoto(() {
                        firstTime = false;
                        showImage = imageXFile!.path;
                      });
                    },
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.green.shade200,
                      backgroundImage: (image.isEmpty)
                          ? const NetworkImage(
                              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcStsRVE2OpWFMYeY5S1bXG5J4UXp-FkBHGpUM5YDpIsXVWPw2ZdmLUzIitofNwhB_7cahk&usqp=CAU")
                          : NetworkImage(image),
                    ),
                  )
                else
                  GestureDetector(
                    onTap: () async {
                      String? data = await getFromGallery(oldUrl: image);

                      newImageUrl = data;

                      setstatePhoto(() {
                        showImage = imageXFile!.path;
                      });
                    },
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.green.shade200,
                      backgroundImage: FileImage(File(showImage)),
                    ),
                  ),
                const SizedBox(
                  height: 25,
                ),
                CommonTextFormField(
                  controller: usernameController,
                  textAction: TextInputAction.done,
                  labelText: AppLocalizations.of(context)!.username,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return AppLocalizations.of(context)!.enterYourUsername;
                    } else if (val.length <= 6) {
                      return AppLocalizations.of(context)!
                          .enterMinimum7Character;
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            OutlinedButton(
              child: Text(
                AppLocalizations.of(context)!.update,
              ),
              onPressed: () async {
                if (updateFormKey.currentState!.validate()) {
                  updateFormKey.currentState!.save();
                  CommonShowDialog.show(context: context);

                  if (username != usernameController.text &&
                      newImageUrl != null) {
                    await sharedPreferences!.setString(
                        UsersInfo.userDisplayName, usernameController.text);
                    await sharedPreferences!
                        .setString(UsersInfo.userPhoto, newImageUrl!);
                    UserData.displayName = sharedPreferences!
                            .getString(UsersInfo.userDisplayName) ??
                        '';
                    UserData.photo =
                        sharedPreferences!.getString(UsersInfo.userPhoto) ?? '';
                    await FirestoreHelper.firestoreHelper.updateUsername(
                      uid: id,
                      username: usernameController.text,
                    );
                    await FirestoreHelper.firestoreHelper.updateUserPhoto(
                      uid: id,
                      photo: newImageUrl!,
                    );
                  } else if (username != usernameController.text) {
                    await FirestoreHelper.firestoreHelper.updateUsername(
                      uid: id,
                      username: usernameController.text,
                    );

                    await sharedPreferences!.setString(
                        UsersInfo.userDisplayName, usernameController.text);
                    UserData.displayName = usernameController.text;
                  } else if (newImageUrl != null) {
                    await FirestoreHelper.firestoreHelper.updateUserPhoto(
                      uid: id,
                      photo: newImageUrl!,
                    );

                    UserData.photo = newImageUrl!;
                    await sharedPreferences!
                        .setString(UsersInfo.userPhoto, newImageUrl!);
                  }

                  CommonScaffoldMessenger.success(
                    context: context,
                    message: AppLocalizations.of(context)!.userDataUpdated,
                  );

                  CommonShowDialog.close(context: context);
                  Navigator.pop(context);
                }
                setState(() {});
              },
            ),
            OutlinedButton(
              child: Text(
                AppLocalizations.of(context)!.cancel,
              ),
              onPressed: () async {
                usernameController.clear();

                Navigator.pop(context);
              },
            ),
          ],
        );
      }),
    );
  }
}
