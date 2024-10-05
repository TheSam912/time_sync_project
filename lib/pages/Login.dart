import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Widgets/custom_snackbar.dart';
import '../utils/AppColor.dart';
import '../utils/auth_service.dart';

class Login extends ConsumerStatefulWidget {
  const Login({super.key});

  @override
  ConsumerState<Login> createState() => _LoginState();
}

class _LoginState extends ConsumerState<Login> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isObscure = true;

  handleObscurePassword() {
    setState(() {
      isObscure = !isObscure;
    });
  }

  void login(BuildContext context) async {
    final authService = AuthService();
    try {
      await authService.signInWithEmailPassword(
          emailController.text, passwordController.text, context);
    } catch (e) {
      if (e.toString() == "Exception: INVALID_LOGIN_CREDENTIALS" ||
          e.toString() == "too-many-requests") {
        customSnackBar(
          context,
          "Please check your email or password again !",
        );
      } else if (e.toString() == "Exception: network-request-failed") {
        customSnackBar(
          context,
          "Please check your connection !",
        );
      }
      print(e);
    }
  }

  bool isValidEmail(String? email) {
    return (email?.trim().isNotEmpty ?? false) &&
        RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
            .hasMatch(email!.replaceAll(" ", ""));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.mainItemColor,
      appBar: PreferredSize(
          preferredSize: Size(double.infinity, 70),
          child: Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(top: 30),
            margin: EdgeInsets.only(right: 12, top: 20),
          )),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              alignment: Alignment.center,
              child: ListView(
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,
                children: [
                  Container(
                    height: 150,
                    width: 150,
                    margin: EdgeInsets.only(bottom: 16),
                    child: Image.asset(
                      "assets/images/successful.png",
                      color: Colors.amber,
                    ),
                  ),
                  Form(
                    autovalidateMode: AutovalidateMode.disabled,
                    key: _formKey,
                    child: AutofillGroup(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            autofillHints: const [AutofillHints.username],
                            controller: emailController,
                            style:
                                GoogleFonts.nunito(color: AppColors.backgroundColor, fontSize: 14),
                            decoration: InputDecoration(
                                border: const OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color.fromRGBO(255, 255, 255, 0.8)),
                                    borderRadius: BorderRadius.all(Radius.circular(12.0))),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: Colors.white, width: 0),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                icon: Icon(
                                  Icons.email_outlined,
                                  color: Colors.grey.shade500,
                                ),
                                hintText: "Enter You Email Address",
                                hintStyle:
                                    GoogleFonts.nunito(fontSize: 14, color: Colors.grey.shade500)),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                            obscuringCharacter: '*',
                            obscureText: isObscure,
                            autofillHints: const [AutofillHints.password],
                            controller: passwordController,
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(RegExp(r'\s')),
                            ],
                            style:
                                GoogleFonts.nunito(color: AppColors.backgroundColor, fontSize: 14),
                            decoration: InputDecoration(
                                border: const OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color.fromRGBO(255, 255, 255, 0.8)),
                                    borderRadius: BorderRadius.all(Radius.circular(12.0))),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: Colors.white, width: 0),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                icon: Icon(
                                  Icons.lock_outline_rounded,
                                  color: Colors.grey.shade500,
                                ),
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isObscure = !isObscure;
                                    });
                                  },
                                  child: Icon(
                                    isObscure
                                        ? Icons.visibility_rounded
                                        : Icons.visibility_off_rounded,
                                    size: 24,
                                    color: Colors.grey,
                                  ),
                                ),
                                hintText: "Confirm Your Password",
                                hintStyle:
                                    GoogleFonts.nunito(fontSize: 14, color: Colors.grey.shade500)),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                        ],
                      ),
                    )),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        TextInput.finishAutofillContext(shouldSave: true);
                        login(context);
                      }
                    },
                    child: Container(
                      width: size.width,
                      height: 50,
                      alignment: Alignment.center,
                      margin: EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12), color: Colors.amber),
                      child: Text(
                        "Login",
                        style: GoogleFonts.nunito(
                            color: AppColors.mainItemColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      context.pushNamed('forgetPassword');
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(right: 30, top: 5),
                      child: Text(
                        "Forget Password",
                        textAlign: TextAlign.right,
                        style: GoogleFonts.nunito(
                            color: Colors.amber,
                            fontSize: 13,
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "You don't have an account?",
                              style: GoogleFonts.nunito(
                                  color: AppColors.backgroundColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400),
                            ),
                            GestureDetector(
                              onTap: () {
                                context.pushNamed('register');
                              },
                              child: Text(
                                " Register Now",
                                style: GoogleFonts.nunito(
                                    color: Colors.amber,
                                    fontSize: 14,
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  textInputSection(hint, icon, obscure, type, controller) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 25, vertical: 3),
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 3),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.backgroundColor, width: 0.5)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: TextFormField(
              controller: controller,
              obscureText: obscure,
              keyboardType: TextInputType.emailAddress,
              autofillHints: const [AutofillHints.username],
              validator: (input) =>
                  isValidEmail(input!) ? null : "Double Check Your Email Please !!!",
              inputFormatters: [
                FilteringTextInputFormatter.deny(RegExp(r'\s')),
              ],
              // onSubmitted: (value) {
              //   login(context);
              // },
              style: GoogleFonts.nunito(color: AppColors.backgroundColor, fontSize: 14),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  icon: Icon(
                    icon,
                    color: Colors.grey.shade500,
                  ),
                  hintText: hint,
                  hintStyle: GoogleFonts.nunito(fontSize: 14, color: Colors.grey.shade500)),
            ),
          ),
          type == "password"
              ? IconButton(
                  onPressed: () => handleObscurePassword(),
                  icon: Icon(
                    Icons.remove_red_eye_outlined,
                    color: Colors.grey.shade500,
                  ))
              : Center()
        ],
      ),
    );
  }
}
