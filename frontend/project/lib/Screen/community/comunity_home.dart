import 'package:flutter/material.dart';
import 'package:project/Screen/community/board_detail.dart';
import 'package:project/Screen/community/board_screen.dart';
import 'package:project/Screen/community/qna_detail.dart';
import 'package:project/Screen/community/qna_screen.dart';
import 'package:project/data/qna_manager.dart';
import 'package:project/layout/community_layout.dart';
import 'package:project/data/board_manager.dart';

class CommunityHome extends StatelessWidget {
  const CommunityHome({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime nowUtc = DateTime.now();
    DateTime now = nowUtc.add(const Duration(hours: 9));

    return CommunityLayout(
      bodyHead: MediaQuery.of(context).size.width > 600
          ? Image.asset('asset/img/banner3.png',
              width: MediaQuery.of(context).size.width * 0.8)
          : Image.asset('asset/img/banner.png'),
      bodyCol: Column(
        children: [
          MediaQuery.of(context).size.width > 600
              ? Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        // Expanded(flex: 1, child: Text(''),),
                        const SizedBox(
                          width: 70,
                        ),
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('   최근 게시글'),
                                    IconButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) => const BoardScreen(),
                                        ));
                                      },
                                      icon: const Icon(Icons.add),
                                    )
                                  ],
                                ),
                                const Divider(),
                                FutureBuilder<List<Board>>(
                                  future: fetchBoards(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                          child:
                                              CircularProgressIndicator()); // 로딩 중이면 로딩 표시
                                    } else if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else {
                                      List<Board> boards = snapshot.data!;
                                      List<Board> posts =
                                          boards.take(5).toList();
                                      return ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: posts.length,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10.0),
                                            child: ListTile(
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 0),
                                              title: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text('${posts[index].title}'),
                                                  now.day == posts[index].createdAt.day ?
                                                  now.month == posts[index].createdAt.month ?
                                                  Text(
                                                      '${posts[index].createdAt.hour.toString()}.'
                                                          '${posts[index].createdAt.minute.toString()}')
                                                  : Text(
                                                      '${posts[index].createdAt.month.toString()}.'
                                                          '${posts[index].createdAt.day.toString()}')
                                                  : Text(
                                                      '${posts[index].createdAt.month.toString()}.'
                                                          '${posts[index].createdAt.day.toString()}'),
                                                ],
                                              ),
                                              onTap: () {
                                                // 제목을 클릭할 때 상세보기 페이지로 이동
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        BoardDetail(
                                                            board:
                                                                posts[index]),
                                                  ),
                                                );
                                              },
                                            ),
                                          );
                                        },
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('   최근 질문글'),
                                    IconButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) => const QnaScreen(),
                                        ));
                                      },
                                      icon: const Icon(Icons.add),
                                    )
                                  ],
                                ),
                                const Divider(),
                                FutureBuilder<List<Qna>>(
                                  future: fetchQnas(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                          child:
                                              CircularProgressIndicator()); // 로딩 중이면 로딩 표시
                                    } else if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else {
                                      List<Qna> qnas = snapshot.data!;
                                      List<Qna> qnaposts =
                                          qnas.take(4).toList();
                                      return ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: qnaposts.length,
                                        itemBuilder: (context, index) {
                                          return ListTile(
                                            title: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(qnaposts[index].title),
                                                now.day == qnaposts[index].createdAt.day ?
                                                now.month == qnaposts[index].createdAt.month ?
                                                Text(
                                                    '${qnaposts[index].createdAt.hour.toString()}.'
                                                        '${qnaposts[index].createdAt.minute.toString()}')
                                                    : Text(
                                                    '${qnaposts[index].createdAt.month.toString()}.'
                                                        '${qnaposts[index].createdAt.day.toString()}')
                                                    : Text(
                                                    '${qnaposts[index].createdAt.month.toString()}.'
                                                        '${qnaposts[index].createdAt.day.toString()}'),
                                              ],
                                            ),
                                            // subtitle: Row(
                                            //   mainAxisAlignment: MainAxisAlignment.end,
                                            //   children: [
                                            //     // Text(posts[index].createdAt.toString()),
                                            //     Text(qnaposts[index].createdAt),
                                            //     Text(qnaposts[index].updatedAt != null ? qnaposts[index].updatedAt.toString() : ''),
                                            //   ],
                                            // ),
                                            onTap: () {
                                              // 제목을 클릭할 때 상세보기 페이지로 이동
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      QnaDetailPage(
                                                          qna: qnaposts[index]),
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
                          ),
                        ),
                        const SizedBox(
                          width: 70,
                        )
                      ],
                    ),
                  ],
                )
              : Column(
                  children: [
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('   최근 게시글'),
                        IconButton(
                          onPressed: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(
                              builder: (context) => const BoardScreen(),
                            ));
                          },
                          icon: const Icon(Icons.add),
                        )
                      ],
                    ),
                    FutureBuilder<List<Board>>(
                      future: fetchBoards(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator(); // 로딩 중이면 로딩 표시
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          List<Board> boards = snapshot.data!;
                          List<Board> posts = boards.take(3).toList();
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: posts.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(posts[index].title),
                                    now.day == posts[index].createdAt.day ?
                                    now.month == posts[index].createdAt.month ?
                                    Text(
                                        '${posts[index].createdAt.hour.toString()}.'
                                            '${posts[index].createdAt.minute.toString()}')
                                        : Text(
                                        '${posts[index].createdAt.month.toString()}.'
                                            '${posts[index].createdAt.day.toString()}')
                                        : Text(
                                        '${posts[index].createdAt.month.toString()}.'
                                            '${posts[index].createdAt.day.toString()}'),
                                  ],
                                ),
                                // subtitle: Row(
                                //   mainAxisAlignment: MainAxisAlignment.end,
                                //   children: [
                                //     // Text(posts[index].createdAt.toString()),
                                //     Text(posts[index].createdAt),
                                //     Text(posts[index].updatedAt != null ? posts[index].updatedAt.toString() : ''),
                                //   ],
                                // ),
                                onTap: () {
                                  // 제목을 클릭할 때 상세보기 페이지로 이동
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          BoardDetail(board: posts[index]),
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        }
                      },
                    ),
                    // Expanded(
                    //   child: Padding(
                    //     padding: const EdgeInsets.all(10.0),
                    //     child: FutureBuilder<List<Board>>(
                    //       future: fetchBoards(),
                    //       builder: (context, snapshot) {
                    //         if (snapshot.connectionState == ConnectionState.waiting) {
                    //           return CircularProgressIndicator(); // 로딩 중이면 로딩 표시
                    //         } else if (snapshot.hasError) {
                    //           return Text('Error: ${snapshot.error}');
                    //         } else {
                    //           List<Board> posts = snapshot.data!;
                    //           return ListView.builder(
                    //             shrinkWrap: true,
                    //             itemCount: posts.length,
                    //             itemBuilder: (context, index) {
                    //               return ListTile(
                    //                 title: Row(
                    //                   mainAxisAlignment: MainAxisAlignment.start,
                    //                   children: [
                    //                     Text(posts[index].id.toString()),
                    //                     Text(posts[index].title),
                    //                   ],
                    //                 ),
                    //                 // subtitle: Row(
                    //                 //   mainAxisAlignment: MainAxisAlignment.end,
                    //                 //   children: [
                    //                 //     // Text(posts[index].createdAt.toString()),
                    //                 //     Text(posts[index].createdAt),
                    //                 //     Text(posts[index].updatedAt != null ? posts[index].updatedAt.toString() : ''),
                    //                 //   ],
                    //                 // ),
                    //                 onTap: () {
                    //                   // 제목을 클릭할 때 상세보기 페이지로 이동
                    //                   Navigator.push(
                    //                     context,
                    //                     MaterialPageRoute(
                    //                       builder: (context) =>
                    //                           BoardDetail(board: posts[index]),
                    //                     ),
                    //                   );
                    //                 },
                    //               );
                    //             },
                    //           );
                    //         }
                    //       },
                    //     ),
                    //   ),
                    // ),
                    const Divider(),
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('   최근 질문글'),
                        IconButton(
                          onPressed: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(
                              builder: (context) => const QnaScreen(),
                            ));
                          },
                          icon: const Icon(Icons.add),
                        )
                      ],
                    ),
                    FutureBuilder<List<Qna>>(
                      future: fetchQnas(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator(); // 로딩 중이면 로딩 표시
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          List<Qna> qnas = snapshot.data!;
                          List<Qna> qnaposts = qnas.take(3).toList();
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: qnaposts.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(qnaposts[index].title),
                                    now.day == qnaposts[index].createdAt.day ?
                                    now.month == qnaposts[index].createdAt.month ?
                                    Text(
                                        '${qnaposts[index].createdAt.hour.toString()}.'
                                            '${qnaposts[index].createdAt.minute.toString()}')
                                        : Text(
                                        '${qnaposts[index].createdAt.month.toString()}.'
                                            '${qnaposts[index].createdAt.day.toString()}')
                                        : Text(
                                        '${qnaposts[index].createdAt.month.toString()}.'
                                            '${qnaposts[index].createdAt.day.toString()}'),
                                  ],
                                ),
                                // subtitle: Row(
                                //   mainAxisAlignment: MainAxisAlignment.end,
                                //   children: [
                                //     // Text(posts[index].createdAt.toString()),
                                //     Text(qnaposts[index].createdAt),
                                //     Text(qnaposts[index].updatedAt != null ? qnaposts[index].updatedAt.toString() : ''),
                                //   ],
                                // ),
                                onTap: () {
                                  // 제목을 클릭할 때 상세보기 페이지로 이동
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          QnaDetailPage(qna: qnaposts[index]),
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        }
                      },
                    ),
                    // Expanded(
                    //   child: Padding(
                    //     padding: const EdgeInsets.all(10.0),
                    //     child: FutureBuilder<List<Qna>>(
                    //       future: fetchQnas(),
                    //       builder: (context, snapshot) {
                    //         if (snapshot.connectionState == ConnectionState.waiting) {
                    //           return CircularProgressIndicator(); // 로딩 중이면 로딩 표시
                    //         } else if (snapshot.hasError) {
                    //           return Text('Error: ${snapshot.error}');
                    //         } else {
                    //           List<Qna> qnaposts = snapshot.data!;
                    //           return ListView.builder(
                    //             shrinkWrap: true,
                    //             itemCount: qnaposts.length,
                    //             itemBuilder: (context, index) {
                    //               return ListTile(
                    //                 title: Row(
                    //                   mainAxisAlignment: MainAxisAlignment.start,
                    //                   children: [
                    //                     Text(qnaposts[index].id.toString()),
                    //                     Text(qnaposts[index].title),
                    //                   ],
                    //                 ),
                    //                 // subtitle: Row(
                    //                 //   mainAxisAlignment: MainAxisAlignment.end,
                    //                 //   children: [
                    //                 //     // Text(posts[index].createdAt.toString()),
                    //                 //     Text(qnaposts[index].createdAt),
                    //                 //     Text(qnaposts[index].updatedAt != null ? qnaposts[index].updatedAt.toString() : ''),
                    //                 //   ],
                    //                 // ),
                    //                 onTap: () {
                    //                   // 제목을 클릭할 때 상세보기 페이지로 이동
                    //                   Navigator.push(
                    //                     context,
                    //                     MaterialPageRoute(
                    //                       builder: (context) =>
                    //                           QnaDetailPage(qna: qnaposts[index]),
                    //                     ),
                    //                   );
                    //                 },
                    //               );
                    //             },
                    //           );
                    //         }
                    //       },
                    //     ),
                    //   ),
                    // ),
                  ],
                )
        ],
      ),
    );
  }
}
