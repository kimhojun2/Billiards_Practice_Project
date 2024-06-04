import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:project/data/device_manger.dart';
import 'package:project/data/server_url.dart';
import 'package:project/data/token_manger.dart';

Future<void> SetDeviceState(String state) async {
  final String apiUrl = '${Url.apiUrl}balls/connection/';
  final String? deviceNum = await DeviceManager.loadDevice();
  final String? token = await TokenManager.loadToken();

  final response = await http.post(
    Uri.parse(apiUrl),
    headers: {'Authorization': 'Token $token'},
    body: {
      'device_num' : deviceNum,
      'sign' : state
    },
  );

  if (response.statusCode == 200) {
    // print(response);
  }
}

Future<void> SetDeviceLocation(String locaSeq) async {
  final String apiUrl = '${Url.apiUrl}balls/connection/';
  final String? deviceNum = await DeviceManager.loadDevice();
  final String? token = await TokenManager.loadToken();

  final response = await http.post(
    Uri.parse(apiUrl),
    headers: {'Authorization': 'Token $token'},
    body: {
      'device_num' : deviceNum,
      'loca_seq' : locaSeq
    },
  );
}

Future<void> SetDeviceRoute(String routeSeq) async {
  final String apiUrl = '${Url.apiUrl}balls/connection/';
  final String? deviceNum = await DeviceManager.loadDevice();
  final String? token = await TokenManager.loadToken();

  final response = await http.post(
    Uri.parse(apiUrl),
    headers: {'Authorization': 'Token $token'},
    body: {
      'device_num' : deviceNum,
      'route_seq' : routeSeq
    },
  );
}