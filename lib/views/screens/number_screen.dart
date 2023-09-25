// ignore_for_file: use_build_context_synchronously, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nectar_app/helpers/auth_helpers.dart';
import 'package:nectar_app/helpers/firestore_helpers.dart';
import 'package:nectar_app/utils/font_family.dart';
import 'package:nectar_app/utils/screens_path.dart';
import 'package:nectar_app/views/components/common_auth_background.dart';
import 'package:nectar_app/views/components/common_textfield.dart';
import 'package:nectar_app/views/components/common_title_text.dart';

class NumberScreen extends StatefulWidget {
  const NumberScreen({super.key});

  @override
  State<NumberScreen> createState() => _NumberScreenState();
}

class _NumberScreenState extends State<NumberScreen> {
  TextEditingController phoneController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController userNameController = TextEditingController();
  bool userVerify = false;
  var userData;
  bool isUser = true;

  final String phoneRegex = r'^\+91\d{10}$';

  String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a phone number.';
    }

    if (!RegExp(phoneRegex).hasMatch(value)) {
      return 'Enter a valid phone number.';
    }

    return null;
  }

  void dataCheck() async {
    var data = await FirestoreHelper.firestoreHelper.fetchUsers();
    userData = data.docs;
  }

  @override
  void initState() {
    super.initState();
    dataCheck();
    phoneController.text = '+91';
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          const CommonAuthBackground(),
          Padding(
            padding: EdgeInsets.only(
              top: h * 0.07,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: h * 0.09,
                    left: w * 0.045,
                    right: w * 0.045,
                  ),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CommonTitleText(
                          title: "Enter your mobile number",
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: h * 0.05),
                          child: TextFormField(
                            controller: phoneController,
                            enabled: true,
                            maxLength: 13,
                            keyboardType: TextInputType.phone,
                            validator: validatePhoneNumber,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9+]')),
                            ],
                            style: const TextStyle(
                              fontSize: 22,
                              fontFamily: FontFamily.medium,
                            ),
                            decoration: InputDecoration(
                              hintStyle: TextStyle(color: Colors.grey.shade400),
                              counterText: "",
                              hintText: "+91 972XXXX599",
                            ),
                          ),
                        ),
                        if (isUser == false)
                          Padding(
                            padding: EdgeInsets.only(top: h * 0.01),
                            child: CommonTextFormField(
                              controller: userNameController,
                              onChange: (val) {
                                if (val!.length <= 6) {
                                  setState(() {
                                    userVerify = false;
                                  });
                                } else {
                                  setState(() {
                                    userVerify = true;
                                  });
                                }
                                return null;
                              },
                              suffixIcon: (userVerify)
                                  ? const Icon(
                                      Icons.done,
                                      color: Colors.green,
                                    )
                                  : const Icon(
                                      Icons.close_rounded,
                                      color: Colors.red,
                                    ),
                              textAction: TextInputAction.next,
                              labelText: "Username",
                              // digitsOnly: [
                              //   FilteringTextInputFormatter.deny(RegExp(r'\s')),
                              // ],
                              validator: (val) {
                                if (val!.trim().isEmpty) {
                                  return "Enter your Username...";
                                } else {
                                  if (val.trim().length <= 6) {
                                    return "Enter minimum 7 character...";
                                  }
                                }
                                return null;
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: GestureDetector(
        onTap: () async {
          if (formKey.currentState!.validate()) {
            bool isPhoneNumber = false;
            String name = '';

            for (int i = 0; i < userData.length; i++) {
              if (userData[i].data()['phoneNumber'] == phoneController.text) {
                isPhoneNumber = true;
                name = userData[i].data()['displayName'];
                setState(() {});
                // if (userData[i].data()['location'] != null) {
                //   isLocation = true;
                // }
              }
            }

            if (isPhoneNumber) {
              // if (formKey.currentState!.validate()) {
              formKey.currentState!.save();
              await FirebaseAuthHelper.firebaseAuthHelper
                  .phoneLogin(phoneNumber: phoneController.text);

              Map data = {
                'phoneNumber': phoneController.text,
                'userName': name,
              };
              Navigator.pushNamed(context, ScreensPath.numberVerificationScreen,
                  arguments: data);
              // }
            } else {
              setState(() {
                isUser = false;
              });

              if (formKey.currentState!.validate() && userVerify) {
                formKey.currentState!.save();

                await FirebaseAuthHelper.firebaseAuthHelper
                    .phoneLogin(phoneNumber: phoneController.text);

                Map data = {
                  'phoneNumber': phoneController.text,
                  'userName': userNameController.text,
                };
                Navigator.pushNamed(
                    context, ScreensPath.numberVerificationScreen,
                    arguments: data);
              }
            }
          }
        },
        child: const CircleAvatar(
          radius: 30,
          backgroundColor: Color(0xff53B175),
          child: Icon(
            Icons.arrow_forward_ios_rounded,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
