import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:project/data/ball_location.dart';
import 'package:project/data/server_url.dart';

Future<BallRoute> fetchQuiz(int ballSeq) async {
  final response =
      await http.get(Uri.parse('${Url.apiUrl}balls/quiz_ans/${ballSeq}'));
  if (response.statusCode == 200) {
    dynamic data = json.decode(response.body);
    // print(response.body);
    BallRoute ball = BallRoute.fromJson(data);
    // print('여기로 와야됨: ${ball.routeFile.positions.white}');
    return ball;
  } else {
    throw Exception('Failed to load routes');
  }
}

Future<BallRoute> fetchRoute(int ballSeq) async {
  final response =
  await http.get(Uri.parse('${Url.apiUrl}balls/ballroute/${ballSeq}'));
  if (response.statusCode == 200) {
    dynamic data = json.decode(response.body);
    // print(response.body);
    BallRoute ball = BallRoute.fromJson(data);
    // print('여기로 와야됨: ${ball.routeFile.positions.white}');
    return ball;
  } else {
    throw Exception('Failed to load routes');
  }
}

Future<List<BallRoute>> fetchRecentRoute(int deviceSeq) async {
  final response =
      await http.get(Uri.parse('${Url.apiUrl}devices/${deviceSeq}/history/'));
  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    // print(response.body);
    List<BallRoute> ball = data
        .where((item) => item != null) // null 체크 추가
        .map((item) => BallRoute.fromJson(item))
        .toList();
    // print('여기로 와야됨: ${ball[0].routeFile.positions.white}');
    return ball;
  } else {
    throw Exception('Failed to load routes');
  }
}

Future<List<BallRoute>> fetchUserRoute(String username) async {
  final response =
  await http.get(Uri.parse('${Url.apiUrl}balls/myhistory/${username}/'));
  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    // print(response.body);
    List<BallRoute> ball = data
        .where((item) => item != null) // null 체크 추가
        .map((item) => BallRoute.fromJson(item))
        .toList();
    // print('여기로 와야됨: ${ball.routeFile.positions.white}');
    return ball;
  } else {
    // print(response.statusCode);
    throw Exception('Failed to load routes');
  }
}

class BallRoute {
  final int routeSeq;
  final int locaSeq;
  final int userSeq;
  // final int deviceSeq;
  final DateTime createdAt;
  final RouteFile routeFile;

  BallRoute({
    required this.routeSeq,
    required this.locaSeq,
    required this.userSeq,
    // required this.deviceSeq,
    required this.createdAt,
    required this.routeFile,
  });
  factory BallRoute.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      throw Exception('Invalid JSON data');
    }

    String dateString = json['created_at'];
    String replacedString = dateString.replaceAll(RegExp(r'\+\d{2}:\d{2}$'), '');
    DateTime parsedDateTime = DateFormat("yyyy-MM-ddTHH:mm:ss").parse(replacedString);
    DateTime koreanDateTime = parsedDateTime.add(Duration(hours: 9));

    return BallRoute(
      routeSeq: json['id'],
      locaSeq: json['loca_seq'],
      userSeq: json['user_seq'],
      // deviceSeq: json['device_seq'],
      createdAt: koreanDateTime,
      routeFile: RouteFile.fromJson(json['route_file']),
    );
  }
}

class RouteFile {
  // final String? deviceInfo;
  // final String? unixTime;
  final int? numOfFrames;
  final double? samplingRate;
  final BilliardInfo billiardInfo;
  final Positions positions;

  RouteFile({
    // required this.deviceInfo,
    // required this.unixTime,
    required this.numOfFrames,
    required this.samplingRate,
    required this.billiardInfo,
    required this.positions,
  });
  factory RouteFile.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      throw Exception('Invalid JSON data');
    }
    return RouteFile(
      // deviceInfo: json['device_info'],
      // unixTime: json['unix_time'],
      numOfFrames: json['num_of_frames'],
      samplingRate: json['sampling_rate'],
      billiardInfo: BilliardInfo.fromJson(json['billiard_info']),
      positions: Positions.fromJson(json['positions']),
    );
  }
}
