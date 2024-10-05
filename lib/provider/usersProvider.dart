import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/ProgramModel.dart';

import '../model/UserModel.dart';

final userInformation = StateProvider<UserModel>(
  (ref) => UserModel(),
);

final userProgramProvider = StateProvider<ProgramModel>(
      (ref) => ProgramModel(),
);

final updateUserProgramProvider = StateProvider<ProgramModel>(
      (ref) => ProgramModel(),
);

