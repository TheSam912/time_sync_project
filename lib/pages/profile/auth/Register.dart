import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Widgets/custom_snackbar.dart';
import '../../../model/UserModel.dart';
import '../../../provider/usersProvider.dart';
import '../../../repository/usersRepository.dart';
import '../../../constants/AppColor.dart';
import 'services/auth_service.dart';

class Register extends ConsumerStatefulWidget {
  const Register({super.key});

  @override
  ConsumerState<Register> createState() => _RegisterState();
}

class _RegisterState extends ConsumerState<Register> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool isObscure = true;
  bool isObscureConfirm = true;

  void register(BuildContext context) async {
    AuthService authService = AuthService();
    if (passwordController.text == confirmPasswordController.text) {
      try {
        authService.signUpWithEmailPassword(emailController.text, passwordController.text, context);
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
        } else {
          customSnackBar(context, "ERROR: ${e.toString()}");
        }
        print(e);
      }
    } else {
      customSnackBar(context, "Passwords not match ! Try Again");
    }
  }

  void registerToServer() async {
    var myMap = {"username": emailController.text, "program": "null"};
    var res = await ref.watch(usersRepositoryProvider).createUser(myMap);
    var newUser = UserModel.fromJson(res);
    ref.watch(userInformation.notifier).update(
          (state) => state = newUser,
        );
    print("User successfully created !!!! ======>${newUser.username}");
    print("User id in state is: ${ref.watch(userInformation).Id}");
  }

  handleObscurePassword() {
    setState(() {
      isObscure = !isObscure;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.mainItemColor,
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 50),
        child: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(top: 30),
          margin: const EdgeInsets.only(right: 12, top: 20),
          child: IconButton(
              onPressed: () {
                context.pop();
              },
              icon: Icon(
                Icons.close,
                color: AppColors.backgroundColor,
              )),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Future.delayed(Duration.zero, () async {
              registerToServer();
              Navigator.pop(context);
            });
            return const Center();
          }
          return Stack(
            children: [
              Positioned(
                  top: 0,
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    alignment: Alignment.center,
                    child: ListView(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Image.asset(
                            "assets/images/logo.png",
                            color: Colors.amber,
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Form(
                              autovalidateMode: AutovalidateMode.disabled,
                              key: _formKey,
                              child: AutofillGroup(
                                  child: Column(
                                children: [
                                  TextFormField(
                                    keyboardType: TextInputType.emailAddress,
                                    autofillHints: const [AutofillHints.username],
                                    cursorColor: Colors.amber,
                                    controller: emailController,
                                    style: GoogleFonts.nunito(
                                        color: AppColors.backgroundColor, fontSize: 14),
                                    decoration: InputDecoration(
                                        border: const OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color.fromRGBO(255, 255, 255, 0.8)),
                                            borderRadius: BorderRadius.all(Radius.circular(12.0))),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              const BorderSide(color: Colors.white, width: 0),
                                          borderRadius: BorderRadius.circular(12.0),
                                        ),
                                        icon: Icon(
                                          Icons.email_outlined,
                                          color: Colors.grey.shade500,
                                        ),
                                        hintText: "Enter You Email Address",
                                        hintStyle: GoogleFonts.nunito(
                                            fontSize: 14, color: Colors.grey.shade500)),
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  TextFormField(
                                    obscuringCharacter: '*',
                                    obscureText: isObscure,
                                    cursorColor: Colors.amber,
                                    autofillHints: const [AutofillHints.password],
                                    controller: passwordController,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.deny(RegExp(r'\s')),
                                    ],
                                    style: GoogleFonts.nunito(
                                        color: AppColors.backgroundColor, fontSize: 14),
                                    decoration: InputDecoration(
                                        border: const OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color.fromRGBO(255, 255, 255, 0.8)),
                                            borderRadius: BorderRadius.all(Radius.circular(12.0))),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              const BorderSide(color: Colors.white, width: 0),
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
                                        hintStyle: GoogleFonts.nunito(
                                            fontSize: 14, color: Colors.grey.shade500)),
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  TextFormField(
                                    obscuringCharacter: '*',
                                    obscureText: isObscureConfirm,
                                    cursorColor: Colors.amber,
                                    autofillHints: const [AutofillHints.password],
                                    controller: confirmPasswordController,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.deny(RegExp(r'\s')),
                                    ],
                                    style: GoogleFonts.nunito(
                                        color: AppColors.backgroundColor, fontSize: 14),
                                    decoration: InputDecoration(
                                        border: const OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color.fromRGBO(255, 255, 255, 0.8)),
                                            borderRadius: BorderRadius.all(Radius.circular(12.0))),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              const BorderSide(color: Colors.white, width: 0),
                                          borderRadius: BorderRadius.circular(12.0),
                                        ),
                                        icon: Icon(
                                          Icons.lock_outline_rounded,
                                          color: Colors.grey.shade500,
                                        ),
                                        suffixIcon: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              isObscureConfirm = !isObscureConfirm;
                                            });
                                          },
                                          child: Icon(
                                            isObscureConfirm
                                                ? Icons.visibility_rounded
                                                : Icons.visibility_off_rounded,
                                            size: 24,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        hintText: "Confirm Your Password",
                                        hintStyle: GoogleFonts.nunito(
                                            fontSize: 14, color: Colors.grey.shade500)),
                                  )
                                ],
                              ))),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        GestureDetector(
                          onTap: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              TextInput.finishAutofillContext(shouldSave: true);
                              register(context);
                            }
                          },
                          child: Container(
                            width: size.width,
                            height: 50,
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(left: 20, right: 20, top: 12),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12), color: Colors.amber),
                            child: Text(
                              "Register",
                              style: GoogleFonts.nunito(
                                  color: AppColors.mainItemColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 100,
                        )
                      ],
                    ),
                  ))
            ],
          );
        },
      ),
    );
  }

  textInputSection(hint, icon, obscure, type, controller) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 3),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.backgroundColor, width: 0.5)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: obscure,
              style: GoogleFonts.nunito(color: AppColors.backgroundColor, fontSize: 14),
              onSubmitted: (value) => register(context),
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
              : const Center()
        ],
      ),
    );
  }
}
