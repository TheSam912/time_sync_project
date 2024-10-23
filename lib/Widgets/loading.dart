import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

Widget TimeSyncLoading() => Center(
    child: SizedBox(
      child: Lottie.asset("assets/lottie/loading.json", width: 150, height: 150),
    ),
  );
