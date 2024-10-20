import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import '../../Widgets/Second_template.dart';
import '../../model/UserModel.dart';
import '../../provider/usersProvider.dart';
import '../../repository/usersRepository.dart';
import '../../Widgets/HomePage_Widgets.dart';
import '../../model/ProgramModel.dart';
import '../../repository/homeRepository.dart';
import '../../constants/AppColor.dart';
import '../../utils/internet_connection_checker.dart';

class Home extends ConsumerStatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  int touchedIndex = -1;
  int categoryIndex = 0;
  late String titleDate;
  bool isLoading = true;
  List<dynamic>? categoryList;
  List<dynamic>? programList;
  List<dynamic>? selectedProgramList;
  ProgramModel? programResponse;
  String? programId;
  List<ProgramModelRoutineItems>? roadMapElements = [];
  List<String> points = [];
  bool? isConnected;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await _checkInternetConnection();
    ref.read(homePageRequests);
  }

  Future<void> _checkInternetConnection() async {
    await execute(InternetConnectionChecker(), context);
  }

  Future<void> _fetchHomePageData() async {
    isConnected = await InternetConnectionChecker().hasConnection;
    if (isConnected == true && categoryIndex == 0) {
      final homeResponse = ref.watch(homePageRequests);
      homeResponse.when(
        data: (data) {
          setState(() {
            categoryList = data.elementAt(0);
            programList = data.elementAt(1);
            isLoading = false;
          });
        },
        error: (error, stackTrace) {
          _showLoadingIndicator();
        },
        loading: () {
          _showLoadingIndicator();
        },
      );
    }
  }

  void _showLoadingIndicator() {
    setState(() {
      isLoading = true;
    });
  }

  Future<void> _getUserActiveProgram(String? username) async {
    final response = await ref.watch(usersRepositoryProvider).getUser(username);
    if (response != null) {
      final user = UserModel.fromJson(response);
      ref.watch(userInformation.notifier).update((state) => user);
    }
  }

  @override
  Widget build(BuildContext context) {
    _fetchHomePageData();
    titleDate = DateFormat.yMMMEd().format(DateTime.now());

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: appBarSection(titleDate, context),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: AppColors.mainItemColor,
              ),
            )
          : StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final userEmail = snapshot.data?.email;
                  _getUserActiveProgram(userEmail);
                }
                return _buildHomeContent();
              },
            ),
    );
  }

  Widget _buildHomeContent() {
    return Consumer(
      builder: (context, ref, child) {
        ref.watch(userInformation);
        return isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: AppColors.mainItemColor,
                ),
              )
            : homeDesign();
      },
    );
  }

  Widget homeDesign() {
    return ListView(
      physics: const ClampingScrollPhysics(),
      children: [
        homePageTop(),
        _categorySection(),
        _programsSection(),
      ],
    );
  }

  Widget _categorySection() {
    return Container(
      height: 45,
      margin: const EdgeInsets.only(top: 12, bottom: 8, left: 8),
      child: ListView.builder(
        itemCount: (categoryList?.length ?? 0) + 1,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return _buildCategoryItem(index);
        },
      ),
    );
  }

  Widget _buildCategoryItem(int index) {
    final isSelected = index == categoryIndex;
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(horizontal: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isSelected ? AppColors.mainItemColor : AppColors.backgroundColor,
        border: Border.all(color: AppColors.mainItemColor, width: 2),
      ),
      child: TextButton(
        onPressed: () {
          setState(() {
            categoryIndex = index;
            selectedProgramList = [];
            if (index != 0) {
              for (var program in programList ?? []) {
                if (categoryList?[categoryIndex - 1].title == program.category) {
                  selectedProgramList?.add(program);
                }
              }
            }
          });
        },
        child: Text(
          index == 0 ? "All" : categoryList?[index - 1].title.toString() ?? "",
          style: GoogleFonts.nunito(
            color: isSelected ? Colors.amber : AppColors.mainItemColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _programsSection() {
    final programs = categoryIndex == 0 ? programList : selectedProgramList;
    return programs != null
        ? ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: programs.length,
            itemBuilder: (context, index) {
              return _buildProgramItem(programs, index);
            },
          )
        : const Center();
  }

  Widget _buildProgramItem(List<dynamic>? programs, int index) {
    final program = programs?[index];
    return SecondTemplate(
      Id: program?.Id.toString() ?? "",
      title: program?.title.toString() ?? "",
      description: program?.description.toString() ?? "",
      value1: _calculateValue(program, 0),
      value2: _calculateValue(program, 1),
      value3: _calculateValue(program, 2),
      value4: _calculateValue(program, 3),
      value5: _calculateValue(program, 4),
    );
  }

  double _calculateValue(dynamic program, int index) {
    return double.parse(program?.sliceItems?[index].sliceValue.toString() ?? "0");
  }
}