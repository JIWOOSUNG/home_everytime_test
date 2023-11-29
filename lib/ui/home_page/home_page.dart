import 'package:everytime/bloc/everytime_user_bloc.dart';
import 'package:everytime/component/custom_appbar.dart';
import 'package:everytime/component/custom_appbar_animation.dart';
import 'package:everytime/component/custom_appbar_button.dart';
import 'package:everytime/global_variable.dart';
import 'package:everytime/ui/my_info_page.dart';
import 'package:everytime/ui/home_page/search_page/search_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';
import 'package:url_launcher/url_launcher.dart';

import '../board_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
    required this.scrollController,
    required this.userBloc,
  }) : super(key: key);

  final ScrollController scrollController;
  final EverytimeUserBloc userBloc;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  final BehaviorSubject<double> _scrollOffset = BehaviorSubject.seeded(0);

  @override
  void initState() {
    super.initState();

    widget.scrollController.addListener(() {
      _scrollOffset.sink.add(widget.scrollController.offset);
    });
  }

  @override
  void dispose() {
    super.dispose();

    widget.scrollController.removeListener(() {
      _scrollOffset.sink.add(widget.scrollController.offset);
    });

    _scrollOffset.close();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    // ... (existing code)

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBarAnimation(
              scrollOffsetStream: _scrollOffset.stream,
              title: "에브리타임1111111111111111111",
            ),
            StreamBuilder(
              stream: widget.userBloc.univ,
              builder: (_, univSnapshot) {
                if (univSnapshot.hasData) {
                  return Column(
                    children: [
                      CustomAppBar(
                        title: univSnapshot.data!,
                        buttonList: [
                          CustomAppBarButton(
                            icon: Icons.search_rounded,
                            onPressed: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (BuildContext pageContext) {
                                    return SearchPage(
                                      userBloc: widget.userBloc,
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      // Add 7 buttons below the title
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildIconTextSet(
                            Icons.open_in_browser,
                            'https://www.kumoh.ac.kr/ko/index.do',
                            '학교 홈',
                          ),
                          _buildIconTextSet(
                            Icons.open_in_browser,
                            'https://www.kumoh.ac.kr/bus/index.do',
                            '통학버스',
                          ),
                          _buildIconTextSet(
                            Icons.open_in_browser,
                            'https://www.kumoh.ac.kr/ko/sub06_01_01_01.do',
                            '학사공지',
                          ),
                          _buildIconTextSet(
                            Icons.open_in_browser,
                            'https://www.kumoh.ac.kr/ko/schedule.do',
                            '학사일정',
                          ),
                          _buildIconTextSet(
                            Icons.open_in_browser,
                            'https://library.kumoh.ac.kr/#/',
                            '도서관',
                          ),
                          _buildIconTextSet(
                            Icons.open_in_browser,
                            'https://mail.kumoh.ac.kr/account/login.do',
                            '웹메일',
                          ),
                        ],
                      ),
                        ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext pageContext) {
                                return BoardPage();
                              },
                            ),
                          );
                        },
                        child: Text('더보기'),
                      ),
                    ],
                  );
                }
                return CustomAppBar(
                  title: "로딩중1111111111111111111111111111..",
                  buttonList: const [],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconTextSet(
    IconData icon,
    String url,
    String buttonText,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomAppBarButton(
          icon: icon,
          onPressed: () {
            _launchURL(url);
          },
        ),
        Text(
          buttonText,
          style: TextStyle(fontSize: 12),
        ),
      ],
    );
  }



  // URL을 열기 위한 함수
  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}