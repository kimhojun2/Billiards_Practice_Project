import 'package:flutter/material.dart';
import 'package:project/Screen/community/qna_detail.dart';
import 'package:project/component/drawer/qna_drawing.dart';
import 'package:project/data/ball_location.dart';
import 'package:project/data/qna_manager.dart';
import 'package:project/layout/community_layout.dart';

class QnaScreen extends StatelessWidget {
  const QnaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double phoneWidth = MediaQuery.of(context).size.width;
    double phoneHeight = MediaQuery.of(context).size.height;

    return CommunityLayout(
      bodyHead: Padding(
        padding: EdgeInsets.symmetric(horizontal: phoneWidth * 0.02),
        child: MediaQuery.of(context).size.width > phoneHeight
            ? const _DoubleHeader()
            : const _SingleHeader(),
      ),
      bodyCol: Padding(
          padding: EdgeInsets.symmetric(horizontal: phoneWidth * 0.03),
          child: MediaQuery.of(context).size.width > phoneHeight
              ? const _DoubleBody()
              : const _SingleBody()),
    );
  }
}

class _SingleHeader extends StatelessWidget {
  const _SingleHeader({super.key});

  @override
  Widget build(BuildContext context) {
    double phoneWidth = MediaQuery.of(context).size.width;
    double phoneHeight = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
              left: phoneWidth * 0.025, top: phoneHeight * 0.02),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '질문게시판',
                style: TextStyle(
                    fontSize: phoneHeight * 0.03, fontWeight: FontWeight.w700),
              ),
              const Text('')
            ],
          ),
        ),
        SizedBox(
          height: phoneHeight * 0.04,
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('질문'),
            Text('|'),
            Text('미리보기'),
          ],
        ),
        const Divider(),
      ],
    );
  }
}

class _DoubleHeader extends StatelessWidget {
  const _DoubleHeader({super.key});

  @override
  Widget build(BuildContext context) {
    double phoneHeight = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
              left: phoneHeight * 0.03, top: phoneHeight * 0.02),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '질문게시판',
                style: TextStyle(
                    fontSize: phoneHeight * 0.03, fontWeight: FontWeight.w700),
              ),
              const Text('')
            ],
          ),
        ),
        SizedBox(
          height: phoneHeight * 0.04,
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('질문'),
            Text('|'),
            Text('미리보기'),
            Text('|'),
            Text('질문'),
            Text('|'),
            Text('미리보기'),
          ],
        ),
        const Divider(),
      ],
    );
  }
}

class _SingleBody extends StatelessWidget {
  const _SingleBody({super.key});

  @override
  Widget build(BuildContext context) {
    double phoneHeight = MediaQuery.of(context).size.height;
    return FutureBuilder<List<Qna>>(
      future: fetchQnas(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator()); // 로딩 중이면 로딩 표시
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List<Qna> qnas = snapshot.data!;
          return ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: qnas.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(qnas[index].title),
                              _TimeFormat(qna: qnas[index]),
                            ],
                          ),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    qnas[index].nickName != null
                                        ? Text('작성자: ${qnas[index].nickName}')
                                        : Text('작성자: ${qnas[index].username}'),
                                    // Text('작성자: ${qnas[index].username}'),
                                    SizedBox(
                                      height: phoneHeight * 0.015,
                                    ),
                                    qnas[index].content.length > 15
                                        ? Text(
                                            '${qnas[index].content.substring(0, 15)}...')
                                        : Text(qnas[index].content.substring(
                                            0, qnas[index].content.length)),
                                  ],
                                ),
                              ),
                              const VerticalDivider(),
                              FutureBuilder(
                                future: fetchBall(qnas[index].locaSeq),
                                builder: (context, ballSnapshot) {
                                  if (ballSnapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const CircularProgressIndicator(); // 로딩 중이면 로딩 표시
                                  } else if (ballSnapshot.hasError) {
                                    return Text('Error: ${ballSnapshot.error}');
                                  } else {
                                    BallLocation ball = ballSnapshot.data!;
                                    return SizedBox(
                                      height: phoneHeight * 0.11,
                                      child: QnaDrawing(
                                        ballPositions: ball.locaFile.positions,
                                        boardX: phoneHeight * 0.20,
                                        billiardInfo:
                                            ball.locaFile.billiardInfo,
                                      ),
                                    );
                                  }
                                },
                              ),
                              SizedBox(
                                width: phoneHeight * 0.01,
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    QnaDetailPage(qna: qnas[index]),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                ],
              );
            },
          );
        }
      },
    );
  }
}

class _DoubleBody extends StatelessWidget {
  const _DoubleBody({super.key});

  @override
  Widget build(BuildContext context) {
    double phoneHeight = MediaQuery.of(context).size.height;
    return FutureBuilder<List<Qna>>(
      future: fetchQnas(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator()); // 로딩 중이면 로딩 표시
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List<Qna> qnas = snapshot.data!;
          int qnaleng = (qnas.length / 2).ceil();
          return ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: qnaleng,
            itemBuilder: (context, index) {
              // if (qnas.length % 2 == 1) {
              //   return Row(
              //     children: [
              //       Expanded(
              //         child: Column(
              //           children: [
              //             ListTile(
              //               title: Row(
              //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //                 children: [
              //                   Text(qnas[index * 2].title),
              //                   _TimeFormat(qna: qnas[index * 2]),
              //                 ],
              //               ),
              //               subtitle: Row(
              //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //                 crossAxisAlignment: CrossAxisAlignment.start,
              //                 children: [
              //                   Expanded(
              //                     child: Column(
              //                       crossAxisAlignment:
              //                           CrossAxisAlignment.stretch,
              //                       children: [
              //                         Text('작성자: ${qnas[index * 2].username}'),
              //                         SizedBox(
              //                           height: phoneHeight * 0.015,
              //                         ),
              //                         qnas[index * 2].content.length > 15
              //                             ? Text(
              //                                 '${qnas[index * 2].content.substring(0, 15)}...')
              //                             : Text(qnas[index * 2]
              //                                 .content
              //                                 .substring(
              //                                     0,
              //                                     qnas[index * 2]
              //                                         .content
              //                                         .length)),
              //                       ],
              //                     ),
              //                   ),
              //                   const VerticalDivider(),
              //                   FutureBuilder(
              //                     future: fetchBall(qnas[index * 2].locaSeq),
              //                     builder: (context, ballSnapshot) {
              //                       if (ballSnapshot.connectionState ==
              //                           ConnectionState.waiting) {
              //                         return const CircularProgressIndicator(); // 로딩 중이면 로딩 표시
              //                       } else if (ballSnapshot.hasError) {
              //                         return Text(
              //                             'Error: ${ballSnapshot.error}');
              //                       } else {
              //                         BallLocation ball = ballSnapshot.data!;
              //                         return SizedBox(
              //                           // height: 80,
              //                           height: phoneHeight * 0.11,
              //                           child: QnaDrawing(
              //                             ballPositions:
              //                                 ball.locaFile.positions,
              //                             boardX: phoneHeight * 0.20,
              //                             billiardInfo:
              //                                 ball.locaFile.billiardInfo,
              //                           ),
              //                         );
              //                       }
              //                     },
              //                   ),
              //                   SizedBox(
              //                     width: phoneHeight * 0.01,
              //                   ),
              //                 ],
              //               ),
              //               onTap: () {
              //                 Navigator.push(
              //                   context,
              //                   MaterialPageRoute(
              //                     builder: (context) =>
              //                         QnaDetailPage(qna: qnas[index * 2]),
              //                   ),
              //                 );
              //               },
              //             ),
              //             const Padding(
              //               padding: EdgeInsets.all(8.0),
              //               child: Divider(),
              //             ),
              //           ],
              //         ),
              //       ),
              //       const Expanded(child: Text(''))
              //     ],
              //   );
              // }
              if (index * 2 == qnas.length - 1) {
                return Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(qnas[index * 2].title),
                                _TimeFormat(qna: qnas[index * 2]),
                              ],
                            ),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      qnas[index * 2].nickName != null
                                          ? Text('작성자: ${qnas[index * 2].nickName}')
                                          : Text('작성자: ${qnas[index * 2].username}'),
                                      // Text('작성자: ${qnas[index * 2].username}'),
                                      SizedBox(
                                        height: phoneHeight * 0.015,
                                      ),
                                      qnas[index * 2].content.length > 15
                                          ? Text(
                                              '${qnas[index * 2].content.substring(0, 15)}...')
                                          : Text(qnas[index * 2]
                                              .content
                                              .substring(
                                                  0,
                                                  qnas[index * 2]
                                                      .content
                                                      .length)),
                                    ],
                                  ),
                                ),
                                const VerticalDivider(),
                                FutureBuilder(
                                  future: fetchBall(qnas[index * 2].locaSeq),
                                  builder: (context, ballSnapshot) {
                                    if (ballSnapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const CircularProgressIndicator(); // 로딩 중이면 로딩 표시
                                    } else if (ballSnapshot.hasError) {
                                      return Text(
                                          'Error: ${ballSnapshot.error}');
                                    } else {
                                      BallLocation ball = ballSnapshot.data!;
                                      return SizedBox(
                                        height: phoneHeight * 0.11,
                                        child: QnaDrawing(
                                          ballPositions:
                                              ball.locaFile.positions,
                                          boardX: phoneHeight * 0.20,
                                          billiardInfo:
                                              ball.locaFile.billiardInfo,
                                        ),
                                      );
                                    }
                                  },
                                ),
                                SizedBox(
                                  width: phoneHeight * 0.01,
                                ),
                              ],
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      QnaDetailPage(qna: qnas[index * 2]),
                                ),
                              );
                            },
                          ),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Divider(),
                          ),
                        ],
                      ),
                    ),
                    Expanded(child: Text(''),)
,                  ],
                );
              } else {
                return Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(qnas[index * 2].title),
                                _TimeFormat(qna: qnas[index * 2]),
                              ],
                            ),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      qnas[index * 2].nickName != null
                                          ? Text('작성자: ${qnas[index * 2].nickName}')
                                          : Text('작성자: ${qnas[index * 2].username}'),
                                      // Text('작성자: ${qnas[index * 2].username}'),
                                      SizedBox(
                                        height: phoneHeight * 0.015,
                                      ),
                                      qnas[index * 2].content.length > 15
                                          ? Text(
                                              '${qnas[index * 2].content.substring(0, 15)}...')
                                          : Text(qnas[index * 2]
                                              .content
                                              .substring(
                                                  0,
                                                  qnas[index * 2]
                                                      .content
                                                      .length)),
                                    ],
                                  ),
                                ),
                                const VerticalDivider(),
                                FutureBuilder(
                                  future: fetchBall(qnas[index * 2].locaSeq),
                                  builder: (context, ballSnapshot) {
                                    if (ballSnapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const CircularProgressIndicator(); // 로딩 중이면 로딩 표시
                                    } else if (ballSnapshot.hasError) {
                                      return Text(
                                          'Error: ${ballSnapshot.error}');
                                    } else {
                                      BallLocation ball = ballSnapshot.data!;
                                      return SizedBox(
                                        height: phoneHeight * 0.11,
                                        child: QnaDrawing(
                                          ballPositions:
                                              ball.locaFile.positions,
                                          boardX: phoneHeight * 0.20,
                                          billiardInfo:
                                              ball.locaFile.billiardInfo,
                                        ),
                                      );
                                    }
                                  },
                                ),
                                SizedBox(
                                  width: phoneHeight * 0.01,
                                ),
                              ],
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      QnaDetailPage(qna: qnas[index * 2]),
                                ),
                              );
                            },
                          ),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Divider(),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(qnas[index * 2 + 1].title),
                                _TimeFormat(qna: qnas[index * 2 + 1]),
                              ],
                            ),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      qnas[index * 2 + 1].nickName != null
                                          ? Text('작성자: ${qnas[index * 2 + 1].nickName}')
                                          : Text('작성자: ${qnas[index * 2 + 1].username}'),
                                      // Text(
                                      //     '작성자: ${qnas[index * 2 + 1].username}'),
                                      SizedBox(
                                        height: phoneHeight * 0.015,
                                      ),
                                      qnas[index * 2 + 1].content.length > 15
                                          ? Text(
                                              '${qnas[index * 2 + 1].content.substring(0, 15)}...')
                                          : Text(qnas[index * 2 + 1]
                                              .content
                                              .substring(
                                                  0,
                                                  qnas[index * 2 + 1]
                                                      .content
                                                      .length)),
                                    ],
                                  ),
                                ),
                                const VerticalDivider(),
                                FutureBuilder(
                                  future:
                                      fetchBall(qnas[index * 2 + 1].locaSeq),
                                  builder: (context, ballSnapshot) {
                                    if (ballSnapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const CircularProgressIndicator(); // 로딩 중이면 로딩 표시
                                    } else if (ballSnapshot.hasError) {
                                      return Text(
                                          'Error: ${ballSnapshot.error}');
                                    } else {
                                      BallLocation ball = ballSnapshot.data!;
                                      return SizedBox(
                                        height: phoneHeight * 0.11,
                                        child: QnaDrawing(
                                          ballPositions:
                                              ball.locaFile.positions,
                                          boardX: phoneHeight * 0.20,
                                          billiardInfo:
                                              ball.locaFile.billiardInfo,
                                        ),
                                      );
                                    }
                                  },
                                ),
                                SizedBox(
                                  width: phoneHeight * 0.01,
                                ),
                              ],
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      QnaDetailPage(qna: qnas[index * 2 + 1]),
                                ),
                              );
                            },
                          ),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Divider(),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
            },
          );
        }
      },
    );
  }
}

class _TimeFormat extends StatelessWidget {
  final Qna qna;

  const _TimeFormat({required this.qna, super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height * 0.018;
    DateTime creAt = qna.createdAt;
    DateTime? upAt = qna.updatedAt;
    String createdHour = creAt.hour >= 10 ? '${creAt.hour}' : '0${creAt.hour}';
    String createdMinute =
        creAt.minute >= 10 ? '${creAt.minute}' : '0${creAt.minute}';
    String? updatedHour = upAt != null
        ? upAt.hour >= 10
            ? '${upAt.hour}'
            : '0${upAt.hour}'
        : null;
    String? updatedMinute = upAt != null
        ? upAt.minute >= 10
            ? '${upAt.minute}'
            : '0${upAt.minute}'
        : null;

    if (upAt == null) {
      return Padding(
        padding: EdgeInsets.only(right: height),
        child: Text(
          '${creAt.year}.${creAt.month}.${creAt.day}  ${createdHour}:${createdMinute}',
          textAlign: TextAlign.end,
          style: TextStyle(fontSize: height),
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.only(right: height),
        child: Text(
          '${upAt.year}.${upAt.month}.${upAt.day} '
          '$updatedHour:$updatedMinute',
          textAlign: TextAlign.end,
          style: TextStyle(fontSize: height),
        ),
      );
    }
  }
}
