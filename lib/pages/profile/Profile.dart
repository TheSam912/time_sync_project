import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../Widgets/HomePage_Widgets.dart';
import 'auth/Login.dart';
import '../../Widgets/custom_snackbar.dart';
import '../../Widgets/editProgramBottomSheet.dart';
import '../../Widgets/showEmptyDesign.dart';
import '../../model/ProgramModel.dart';
import '../../model/UserModel.dart';
import '../../provider/usersProvider.dart';
import '../../repository/programRepository.dart';
import '../../repository/usersRepository.dart';
import '../../constants/AppColor.dart';
import 'auth/services/auth_service.dart';

class Profile extends ConsumerStatefulWidget {
  Profile({super.key, required this.selectedProgram});

  String selectedProgram;

  @override
  ConsumerState<Profile> createState() => _ProfileState();
}

class _ProfileState extends ConsumerState<Profile> {
  String? userProgramPreferences;
  String? userEmail;
  late String titleDate;
  var programResponse;
  bool loading = true;
  bool havePlan = true;

  ProgramModel? userStateProgram;

  @override
  Widget build(BuildContext context) {
    titleDate = DateFormat.yMMMEd().format(DateTime.now());
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.backgroundColor,
      appBar: appBarSection(titleDate, context),
    );
  }
}
