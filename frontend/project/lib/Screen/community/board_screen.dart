import 'package:flutter/material.dart';
import 'package:project/Screen/community/board_detail.dart';
import 'package:project/Screen/community/board_new.dart';
import 'package:project/data/board_manager.dart';
import 'package:project/layout/community_layout.dart';

class BoardScreen extends StatelessWidget {
  const BoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double phoneWidth = MediaQuery.of(context).size.width;
    double phoneHeight = MediaQuery.of(context).size.height;

    return CommunityLayout(
      bodyHead: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: phoneWidth * 0.03, right: phoneWidth * 0.02, top: phoneHeight * 0.02),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '일반게시판',
                  style: TextStyle(fontSize: phoneHeight * 0.03, fontWeight: FontWeight.w700),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const BoardNew(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      // side: BorderSide(color: Colors.black, width: 3)
                    ),
                  ),
                  child: Text(
                    '글쓰기',
                    style: TextStyle(color: Colors.white, fontSize: phoneHeight * 0.022),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: phoneHeight * 0.044,
          ),
        ],
      ),
      bodyCol: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: phoneHeight * 0.01),
            child: Row(
              children: [
                Expanded(
                    flex: 2,
                    child: Text(
                      '번호',
                      style: TextStyle(fontSize: phoneHeight * 0.016),
                      textAlign: TextAlign.center,
                    )),
                Expanded(
                  flex: 18,
                  child: Text(
                    '제목',
                    style: TextStyle(color: Colors.black, fontSize: phoneHeight * 0.016),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Text(
                    '작성자',
                    style: TextStyle(fontSize: phoneHeight * 0.016),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Text(
                    '작성시간',
                    style: TextStyle(fontSize: phoneHeight * 0.016),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          FutureBuilder<List<Board>>(
            future: fetchBoards(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator(); // 로딩 중이면 로딩 표시
              } else if (snapshot.hasError) {
                return Text('123Error: ${snapshot.error}');
              } else {
                List<Board> boards = snapshot.data!;
                // print(boards);
                return ListView.builder(
                  padding: const EdgeInsets.all(0),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: boards.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Row(
                        children: [
                          Expanded(
                              flex: 2,
                              child: Text(
                                boards[boards.length - 1 - index].id.toString(),
                                // style: TextStyle(fontSize: phoneHeight * 0.016),
                                textAlign: TextAlign.center,
                              )),
                          Expanded(
                            flex: 18,
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 4.0),
                                  child: Text(
                                    boards[boards.length - 1 - index].title,
                                    style: TextStyle(
                                        color: Colors.black,
                                        // fontSize: phoneHeight * 0.016,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                              flex: 5,
                              child: Center(
                                child:
                                boards[boards.length - 1 - index].nickName != null
                                    ? Text('${boards[boards.length - 1 - index].nickName}', textAlign: TextAlign.center,)
                                    : Text('${boards[boards.length - 1 - index].username}', textAlign: TextAlign.center,),
                                // Text(
                                //   boards[boards.length - 1 - index].username,
                                //   // style: TextStyle(fontSize: phoneHeight * 0.016),
                                //     textAlign: TextAlign.center,
                                // ),
                              ),),
                          Expanded(
                              flex: 4,
                              child: _TimeFormat(board: boards[boards.length - 1 - index])),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                // BoardDetail(board: boards[index]),
                                BoardDetail(board: boards[boards.length - 1 - index]),
                          ),
                        );
                      },
                    );
                  },
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class _TimeFormat extends StatelessWidget {
  final Board board;

  const _TimeFormat({required this.board, super.key});

  @override
  Widget build(BuildContext context) {
    double phoneHeight = MediaQuery.of(context).size.height;
    DateTime now = DateTime.now();
    DateTime creAt = board.createdAt;
    DateTime? upAt = board.updatedAt;
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

    return upAt == null
        ? now.month == creAt.month && now.day == now.month
            ? Text(
                '$createdHour:$createdMinute',
                textAlign: TextAlign.end,
                style: TextStyle(fontSize: phoneHeight * 0.015),
              )
            : Text(
                '${creAt.year}\n${creAt.month}.${creAt.day}',
                textAlign: TextAlign.end,
                style: TextStyle(fontSize: phoneHeight * 0.015),
              )
        : now.month == upAt.month && now.day == upAt.month
            ? Text(
                '$updatedHour:$updatedMinute',
                textAlign: TextAlign.end,
                style: TextStyle(fontSize: phoneHeight * 0.015),
              )
            : Text(
                '${upAt.year}\n${upAt.month}.${upAt.day}',
                textAlign: TextAlign.end,
                style: TextStyle(fontSize: phoneHeight * 0.015),
              );
  }
}
