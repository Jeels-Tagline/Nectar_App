// ignore_for_file: use_build_context_synchronously, dead_code

import 'package:flutter/material.dart';
import 'package:nectar_app/helpers/auth_helpers.dart';
import 'package:nectar_app/utils/images_path.dart';
import 'package:nectar_app/views/components/common_action_button.dart';
import 'package:nectar_app/views/components/common_auth_background.dart';
import 'package:nectar_app/views/components/common_scaffold_messenger.dart';
import 'package:nectar_app/views/components/common_show_dialog.dart';
import 'package:nectar_app/views/components/common_small_body_text.dart';
import 'package:nectar_app/views/components/common_textfield.dart';
import 'package:nectar_app/views/components/common_title_text.dart';
import 'package:nectar_app/views/screens/auth_module/signin_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController emailController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool emailVerify = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: CommonAuthBackground(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 35,
            left: 16,
            right: 16,
          ),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 240,
                    width: double.infinity,
                    child: Image(
                      image: AssetImage(
                        ImagesPath.carotOrange,
                      ),
                    ),
                  ),
                  CommonTitleText(
                    title: AppLocalizations.of(context)!.forgotPassword,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: CommonSmallBodyText(
                      text: AppLocalizations.of(context)!.enterYourEmail,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: CommonTextFormField(
                      controller: emailController,
                      textType: TextInputType.emailAddress,
                      textAction: TextInputAction.done,
                      labelText: AppLocalizations.of(context)!.email,
                      onChange: (val) {
                        if (val!.contains('@') && val.contains('.com')) {
                          setState(() {
                            emailVerify = true;
                          });
                        } else {
                          setState(() {
                            emailVerify = false;
                          });
                        }

                        return null;
                      },
                      suffixIcon: (emailVerify)
                          ? const Icon(
                              Icons.done,
                              color: Colors.green,
                            )
                          : const Icon(
                              Icons.close_rounded,
                              color: Colors.red,
                            ),
                      validator: (val) {
                        if (val!.isEmpty) {
                          return AppLocalizations.of(context)!.enterYourEmail;
                        } else {
                          if (val.contains('@') && val.contains('.com')) {
                            return null;
                          } else {
                            return AppLocalizations.of(context)!.somethingWrong;
                          }
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 90),
                    child: GestureDetector(
                      onTap: () async {
                        if (formKey.currentState!.validate() && emailVerify) {
                          formKey.currentState!.save();
                          CommonShowDialog.show(context: context);

                          Map<String, dynamic> data = await FirebaseAuthHelper
                              .firebaseAuthHelper
                              .forgotPassword(
                                  email: emailController.text.trim());

                          if (data['user'] != null) {
                            CommonShowDialog.close(context: context);
                            CommonScaffoldMessenger.success(
                              context: context,
                              message: AppLocalizations.of(context)!
                                  .checkYourEmailAndResetPassword,
                            );

                            Navigator.pushReplacement(
                              context,
                              PageTransition(
                                type: PageTransitionType.fade,
                                child: const SignInScreen(),
                              ),
                            );
                          } else if (data['msg'] != null) {
                            CommonShowDialog.close(context: context);
                            CommonScaffoldMessenger.failed(
                                context: context, message: data['msg']);
                          } else {
                            CommonShowDialog.close(context: context);

                            CommonScaffoldMessenger.failed(
                              context: context,
                              message:
                                  AppLocalizations.of(context)!.somethingWrong,
                            );
                          }
                        }
                      },
                      child: CommonActionButton(
                          name:
                              "${AppLocalizations.of(context)!.reset} ${AppLocalizations.of(context)!.password}"),
                    ),
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
