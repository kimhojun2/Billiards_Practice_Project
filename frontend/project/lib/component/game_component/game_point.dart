// import 'package:flutter/material.dart';
//
// class PlayerScore extends StatefulWidget {
//   final int playerId;
//   final Function(int) onDelete;
//
//   PlayerScore({
//     required this.playerId,
//     required this.onDelete,
//   });
//
//   @override
//   _PlayerScoreState createState() => _PlayerScoreState();
// }
//
// class _PlayerScoreState extends State<PlayerScore> {
//   TextEditingController playerNameController = TextEditingController();
//   int score = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     playerNameController.text = '이름입력';
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 3),
//       padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         border: Border.all(),
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           // 이름 입력 칸
//           Expanded(
//             flex: 1,
//             child: TextField(
//               controller: playerNameController,
//               onTap: () {
//                 if (playerNameController.text == '이름입력') {
//                   playerNameController.clear();
//                 }
//               },
//               onChanged: (value) {
//                 setState(() {
//                   playerNameController.text = value;
//                 });
//               },
//               decoration: InputDecoration(
//                 // labelText: 'Player Name',
//                 hintText: playerNameController.text.isEmpty
//                     ? '이름입력'
//                     : '', // 힌트 텍스트 추가
//               ),
//             ),
//           ),
//           SizedBox(width: 10),
//           // 점수 시각화 바
//           Expanded(
//             flex: 3,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 LinearProgressIndicator(
//                   value: score / 300, // 0부터 100까지의 범위로 가정
//                   // minHeight: 50,
//                   valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(width: 10),
//
//           Expanded(
//             flex: 1,
//             child: Column(
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     IconButton(
//                       icon: Icon(Icons.arrow_left),
//                       onPressed: () {
//                         setState(() {
//                           score =
//                               (score - 10).clamp(0, 300); // 0부터 100까지의 범위로 가정
//                         });
//                       },
//                     ),
//                     Text("$score"),
//                     IconButton(
//                       icon: Icon(Icons.arrow_right),
//                       onPressed: () {
//                         setState(() {
//                           score =
//                               (score + 10).clamp(0, 300); // 0부터 100까지의 범위로 가정
//                         });
//                       },
//                     ),
//                   ],
//                 ),
//                 // 추가된 부분: 플레이어 제거 버튼
//                 IconButton(
//                   icon: Icon(Icons.delete),
//                   onPressed: () {
//                     widget.onDelete(widget.playerId);
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
