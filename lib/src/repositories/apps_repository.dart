import 'package:cubaopenplay/src/api/api.dart';
import 'package:cubaopenplay/src/models/models.dart';
import 'package:cubaopenplay/src/repositories/repositories.dart';
import 'package:cubaopenplay/src/utils/utils.dart';
import 'package:http/http.dart' as http;

abstract class IAppsRepository {
  final IAppsHashRepository hashRepository;

  IAppsRepository(this.hashRepository);

  Future<AppsModel> getApps({http.Client client});
}

class AppsRepository extends IAppsRepository {
  AppsRepository(IAppsHashRepository hashRepository) : super(hashRepository);

  @override
  Future<AppsModel> getApps({http.Client client}) async {
    var hashModel = await hashRepository.getHash(client: client);
    if (DataManager.hashModel == null ||
        DataManager.hashModel.hash != hashModel.hash) {
      DataManager.appsModel = await Api.getApps(client: client);
      DataManager.hashModel = hashModel;
    }
    return DataManager.appsModel;
  }
}
