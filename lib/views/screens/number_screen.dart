// ignore_for_file: use_build_context_synchronously, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nectar_app/helpers/auth_helpers.dart';
import 'package:nectar_app/helpers/firestore_helpers.dart';
import 'package:nectar_app/utils/font_family.dart';
import 'package:nectar_app/utils/screens_path.dart';
import 'package:nectar_app/views/components/common_auth_background.dart';
import 'package:nectar_app/views/components/common_body_text.dart';
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

  void dataCheck() async {
    var data = await FirestoreHelper.firestoreHelper.fetchUsers();
    userData = data.docs;
  }

  @override
  void initState() {
    super.initState();
    dataCheck();
    phoneController.text = "+91";
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
                          child: const CommonBodyText(text: "Mobile number"),
                        ),
                        TextFormField(
                          controller: phoneController,
                          enabled: true,
                          keyboardType: TextInputType.number,
                          maxLength: 10,
                          onTap: () {
                            phoneController.clear();
                          },
                          validator: (val) {
                            if (val!.isEmpty || val == "+91") {
                              return "Enter Phone Number";
                            } else {
                              if (val.length != 10) {
                                return "Enter Valid Phone Number";
                              }
                            }
                            return null;
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          style: const TextStyle(
                            fontSize: 22,
                            fontFamily: FontFamily.medium,
                          ),
                          decoration: InputDecoration(
                            counterText: "",
                            prefix: SizedBox(
                              height: 20,
                              width: 50,
                              child: Image.asset(
                                "assets/images/india_flag.png",
                              ),
                            ),
                          ),
                        ),
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
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Enter your Username...";
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
          if (formKey.currentState!.validate() && userVerify) {
            formKey.currentState!.save();

            await FirebaseAuthHelper.firebaseAuthHelper
                .phoneLogin(phoneNumber: "+91${phoneController.text}");

            Map data = {
              'phoneNumber': phoneController.text,
              'userName': userNameController.text,
            };
            Navigator.pushNamed(context, ScreensPath.numberVerificationScreen,
                arguments: data);
          } else {
            ScaffoldMessenger.of(context)
              ..clearSnackBars()
              ..showSnackBar(
                const SnackBar(
                  content: Text("Something went wrong...."),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                ),
              );
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
