import 'dart:developer';

import 'package:cubaopenplay/src/api/api.dart';
import 'package:cubaopenplay/src/app.dart';
import 'package:cubaopenplay/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = SimpleBlocObserver();
  await DataManager.init();
  Api.init();
  setupDependencies();
  var showDialogToDonate = getShowDialogToDonate();
  runApp(App(showDialogToDonate));
}

bool getShowDialogToDonate() {
  ++DataManager.count;
  return [5, 50, 100, 200, 350, 500]
      .where((x) => x == DataManager.count)
      .isNotEmpty;
}

class SimpleBlocObserver extends BlocObserver {
  @override
  onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    log(transition.toString());
  }
}
