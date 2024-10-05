import 'package:flutter_riverpod/flutter_riverpod.dart';

final newProgram_startTime = StateProvider<String>(
      (ref) => "00:00",
);
final newProgram_endTime = StateProvider<String>(
      (ref) => "00:00",
);
