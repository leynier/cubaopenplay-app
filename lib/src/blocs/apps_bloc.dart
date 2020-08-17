import 'dart:developer';
import 'dart:io';

import 'package:apklis_api/apklis_api.dart';
import 'package:apklis_api/models/apklis_item_model.dart';
import 'package:apklis_api/models/apklis_model.dart';
import 'package:app_review/app_review.dart';
import 'package:cubaopenplay/src/api/api.dart';
import 'package:cubaopenplay/src/repositories/repositories.dart';
import 'package:cubaopenplay/src/utils/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

class FetchAppsEvent {}

class RefreshAppsEvent extends FetchAppsEvent {}

abstract class AppsState {
  const AppsState();
}

class LoadingAppsState extends AppsState {}

class CorrectAppsState extends AppsState {
  final List<ApklisItemModel> data;

  const CorrectAppsState(this.data);
}

class ErrorAppsState extends AppsState {
  final String errorMessage;
  final ApklisModel cacheModel;

  const ErrorAppsState({@required this.errorMessage, this.cacheModel})
      : assert(errorMessage != null);
}

abstract class IAppsBloc extends Bloc<FetchAppsEvent, AppsState> {
  final IAppsRepository repository;

  IAppsBloc(
    AppsState initialState,
    this.repository,
  ) : super(initialState);
}

class AppsBloc extends IAppsBloc {
  AppsBloc(IAppsRepository repository) : super(LoadingAppsState(), repository);

  @override
  Stream<AppsState> mapEventToState(FetchAppsEvent event) async* {
    if (!(event is RefreshAppsEvent)) {
      yield LoadingAppsState();
    }
    try {
      var appsModel = await repository.getApps();
      var result = await ApklisApi().get(appsModel.apps);

      if (result.isOk) {
        result.result.results.sort((a, b) => a.name.compareTo(b.name));
        DataManager.cacheModel = result.result;
        AppReview.requestReview.then((value) => log('requestReview: $value'));
        yield CorrectAppsState(result.result.results);
      } else {
        throw Exception(result.error);
      }
    } on NetworkError catch (e) {
      log(e.toString());
      yield ErrorAppsState(
        errorMessage: Constants.networkErrorMessage,
        cacheModel: DataManager.cacheModel,
      );
    } on SocketException catch (e) {
      log(e.toString());
      yield ErrorAppsState(
        errorMessage: Constants.networkErrorMessage,
        cacheModel: DataManager.cacheModel,
      );
    } on ServerError catch (e) {
      log(e.toString());
      yield ErrorAppsState(
        errorMessage: Constants.serverErrorMessage,
        cacheModel: DataManager.cacheModel,
      );
    } catch (e) {
      log(e.toString());
      yield ErrorAppsState(
        errorMessage: e.toString(),
        cacheModel: DataManager.cacheModel,
      );
    }
  }
}
