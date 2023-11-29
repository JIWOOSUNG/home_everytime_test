import 'package:everytime/ui/board_page/freeBoard.dart';
import 'package:flutter/material.dart';

import 'board_page/free_board_page.dart';

class BoardPage extends StatefulWidget {
  const BoardPage({Key? key}) : super(key: key);

  @override
  _BoardPageState createState() => _BoardPageState();
}

class _BoardPageState extends State<BoardPage> {
  List<bool> isPinned = [
    false,
    false,
    true,
    false,
    false,
    true,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Padding(
          padding: const EdgeInsets.only(left: 10, top: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  const Text(
                    "게시판",
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  Container(width: 60, height: 2, color: Colors.black),
                ],
              ),
              const SizedBox(
                width: 15,
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: Container(
                alignment: Alignment.topLeft,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      myboard("내가 쓴 글", Icons.format_list_bulleted_outlined,
                          Colors.blue, context),
                      myboard("댓글 단 글", Icons.messenger_outline, Colors.green,
                          context),
                      myboard(
                          "스크랩", Icons.star_outline, Colors.yellow, context),
                      myboard("HOT 게시판", Icons.local_fire_department_outlined,
                          Colors.red, context),
                      myboard("BEST 게시판", Icons.emoji_events_outlined,
                          Colors.orange, context),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: Container(
                alignment: Alignment.topLeft,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      board("자유게시판", isPinned[0], context, 0),
                      board("비밀게시판", isPinned[1], context, 1),
                      board("졸업생게시판", isPinned[2], context, 2),
                      board("새내기게시판", isPinned[3], context, 3),
                      board("시사・이슈", isPinned[4], context, 4),
                      board("정보게시판", isPinned[5], context, 5),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget board(String title, bool isPinned, BuildContext context, int index) {
    return TextButton(
      onPressed: () {
        if (boardPages.containsKey(title)) {
          var page = boardPages[title];
          if (page != null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => page),
            );
          }
        }
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          IconButton(
            icon: const Icon(Icons.push_pin),
            color: isPinned ? Colors.black : Colors.grey,
            onPressed: () {
              setState(() {
                this.isPinned[index] = !this.isPinned[index];
              });
            },
          ),
          const Text("  "),
          Text(
            title,
            textAlign: TextAlign.left,
            style: const TextStyle(color: Colors.black, fontSize: 15.0),
          ),
        ],
      ),
    );
  }
}

final boardPages = {
  // "내가 쓴 글": FreeBoard(), //MyPostBoard(),
  // "댓글 단 글": FreeBoard(), //MyCommentBoard(),
  // "스크랩": FreeBoard(), //ScrapBoard(),
  // "HOT 게시판": FreeBoard(), //HotBoard(),
  // "BEST 게시판": FreeBoard(), //BestBoard(),
  "자유게시판": const FreeBoard(),
  // "비밀게시판": FreeBoard(), //SecretBoard(),
  // "졸업생게시판": FreeBoard(), //GraduatesBoard(),
  // "새내기게시판": FreeBoard(), //FreshmenBoard(),
  // "시사・이슈": FreeBoard(), //CurrentIssues(),
  // "정보게시판": FreeBoard(), //InfoBoard(),
};

Widget myboard(
    String title, IconData icon, Color iconColor, BuildContext context) {
  return TextButton(
    onPressed: () {
      if (boardPages.containsKey(title)) {
        var page = boardPages[title];
        if (page != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        }
      }
    },
    child: Row(
      children: <Widget>[
        Icon(icon, color: iconColor),
        const Text("  "),
        Text(title,
            textAlign: TextAlign.left,
            style: const TextStyle(color: Colors.black, fontSize: 15.0)),
      ],
    ),
  );
}
