import 'package:flutter/material.dart';
import 'package:project/data/board_manager.dart';
import 'package:project/data/token_manger.dart';
import 'package:http/http.dart' as http;

class DetailTitle extends StatefulWidget {
  final Board board;

  const DetailTitle({required this.board, super.key});

  @override
  State<DetailTitle> createState() => _DetailTitleState();

  Widget _buildBody(BuildContext context, int currentUserId) {
    final int postAuthorId = board.userSeq;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            board.title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // FutureBuilder(future: fetchUserInfo(postAuthorId), builder: builder)
            board.nickName != null
                ? Text('작성자: ${board.nickName}')
                : Text('작성자: ${board.username}'),
            _TimeFormat(board: board)
          ],
        ),
        SizedBox(height: 16),
      ],
    );
  }
}

class _DetailTitleState extends State<DetailTitle> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int?>(
      future: UserSeqManager.LoadSeq(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final int currentUserId = snapshot.data ?? 0;
          return widget._buildBody(context, currentUserId);
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}

class _TimeFormat extends StatelessWidget {
  final Board board;

  const _TimeFormat({required this.board, super.key});

  @override
  Widget build(BuildContext context) {
    DateTime creAt = board.createdAt;
    DateTime? upAt = board.updatedAt;
    String createdHour = creAt.hour >= 10 ? '${creAt.hour}' : '0${creAt.hour}';
    String createdMinute = creAt.minute >= 10 ? '${creAt.minute}' : '0${creAt.minute}';
    String? updatedHour = upAt != null ? upAt!.hour >= 10 ? '${upAt!.hour}' : '0${upAt!.hour}' : null;
    String? updatedMinute = upAt != null ? upAt!.minute >= 10 ? '${upAt!.minute}' : '0${upAt!.minute}' : null;

    return upAt == null
        ? Text(
      '${creAt.year}.${creAt.month}.${creAt.day} ${createdHour}:${createdMinute}',
      textAlign: TextAlign.end,
      style: TextStyle(fontSize: 11),
    )
        : Text(
      '*수정됨 ${upAt?.year}.${upAt?.month}.${upAt?.day} ${updatedHour}:${updatedMinute}',
      textAlign: TextAlign.end,
      style: TextStyle(fontSize: 11),
    );
  }
}