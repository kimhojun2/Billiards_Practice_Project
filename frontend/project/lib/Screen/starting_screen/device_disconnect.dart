import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project/Screen/home_screen.dart';
import 'package:project/data/device_manger.dart';
import 'package:project/data/server_url.dart';
import 'package:project/layout/starting_layout.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeviceDisconnect extends StatefulWidget {
  const DeviceDisconnect({super.key});

  @override
  State<DeviceDisconnect> createState() => _DeviceDisconnectState();
}

class _DeviceDisconnectState extends State<DeviceDisconnect> {
  TextEditingController _SerialNumController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // double phoneWidth = MediaQuery.of(context).size.width;
    double phoneHeight = MediaQuery.of(context).size.height;

    return StartingLayout(
      startBody: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: phoneHeight * 0.04),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25.0),
            ),
            child: Padding(
              padding: EdgeInsets.all(phoneHeight * 0.02),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '기기분리',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize:  phoneHeight * 0.03,
                      color: Colors.red,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: phoneHeight * 0.03),
                  Text('연결된 기기의 시리얼번호를 입력하세요.\n'
                      '기기와의 연결이 해제됩니다.'),
                  SizedBox(height: phoneHeight * 0.03),
                  TextField(
                    controller: _SerialNumController,
                    decoration: InputDecoration(labelText: '기기번호'),
                  ),
                  SizedBox(height: phoneHeight * 0.03),
                  ElevatedButton(
                    // onPressed: () {
                    //   Navigator.of(context).push(
                    //     MaterialPageRoute(
                    //       builder: (BuildContext context) => GameHome(),
                    //     ),
                    //   );
                    // },
                    // 백엔드랑 기기번호 연동되면 위에꺼 주석하고 밑에꺼 사용
                    onPressed: _SerialNumDisconnect,
                    child: Text('연결 해제'),
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  '취소',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: phoneHeight * 0.025,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _SerialNumDisconnect() async {
    final String apiUrl = '${Url.apiUrl}devices/check/';
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        'serial_num': _SerialNumController.text,
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      // print(response.body);
      // print(data);
      final int deviceSerial = data['serial_num'];

      final String? loadedDevice = await DeviceManager.loadDevice();

      if (loadedDevice == deviceSerial.toString()) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
        DeviceManager.clearDevice();
        print('연결해제 성공');
      } else {
        _WrongSerial(context);
      }
    } else {
      // 로그인 실패
      print('연결끊기실패: ${response.body}');
      _showFailer(context);
    }
  }

  Future<void> _showFailer(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('연결 해제 실패'),
          content: Text('기기번호가 잘못되었거나 인터넷 연결이 불안정합니다.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 모달 닫기
              },
              child: Text('닫기'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _WrongSerial(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('연결 해제 실패'),
          content: Text('등록된 기기번호와 다릅니다.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 모달 닫기
              },
              child: Text('닫기'),
            ),
          ],
        );
      },
    );
  }
}
