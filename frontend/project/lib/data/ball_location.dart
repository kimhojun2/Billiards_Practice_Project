import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:project/data/server_url.dart';
import 'package:intl/intl.dart';
//
// Future<List<BallLocation>> fetchBallList() async {
//   final response = await http.get(Uri.parse('${Url.apiUrl}boards/boardlist/'));
//   if (response.statusCode == 200) {
//     List<dynamic> data = json.decode(response.body);
//     // print(response.body);
//     List<BallLocation> ballLocations = data
//         .where((item) => item != null) // null 체크 추가
//         .map((item) => BallLocation.fromJson(item))
//         .toList();
//     // print(ballLocations);
//     return ballLocations;
//   } else {
//     throw Exception('Failed to load boards');
//   }
// }

Future<BallLocation> fetchQuizLoca(int ballSeq) async {
  final response =
      await http.get(Uri.parse('${Url.apiUrl}balls/quiz/${ballSeq}'));
  if (response.statusCode == 200) {
    dynamic data = json.decode(response.body);
    // print(response.body);
    BallLocation ball = BallLocation.fromJson(data);
    // print('여기로 와야됨: ${ball.locaFile.positions.white}');
    return ball;
  } else {
    throw Exception('Failed to load boards');
  }
}

Future<BallLocation> fetchBall(int ballSeq) async {
  final response =
  await http.get(Uri.parse('${Url.apiUrl}balls/location/${ballSeq}'));
  if (response.statusCode == 200) {
    dynamic data = json.decode(response.body);
    // print(response.body);
    BallLocation ball = BallLocation.fromJson(data);
    // print('여기로 와야됨: ${ball.locaFile.positions.white}');
    return ball;
  } else {
    throw Exception('Failed to load balls');
  }
}

class BallLocation {
  final int locaSeq;
  final DateTime createdAt;
  final bool isQuiz;
  final LocaFile locaFile;

  BallLocation({
    required this.locaSeq,
    required this.createdAt,
    required this.isQuiz,
    required this.locaFile,
  });
  factory BallLocation.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      throw Exception('Invalid JSON data');
    }

    String dateString = json['created_at'];
    String replacedString = dateString.replaceAll(RegExp(r'\+\d{2}:\d{2}$'), '');
    // print('original $dateString');
    // print('replace $replacedString');
    DateTime parsedDateTime = DateFormat("yyyy-MM-ddTHH:mm:ss").parse(replacedString);
    // print('parse: ${parsedDateTime.toString()}');
    DateTime koreanDateTime = parsedDateTime.add(Duration(hours: 9));

    return BallLocation(
      locaSeq: json['id'],
      createdAt: koreanDateTime,
      isQuiz: json['is_quiz'],
      locaFile: LocaFile.fromJson(json['loca_file']),
    );
  }
}

class LocaFile {
  // final String? deviceInfo;
  // final String? unixTime;
  final int? numOfFrames;
  final double? samplingRate;
  final BilliardInfo billiardInfo;
  final Positions positions;

  LocaFile({
    // required this.deviceInfo,
    // required this.unixTime,
    required this.numOfFrames,
    required this.samplingRate,
    required this.billiardInfo,
    required this.positions,
  });
  factory LocaFile.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      throw Exception('Invalid JSON data');
    }
    return LocaFile(
      // deviceInfo: json['device_info'],
      // unixTime: json['unix_time'],
      numOfFrames: json['num_of_frames'],
      samplingRate: json['sampling_rate'],
      billiardInfo: BilliardInfo.fromJson(json['billiard_info']),
      positions: Positions.fromJson(json['positions']),
    );
  }
}

class BilliardInfo {
  double boardY;
  double boardX;
  double ballDiameter;

  BilliardInfo({
    required this.boardY,
    required this.boardX,
    required this.ballDiameter,
  });

  factory BilliardInfo.fromJson(Map<String, dynamic> json) {
    return BilliardInfo(
      boardY: json['board_y'].toDouble(),
      boardX: json['board_x'].toDouble(),
      ballDiameter: json['ball_diameter'].toDouble(),
    );
  }
}

class Positions {
  List<List<double>> white;
  List<List<double>> yellow;
  List<List<double>> red;

  Positions({
    required this.white,
    required this.yellow,
    required this.red,
  });

  factory Positions.fromJson(Map<String, dynamic> json) {
    return Positions(
      white: List<List<double>>.from(json['white'].map((entry) =>
          List<double>.from(entry.map((value) => value.toDouble())))),
      yellow: List<List<double>>.from(json['yellow'].map((entry) =>
          List<double>.from(entry.map((value) => value.toDouble())))),
      red: List<List<double>>.from(json['red'].map((entry) =>
          List<double>.from(entry.map((value) => value.toDouble())))),
    );
  }
}
