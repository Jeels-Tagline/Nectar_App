// ignore_for_file: use_build_context_synchronously, await_only_futures

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nectar_app/helpers/auth_helpers.dart';
import 'package:nectar_app/views/components/common_auth_background.dart';
import 'package:nectar_app/views/components/common_body_text.dart';
import 'package:nectar_app/views/components/common_title_text.dart';

class NumberVerificationScreen extends StatefulWidget {
  const NumberVerificationScreen({super.key});

  @override
  State<NumberVerificationScreen> createState() =>
      _NumberVerificationScreenState();
}

class _NumberVerificationScreenState extends State<NumberVerificationScreen> {
  TextEditingController otpController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
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
                          title: "Enter your 6-digit code",
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: h * 0.05),
                          child: const CommonBodyText(text: "Code"),
                        ),
                        TextFormField(
                          controller: otpController,
                          keyboardType: TextInputType.number,
                          maxLength: 6,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "Enter OTP";
                            } else {
                              if (val.length != 6) {
                                return "Enter Valid OTP";
                              }
                            }
                            return null;
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          style: const TextStyle(
                            fontSize: 22,
                            fontFamily: 'Gilroy-Medium',
                          ),
                          decoration: const InputDecoration(
                            counterText: "",
                            hintText: "------",
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
            formKey.currentState!.save();

            showDialog<void>(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return const AlertDialog(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Loading'),
                      CircularProgressIndicator(),
                    ],
                  ),
                );
              },
            );

            Map data = await FirebaseAuthHelper.firebaseAuthHelper
                .verifyOTP(otp: otpController.text);

            if (data['user'] != null) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context)
                ..clearSnackBars()
                ..showSnackBar(
                  const SnackBar(
                    content: Text("Login Successfully...."),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                  ),
                );

              Navigator.pushNamed(context, 'location_screen');
            } else if (data['msg'] != null) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context)
                ..clearSnackBars()
                ..showSnackBar(
                  SnackBar(
                    content: Text(data['msg']),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
            } else {
              Navigator.pop(context);
              ScaffoldMessenger.of(context)
                ..clearSnackBars()
                ..showSnackBar(
                  const SnackBar(
                    content: Text("Logging Failed....."),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
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