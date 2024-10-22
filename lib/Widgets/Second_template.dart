import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/AppColor.dart';

class SecondTemplate extends StatefulWidget {
  SecondTemplate({
    super.key,
    required this.Id,
    required this.title,
    required this.description,
    required this.value1,
    required this.value2,
    required this.value3,
    required this.value4,
    required this.value5,
  });

  String Id;
  String title;
  String description;
  double value1;
  double value2;
  double value3;
  double value4;
  double value5;

  @override
  State<SecondTemplate> createState() => _SecondTemplateState();
}

class _SecondTemplateState extends State<SecondTemplate> {
  int touchedIndex = -1;
  List angles = [0.0, 10.0, 20.0, 30.0, 45.0, 55.0, 70.0, 90.0, 140.0, 170.0];
  late double randomItem;

  @override
  Widget build(BuildContext context) {
    // randomItem = angles[Random().nextInt(angles.length)];
    randomItem = 45.0;
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        context.pushNamed('detail', queryParameters: {
          'Id': widget.Id,
        });
      },
      child: SizedBox(
          height: 140,
          width: size.width,
          child: Stack(
            children: [
              Positioned(
                right: 70,
                top: 10,
                bottom: 10,
                left: 10,
                child: Container(
                  height: 200,
                  width: size.width,
                  decoration: BoxDecoration(
                      boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 10)],
                      borderRadius: BorderRadius.circular(14),
                      color: AppColors.mainItemColor),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Container(
                          margin: const EdgeInsets.only(right: 40),
                          child: Text(
                            widget.title,
                            style: GoogleFonts.nunito(
                                fontWeight: FontWeight.w700, fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        margin: const EdgeInsets.only(right: 50, top: 5),
                        child: Text(
                          widget.description,
                          textAlign: TextAlign.justify,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          style: GoogleFonts.nunito(
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: Colors.grey.shade300),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                right: 8,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 110,
                  height: 110,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.mainItemColor,
                      boxShadow: [BoxShadow(color: Colors.white, blurRadius: 3)]),
                  child: PieChart(
                    PieChartData(
                      startDegreeOffset: randomItem,
                      sectionsSpace: 3,
                      centerSpaceRadius: 0,
                      sections: showingSections(),
                    ),
                  ),
                ),
              )
            ],
          )),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(
      5,
      (i) {
        final isTouched = i == touchedIndex;
        switch (i) {
          case 0:
            return PieChartSectionData(
              color: AppColors.pieColor1,
              value: widget.value1,
              title: '',
              radius: 55,
              titlePositionPercentageOffset: 0.55,
              borderSide: isTouched
                  ? const BorderSide(color: AppColors.contentColorWhite, width: 6)
                  : BorderSide(color: AppColors.contentColorWhite.withOpacity(0)),
            );
          case 1:
            return PieChartSectionData(
              color: AppColors.pieColor2,
              value: widget.value2,
              title: '',
              radius: 55,
              titlePositionPercentageOffset: 0.55,
              borderSide: isTouched
                  ? const BorderSide(color: AppColors.contentColorWhite, width: 6)
                  : BorderSide(color: AppColors.contentColorWhite.withOpacity(0)),
            );
          case 2:
            return PieChartSectionData(
              color: AppColors.pieColor3,
              value: widget.value3,
              title: '',
              radius: 55,
              titlePositionPercentageOffset: 0.6,
              borderSide: isTouched
                  ? const BorderSide(color: AppColors.contentColorWhite, width: 6)
                  : BorderSide(color: AppColors.contentColorWhite.withOpacity(0)),
            );
          case 3:
            return PieChartSectionData(
              color: AppColors.pieColor4,
              value: widget.value4,
              title: '',
              radius: 55,
              titlePositionPercentageOffset: 0.6,
              borderSide: isTouched
                  ? const BorderSide(color: AppColors.contentColorWhite, width: 6)
                  : BorderSide(color: AppColors.contentColorWhite.withOpacity(0)),
            );
          case 4:
            return PieChartSectionData(
              color: AppColors.pieColor5,
              value: widget.value5,
              title: '',
              radius: 55,
              titlePositionPercentageOffset: 0.6,
              borderSide: isTouched
                  ? const BorderSide(color: AppColors.contentColorWhite, width: 6)
                  : BorderSide(color: AppColors.contentColorWhite.withOpacity(0)),
            );

          default:
            throw Error();
        }
      },
    );
  }
}
