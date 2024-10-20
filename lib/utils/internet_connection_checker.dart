import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';

import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/AppColor.dart';

Future execute(InternetConnectionChecker internetConnectionChecker, BuildContext context) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  final StreamSubscription<InternetConnectionStatus> listener =
      InternetConnectionChecker().onStatusChange.listen(
    (InternetConnectionStatus status) {
      switch (status) {
        case InternetConnectionStatus.connected:
          // ignore: avoid_print
          preferences.setString("connectionKey", "connected");
          print('Data connection is available.');

        case InternetConnectionStatus.disconnected:
          // ignore: avoid_print
          preferences.setString("connectionKey", "disconnected");
          showCupertinoDialog(
              context: context,
              builder: (BuildContext context) {
                return Material(
                  child: Container(
                    decoration: BoxDecoration(
                        color: AppColors.backgroundColor, borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                            height: 300,
                            width: 300,
                            child: Lottie.asset("assets/lottie/connection.json")),
                        Text(
                          "Please check your \nnetwork CONNECTION",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.nunito(
                              fontSize: 16,
                              color: AppColors.mainItemColor,
                              fontWeight: FontWeight.w700),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () async {
                            final bool isConnected =
                                await InternetConnectionChecker().hasConnection;

                            if (isConnected == true) {
                              if (context.canPop()) {
                                Navigator.pop(context);
                              }
                            }
                          },
                          child: Container(
                            height: 50,
                            margin: EdgeInsets.only(bottom: 12, left: 50, right: 50),
                            decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Center(
                              child: Text(
                                "Try Again !!!",
                                style: GoogleFonts.nunito(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.mainItemColor,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              });
      }
    },
  );

  // close listener after 30 seconds, so the program doesn't run forever
  await Future<void>.delayed(const Duration(seconds: 30));
  await listener.cancel();
}
