import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Widgets/custom_snackbar.dart';
import '../utils/AppColor.dart';

import '../repository/forget_password.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  TextEditingController emailController = TextEditingController();
  static final auth = FirebaseAuth.instance;
  static late AuthStatus _status;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future<AuthStatus> resetPassword(String email) async {
    await auth
        .sendPasswordResetEmail(email: email)
        .then((value) => _status = AuthStatus.successful)
        .catchError((e) => _status = AuthExceptionHandler.handleAuthException(e));

    return _status;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.mainItemColor,
      appBar: AppBar(
        backgroundColor: AppColors.mainItemColor,
        foregroundColor: AppColors.backgroundColor,
      ),
      body: ListView(
        physics: ClampingScrollPhysics(),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 100,
              ),
              Center(
                child: Image.asset(
                  "assets/images/successful.png",
                  color: Colors.amber,
                  width: size.width / 3,
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
                child: Text(
                  "Please enter your email address. We will send you an email for changing your password and then able to login.",
                  textAlign: TextAlign.justify,
                  style: GoogleFonts.nunito(
                      color: Colors.white, fontSize: 15, fontWeight: FontWeight.w400),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              textInputSection(
                  "Enter You Email Address", Icons.email_outlined, "email", emailController),
              SizedBox(
                height: 16,
              ),
              SizedBox(
                height: 8,
              ),
              GestureDetector(
                onTap: () async {
                  final _status = await resetPassword(emailController.text.trim());
                  if (_status == AuthStatus.successful) {
                    customSnackBar(context, "Recovery Email Successfully sent!");
                    Navigator.pop(context);
                  } else {
                    customSnackBar(context, "Error Happened ! Try Again");
                  }
                },
                child: Container(
                  width: size.width,
                  height: 50,
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.amber),
                  child: Text(
                    "Submit",
                    style: GoogleFonts.nunito(
                        color: AppColors.mainItemColor, fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  textInputSection(hint, icon, type, controller) {
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
            child: TextField(
              controller: controller,
              onSubmitted: (value) {},
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
        ],
      ),
    );
  }
}
