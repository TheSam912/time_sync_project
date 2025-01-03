import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../provider/usersProvider.dart';
import '../../../constants/AppColor.dart';

class EditProgram extends ConsumerStatefulWidget {
  const EditProgram({super.key});

  @override
  ConsumerState<EditProgram> createState() => _EditProgramState();
}

class _EditProgramState extends ConsumerState<EditProgram> {
  @override
  void initState() {
    super.initState();
    ref.read(userInformation);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: PreferredSize(
          preferredSize: const Size(double.infinity, 70),
          child: Container(
            color: AppColors.mainItemColor,
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.close,
                    color: AppColors.mainItemColor,
                  ),
                ),
                Text(
                  "Customize The Program",
                  style: GoogleFonts.nunito(
                      color: AppColors.backgroundColor, fontSize: 18, fontWeight: FontWeight.w800),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.close,
                    color: AppColors.backgroundColor,
                  ),
                ),
              ],
            ),
          )),
      body: ListView(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        children: [
          Container(
            height: 30,
            decoration: const BoxDecoration(
                color: AppColors.mainItemColor,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(100),
                )),
          )
        ],
      ),
    );
  }
}
