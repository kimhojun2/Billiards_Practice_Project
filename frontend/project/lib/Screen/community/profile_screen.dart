import 'package:flutter/material.dart';
import 'package:project/Screen/community/board_detail.dart';
import 'package:project/Screen/community/profile_update.dart';
import 'package:project/Screen/community/qna_detail.dart';
import 'package:project/Screen/home_screen.dart';
import 'package:project/component/drawer/drawing_tool.dart';
import 'package:project/data/ball_route.dart';
import 'package:project/data/board_manager.dart';
import 'package:project/data/qna_manager.dart';
import 'package:project/data/token_manger.dart';
import 'package:project/data/user_info_manager.dart';
import 'package:project/layout/community_layout.dart';

class ProfileScreen extends StatelessWidget {
  final int currentUser;
  final String currentUserId;

  const ProfileScreen({
    required this.currentUser,
    required this.currentUserId,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double phoneWidth = MediaQuery.of(context).size.width;
    double phoneHeight = MediaQuery.of(context).size.height;

    return CommunityLayout(
      bodyHead: (phoneWidth > phoneHeight)
          ? Padding(
              padding: EdgeInsets.only(left: phoneWidth * 0.03, right: phoneWidth * 0.03, top: phoneHeight * 0.02),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: SizedBox(
                        height: phoneHeight * 0.38,
                        child: Column(
                          children: [
                            const Text('내 프로필'),
                            const Divider(),
                            SizedBox(
                              height: phoneHeight * 0.015,
                            ),
                            _Profile(
                              currentuser: currentUser,
                              currentUserId: currentUserId,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: SizedBox(
                        height: phoneHeight * 0.38,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text('최근 플레이'),
                            const Divider(),
                            SizedBox(
                              height: phoneHeight * 0.015,
                            ),
                            _UserRoute(userId: currentUserId)
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : const Row(
              children: [
                Text(''),
              ],
            ),
      bodyCol: Padding(
        padding: EdgeInsets.only(left: phoneWidth * 0.03, right: phoneWidth * 0.03, top: phoneHeight * 0.02),
        child: Column(
          children: [
            if (MediaQuery.of(context).size.width > phoneHeight)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: SizedBox(
                        height: phoneHeight * 0.6,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text('작성한 글'),
                            const Divider(),
                            SizedBox(
                              height: phoneHeight * 0.015,
                            ),
                            _UserPost(userSeqId: currentUser),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const VerticalDivider(),
                  Expanded(
                    child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: SizedBox(
                          height: phoneHeight * 0.6,
                          child: Column(
                            children: [
                              const Text('작성한 질문'),
                              const Divider(),
                              SizedBox(
                                height: phoneHeight * 0.015,
                              ),
                              _UserQnaPost(userSeqId: currentUser),
                            ],
                          ),
                        )),
                  ),
                ],
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('내 프로필'),
                  const Divider(),
                  SizedBox(
                    height: phoneHeight * 0.015,
                  ),
                  _Profile(
                    currentuser: currentUser,
                    currentUserId: currentUserId,
                  ),
                  const Text('최근 경로'),
                  const Divider(),
                  SizedBox(
                    height: phoneHeight * 0.015,
                  ),
                  _UserRoute(userId: currentUserId),
                  const Text('작성한 글'),
                  const Divider(),
                  SizedBox(
                    height: phoneHeight * 0.015,
                  ),
                  _UserPost(userSeqId: currentUser),
                  const Text('작성한 질문'),
                  const Divider(),
                  SizedBox(
                    height: phoneHeight * 0.015,
                  ),
                  _UserQnaPost(userSeqId: currentUser),
                ],
              )
          ],
        ),
      ),
    );
  }
}

class _Profile extends StatelessWidget {
  final int currentuser;
  final String currentUserId;

  const _Profile({
    required this.currentuser,
    required this.currentUserId,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserInfo>(
      future: fetchUserInfo(currentUserId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // 로딩 중이면 로딩 표시
        } else if (snapshot.hasError) {
          return Text('123Error: ${snapshot.error}');
        } else {
          UserInfo userInfo = snapshot.data!;
          return Column(
            children: [
              Row(
                children: [
                  const Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Text('User ID: ${userInfo.userSeqId}'),
                        Text('ID'),
                        Text('Email'),
                        Text('닉네임'),
                        Text('핸디'),
                      ],
                    ),
                  ),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Text('User ID: ${userInfo.userSeqId}'),
                      Text(':  '),
                      Text(':  '),
                      Text(':  '),
                      Text(':  '),
                    ],
                  ),
                  Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${userInfo.id}'),
                          Text('${userInfo.email ?? ''}'),
                          Text('${userInfo.nickname ?? ''}'),
                          Text('${userInfo.handicap ?? ''}'),
                        ],
                      ))
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ProfileUpdate(
                            currentuser: currentuser,
                            currentUserId: currentUserId,
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      '프로필 수정',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      TokenManager.logout();
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      '로그아웃',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ],
          );
        }
      },
    );
  }
}

class _UserPost extends StatelessWidget {
  final int userSeqId;

  const _UserPost({required this.userSeqId, super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Board>>(
      future: fetchUserBoards(userSeqId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // 로딩 중이면 로딩 표시
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List<Board> posts = snapshot.data!;
          return ListView.builder(
            shrinkWrap: true,
            itemCount: posts.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(posts[index].title),
                  ],
                ),
                onTap: () {
                  // 제목을 클릭할 때 상세보기 페이지로 이동
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BoardDetail(board: posts[index]),
                    ),
                  );
                },
              );
            },
          );
        }
      },
    );
  }
}

class _UserQnaPost extends StatelessWidget {
  final int userSeqId;

  const _UserQnaPost({required this.userSeqId, super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Qna>>(
      future: fetchUserQnas(userSeqId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // 로딩 중이면 로딩 표시
        } else if (snapshot.hasError) {
          return Text('123Error: ${snapshot.error}');
        } else {
          List<Qna> qnaposts = snapshot.data!;
          return ListView.builder(
            shrinkWrap: true,
            itemCount: qnaposts.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(qnaposts[index].title),
                  ],
                ),
                onTap: () {
                  // 제목을 클릭할 때 상세보기 페이지로 이동
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QnaDetailPage(qna: qnaposts[index]),
                    ),
                  );
                },
              );
            },
          );
        }
      },
    );
  }
}

class _UserRoute extends StatelessWidget {
  final String userId;

  const _UserRoute({required this.userId, super.key});

  @override
  Widget build(BuildContext context) {
    double phoneHeight = MediaQuery.of(context).size.height;

    return FutureBuilder<List<BallRoute>?>(
      future: fetchUserRoute(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // 로딩 중이면 로딩 표시
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List<BallRoute>? balls = snapshot.data;
          if (balls != null) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: (balls.length / 2).ceil(),
              itemBuilder: (context, index) {
                if (balls.length % 2 == 1) {
                  return Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            ListTile(
                              title: Row(
                                children: [
                                  Center(
                                    child: SizedBox(
                                      height: phoneHeight * 0.1,
                                      child: DrawingTool(
                                        ballPositions:
                                            balls[index * 2].routeFile.positions,
                                        boardX: phoneHeight * 0.2,
                                        billiardInfo: balls[index * 2]
                                            .routeFile
                                            .billiardInfo,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }
                return Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          ListTile(
                            title: Row(
                              children: [
                                Center(
                                  child: SizedBox(
                                    height: phoneHeight * 0.1,
                                    child: DrawingTool(
                                      ballPositions:
                                          balls[index * 2].routeFile.positions,
                                      boardX: phoneHeight * 0.2,
                                      billiardInfo:
                                          balls[index * 2].routeFile.billiardInfo,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          ListTile(
                            title: Row(
                              children: [
                                Center(
                                  child: SizedBox(
                                    height: phoneHeight * 0.1,
                                    child: DrawingTool(
                                      ballPositions: balls[index * 2 + 1]
                                          .routeFile
                                          .positions,
                                      boardX: phoneHeight * 0.2,
                                      billiardInfo: balls[index * 2 + 1]
                                          .routeFile
                                          .billiardInfo,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          } else {
            return const Text('플레이 기록이 없습니다.');
          }
        }
      },
    );
  }
}
