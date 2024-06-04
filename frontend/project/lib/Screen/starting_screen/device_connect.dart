import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project/Screen/game/game_home.dart';
import 'package:project/data/device_manger.dart';
import 'package:project/data/server_url.dart';
import 'package:project/layout/starting_layout.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeviceConnect extends StatefulWidget {
  const DeviceConnect({super.key});

  @override
  State<DeviceConnect> createState() => _DeviceConnectState();
}

class _DeviceConnectState extends State<DeviceConnect> {
  TextEditingController _SerialNumController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double phoneWidth = MediaQuery.of(context).size.width;
    double phoneHeight = MediaQuery.of(context).size.height;

    return StartingLayout(
      startBody: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: phoneWidth * 0.04, vertical: phoneHeight * 0.02),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: phoneHeight * 0.02,),
                Text(
                  '기기연결',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: phoneHeight * 0.04, fontFamily: 'godo'),
                ),
                SizedBox(height: phoneHeight * 0.02,),
                const Text(
                  '\n1. 기기 뒤편의 시리얼번호를 확인하세요.\n'
                  '2. 기기와 앱을 와이파이에 연결해주세요.\n'
                  '3. 시리얼 번호를 입력하고 \'Connect\'버튼을 누르세요.\n',
                  style: TextStyle(fontFamily: 'godo'),
                ),
                const Text(
                  '* 주의 *',
                  style: TextStyle(fontFamily: 'godo'),
                  textAlign: TextAlign.center,
                ),
                Text(
                  '* 기기와 와이파이가 연결된 상태를 유지해주세요.\n'
                  '* 시리얼 번호는 주의하여 보관해주세요.\n'
                  '* 시리얼 번호가 외부에 노출되지 않도록 관리해주세요.',
                  style: TextStyle(
                    fontSize: phoneHeight * 0.016,
                    fontFamily: 'godo',
                  ),
                ),
                SizedBox(height: phoneHeight * 0.02),
                TextField(
                  controller: _SerialNumController,
                  decoration: const InputDecoration(labelText: '기기번호'),
                ),
                SizedBox(height: phoneHeight * 0.02),
                ElevatedButton(
                  // onPressed: () {
                  //   Navigator.of(context).push(
                  //     MaterialPageRoute(
                  //       builder: (BuildContext context) => GameHome(),
                  //     ),
                  //   );
                  // },
                  // 백엔드랑 기기번호 연동되면 위에꺼 주석하고 밑에꺼 사용
                  onPressed: _SerialNumConnect,
                  child: const Text(
                    '기기연결',
                    style: TextStyle(fontFamily: 'godo'),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: phoneHeight * 0.03),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  '뒤로가기',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: phoneHeight * 0.025,
                    fontFamily: 'godo',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _SerialNumConnect() async {
    final String apiUrl = '${Url.apiUrl}devices/check/';
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        'serial_num': _SerialNumController.text,
      },
    );

    if (response.statusCode == 200) {
      // 로그인 성공
      print('기기 연결 성공');

      final Map<String, dynamic> data = json.decode(response.body);
      // print(response.body);
      // print(data);
      final int deviceSerial = data['serial_num'];

      // print(deviceSerial);

      await _saveDevice(deviceSerial);
      final String? loadedDevice = await DeviceManager.loadDevice();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const GameHome()),
      );
    } else {
      // 로그인 실패
      print('로그인 실패: ${response.body}');
      _showFailer(context);
    }
  }

  Future<void> _saveDevice(int deviceSeq) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('serial_num', deviceSeq.toString());
      print('기기가 성공적으로 등록되었습니다');
    } catch (e) {
      print('기기번호 저장 중 오류 발생: $e');
    }
  }

  Future<void> _showFailer(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            '연결 실패',
            style: TextStyle(fontFamily: 'godo'),
          ),
          content: const Text(
            '기기번호가 잘못되었습니다.',
            style: TextStyle(fontFamily: 'godo'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 모달 닫기
              },
              child: const Text(
                '닫기',
                style: TextStyle(fontFamily: 'godo'),
              ),
            ),
          ],
        );
      },
    );
  }
}
