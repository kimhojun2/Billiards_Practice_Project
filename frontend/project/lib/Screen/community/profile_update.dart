import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:project/Screen/community/profile_screen.dart';
import 'package:project/data/server_url.dart';
import 'package:project/data/token_manger.dart';
import 'package:project/layout/community_layout.dart';
import 'package:http/http.dart' as http;

class ProfileUpdate extends StatefulWidget {
  final int currentuser;
  final String currentUserId;

  ProfileUpdate({
    required this.currentuser,
    required this.currentUserId,
  });

  @override
  _ProfileUpdateState createState() => _ProfileUpdateState();
}

class _ProfileUpdateState extends State<ProfileUpdate> {
  TextEditingController _nicknameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _handicapController = TextEditingController();

  @override
  void initState() {
    _fetchUserInfoData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double phoneWidth = MediaQuery.of(context).size.width;
    double phoneHeight = MediaQuery.of(context).size.height;

    return CommunityLayout(
      bodyHead: SizedBox(height: phoneHeight * 0.15,
      child: const Row(
        children: [
          Text(''),
        ],
      ),),
      bodyCol: Center(
        child: Container(
          width: MediaQuery.of(context).size.width > 400 ? 400 : MediaQuery.of(context).size.width * 0.9,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.black87)
          ),
          child: Column(
            children: [
              Text('프로필 수정', style: TextStyle(fontSize: phoneHeight * 0.042, fontFamily: 'godo'),),
              const Divider(),
              TextFormField(
                controller: _nicknameController,
                decoration: const InputDecoration(labelText: '닉네임'),
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextFormField(
                controller: _handicapController,
                decoration: const InputDecoration(labelText: '핸디'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _saveChanges(widget.currentuser, widget.currentUserId);
                  Navigator.pop(context);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ProfileScreen(
                        currentUser: widget.currentuser,
                        currentUserId: widget.currentUserId,
                      )));
                },
                child: const Text('프로필 수정', style: TextStyle(color: Colors.black),),
              ),
              ElevatedButton(
                onPressed: () {
                  _resign();
                },
                child: const Text('회원 탈퇴', style: TextStyle(color: Colors.black),),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _fetchUserInfoData() async {
    final String apiUrl = '${Url.apiUrl}';
    final http.Response response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> userData = jsonDecode(response.body);
      _nicknameController.text = userData['nickname'];
      _emailController.text = userData['email'];
      _handicapController = userData['handicap'];
    } else {
      print('Failed to fetch post data. Status code: ${response.statusCode}');
    }
  }

  Future<void> _saveChanges(int currentuser, String currentUserId) async {
    final String newNickname = _nicknameController.text;
    final String newEmail = _emailController.text;
    final int newHandicap = int.tryParse(_handicapController.text) ?? 0;

    final String? token = await TokenManager.loadToken();

    if (token != null) {
      final Map<String, String> headers = {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json',
      };

      final Map<String, dynamic> requestBody = {
        'user_seq_id': currentuser,
        'nickname': newNickname,
        'email': newEmail,
        'handicap': newHandicap,
      };

      final response = await http.put(
        Uri.parse('${Url.apiUrl}accounts/profile/${currentUserId}/'),
        headers: headers,
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        print('Profile updated successfully');
      } else {
        print('Failed to update profile. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } else {
      print('Token is not available. User may not be authenticated.');
    }
  }

  Future<void> _resign() async {
    final String apiUrl = '${Url.apiUrl}accounts/resign/';

    String? token = await TokenManager.loadToken();

    if (token != null) {
      try {
        await http.post(
          Uri.parse(apiUrl),
          headers: {'Authorization': 'Token $token'},
        );
      } catch (e) {
        print('Error during logout request: $e');
      }
    }
  }
}
