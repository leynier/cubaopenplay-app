import 'package:cubaopenplay/src/api/api.dart';
import 'package:cubaopenplay/src/models/models.dart';
import 'package:http/http.dart' as http;

abstract class IAppsHashRepository {
  Future<AppsHashModel> getHash({http.Client client});
}

class AppsHashRepository extends IAppsHashRepository {
  @override
  Future<AppsHashModel> getHash({http.Client client}) {
    return Api.getHash(client: client);
  }
}
