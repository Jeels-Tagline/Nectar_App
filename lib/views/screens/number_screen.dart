import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nectar_app/helpers/auth_helpers.dart';
import 'package:nectar_app/views/components/common_auth_background.dart';
import 'package:nectar_app/views/components/common_body_text.dart';
import 'package:nectar_app/views/components/common_title_text.dart';

class NumberScreen extends StatefulWidget {
  const NumberScreen({super.key});

  @override
  State<NumberScreen> createState() => _NumberScreenState();
}

class _NumberScreenState extends State<NumberScreen> {
  TextEditingController phoneController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    phoneController.text = "+91";
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      // resizeToAvoidBottomInset: false,
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
                            fontFamily: 'Gilroy-Medium',
                          ),
                          decoration: InputDecoration(
                            counterText: "",
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.deepPurple,
                                width: 2,
                              ),
                            ),
                            prefix: SizedBox(
                              height: 20,
                              width: 50,
                              child: Image.asset(
                                "assets/images/india_flag.png",
                              ),
                            ),
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

            await FirebaseAuthHelper.firebaseAuthHelper
                .phoneLogin(phoneNumber: "+91${phoneController.text}");

            // ignore: use_build_context_synchronously
            Navigator.pushNamed(context, 'number_verification_screen');
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
