import 'dart:convert';

import '../res/apis.dart';
import '../res/app_strings.dart';
import 'package:http/http.dart' as http;

import '../utills/app_utils.dart';

class AppRepository {


  Future<http.Response> getRequest( String apiUrl) async {
    AppUtils().debuglog(apiUrl);

    final response = await http.get(
      Uri.parse(apiUrl),
    );
    AppUtils().debuglog(apiUrl+response.statusCode.toString());
    AppUtils().debuglog(response.body);

    return response;
  }

}
