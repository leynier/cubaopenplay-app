import 'package:cubaopenplay/src/api/exceptions.dart';
import 'package:cubaopenplay/src/api/request.dart';
import 'package:cubaopenplay/src/api/utils.dart';
import 'package:cubaopenplay/src/models/models.dart';
import 'package:http/http.dart' as http;

export 'definitions.dart';
export 'exceptions.dart';
export 'request.dart';
export 'utils.dart';

class Api {
  static void init() {
    var authority = 'cubaopenplay.github.io';
    var headers = {
      'Accept-Encoding': 'gzip, deflate, br',
    };
    var processResponseMethod = (http.Response response) async {
      if (response.statusCode == 0 ||
          response.statusCode == 407 ||
          response.statusCode == 408) {
        throw NetworkError('NetworkError: ${response.statusCode}.\n'
            'Response: ${response.toString()}');
      } else if (response.statusCode != 200) {
        throw ServerError('ServerError: ${response.statusCode}.\n'
            'Response: ${response.toString()}');
      }
    };
    Request.init(authority, headers, processResponseMethod);
  }

  static Future<AppsModel> getApps({http.Client client}) async {
    var data = await Request.get(
      'api/apps.json',
      client: client,
    );
    var parser = () => parseItem<AppsModel>(data.body, AppsModel.fromJson);
    var result = await tryParse(parser);
    return result;
  }

  static Future<AppsHashModel> getHash({http.Client client}) async {
    var data = await Request.get(
      'api/apps_hash.json',
      client: client,
    );
    var parser = () => parseItem<AppsHashModel>(
          data.body,
          AppsHashModel.fromJson,
        );
    var result = await tryParse(parser);
    return result;
  }
}
