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
  runApp(App());
}

class SimpleBlocObserver extends BlocObserver {
  @override
  onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    log(transition.toString());
  }
}
