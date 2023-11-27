import '../../../bloc/user_profile_management_bloc.dart';
import '../../../bloc/clas_timetable_management_bloc.dart';
import 'package:everytime/component/custom_container.dart';
import 'package:everytime/component/custom_cupertino_alert_dialog.dart';
import 'package:everytime/component/custom_picker_modal_bottom_sheet.dart';
import 'package:everytime/screen_dimensions.dart';
import '../../../model/academic_enums.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:positioned_tap_detector_2/positioned_tap_detector_2.dart';

class SubjectsChartAtGradeCalculatorPage extends StatelessWidget {
  const SubjectsChartAtGradeCalculatorPage({
    Key? key,
    required this.userBloc,
    required this.gradeCalculatorBloc,
    required this.listScrollController,
  }) : super(key: key);

  final EverytimeUserBloc userBloc;
  final GradeManagementBloc gradeCalculatorBloc;
  final ScrollController listScrollController;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: gradeCalculatorBloc.selectedTerm,
      builder: (_, currentTermIndexSnapshot) {
        if (currentTermIndexSnapshot.hasData) {
          return StreamBuilder(
            stream: userBloc.getTerm(currentTermIndexSnapshot.data!).subjects,
            builder: (_, subjectsSnapshot) {
              if (subjectsSnapshot.hasData) {
                return SizedBox(
                  height: (subjectsSnapshot.data!.length + 2) *
                      availableHeight *
                      0.05313,
                  child: CustomContainer(
                    height: (subjectsSnapshot.data!.length + 2) *
                        availableHeight *
                        0.05313,
                    usePadding: false,
                    child: _buildEditSubjects(
                      context,
                      currentTermIndexSnapshot.data!,
                      subjectsSnapshot.data!.length,
                    ),
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildEditSubjects(
    BuildContext context,
    int currentTermIndex,
    int currentSubjectsLength,
  ) {
    return Column(
      children: List.generate(
        currentSubjectsLength + 2,
        (index) {
          return Container(
            height: availableHeight * 0.0520625,
            decoration: BoxDecoration(
              border: Border(
                bottom: (index + 1 == currentSubjectsLength + 2)
                    ? BorderSide.none
                    : BorderSide(
                        color: Theme.of(context).dividerColor,
                      ),
              ),
            ),
            child: (index == 0)
                ? (_buildEditSubjectsIndexFirst(
                    context, currentTermIndex, currentSubjectsLength))
                : ((index + 1 == currentSubjectsLength + 2)
                    ? (_buildEditSubjectsIndexLast(
                        context, currentTermIndex, currentSubjectsLength))
                    : (_buildEditSubjectsIndexRemain(context, currentTermIndex,
                        currentSubjectsLength, index))),
          );
        },
      ),
    );
  }

  Widget _buildEditSubjectsIndexFirst(
      BuildContext context, int currentTermIndex, int currentSubjectsLength) {
    return Row(
      children: [
        Container(
          width: availableWidth * 0.47,
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(
                color: Theme.of(context).dividerColor,
              ),
            ),
          ),
          child: Center(
            child: Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(
                left: availableWidth * 0.04,
              ),
              child: Text(
                '과목명',
                style: TextStyle(
                  color: Theme.of(context).hintColor,
                  fontSize: 17.5,
                ),
              ),
            ),
          ),
        ),
        Container(
          width: availableWidth * 0.16,
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(
                color: Theme.of(context).dividerColor,
              ),
            ),
          ),
          child: Center(
            child: Text(
              '학점',
              style: TextStyle(
                color: Theme.of(context).hintColor,
                fontSize: 17.5,
              ),
            ),
          ),
        ),
        Container(
          width: availableWidth * 0.16,
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(
                color: Theme.of(context).dividerColor,
              ),
            ),
          ),
          child: Center(
            child: Text(
              '성적',
              style: TextStyle(
                color: Theme.of(context).hintColor,
                fontSize: 17.5,
              ),
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: Text(
              '전공',
              style: TextStyle(
                color: Theme.of(context).hintColor,
                fontSize: 17.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEditSubjectsIndexLast(
    BuildContext context,
    int currentTermIndex,
    int currentSubjectsLength,
  ) {
    return Container(
      padding: EdgeInsets.only(
        right: availableWidth * 0.04,
        left: availableWidth * 0.04,
      ),
      child: Row(
        children: [
          SizedBox(
            width: availableWidth * 0.15,
            child: MaterialButton(
              padding: EdgeInsets.zero,
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              child: Text(
                '더 입력하기',
                style: TextStyle(
                  color: Theme.of(context).focusColor,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                userBloc.getTerm(currentTermIndex).addSubject();
              },
            ),
          ),
          SizedBox(width: availableWidth * 0.04),
          SizedBox(
            width: availableWidth * 0.1,
            child: MaterialButton(
              padding: EdgeInsets.zero,
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              child: Text(
                '초기화',
                style: TextStyle(
                  color: Theme.of(context).hintColor,
                  fontSize: 14.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                _buildResetDataDialog(
                  context,
                  currentTermIndex,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _buildResetDataDialog(BuildContext context, int currentTermIndex) {
    showCupertinoDialog(
      context: context,
      builder: (dialogContext) {
        return CustomCupertinoAlertDialog(
          isDarkStream: userBloc.isDark,
          title:
              '${userBloc.getTerm(currentTermIndex).termName} 정보를\n초기화하시겠습니까?',
          actions: [
            CupertinoButton(
              child: const Text('아니오'),
              onPressed: () {
                Navigator.pop(dialogContext);
              },
            ),
            CupertinoButton(
              child: const Text('예'),
              onPressed: () {
                userBloc.getTerm(currentTermIndex).removeAdditionalSubjects();
                for (int i = 0;
                    i <
                        userBloc
                            .getTerm(currentTermIndex)
                            .currentSubjects
                            .length;
                    i++) {
                  userBloc.getTerm(currentTermIndex).setDefault(i);
                }
                userBloc.getTerm(currentTermIndex).updateSubjects();
                userBloc.updateData();
                Navigator.pop(dialogContext);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildEditSubjectsIndexRemain(
    BuildContext context,
    int currentTermIndex,
    int currentSubjectsLength,
    int currentIndex,
  ) {
    return Row(
      children: [
        //과목명
        Container(
          width: availableWidth * 0.47,
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(
                color: Theme.of(context).dividerColor,
              ),
            ),
            color: Theme.of(context).cardColor,
          ),
          child: Center(
            child: StreamBuilder(
              stream: userBloc.getTerm(currentTermIndex).subjects,
              builder: (_, subjectsSnapshot) {
                if (subjectsSnapshot.hasData) {
                  return Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(
                      left: availableWidth * 0.04,
                      right: availableWidth * 0.04,
                    ),
                    child: CupertinoTextField(
                      controller: TextEditingController(
                        text:
                            subjectsSnapshot.data![currentIndex - 1].courseName,
                      ),
                      padding: EdgeInsets.zero,
                      cursorColor: Theme.of(context).highlightColor,
                      decoration: const BoxDecoration(),
                      style: TextStyle(
                        fontSize: 17,
                        color: Theme.of(context).highlightColor,
                      ),
                      textInputAction: TextInputAction.done,
                      onChanged: (value) {
                        userBloc
                            .getTerm(currentTermIndex)
                            .updateSubject(currentIndex - 1, courseName: value);
                      },
                      onSubmitted: (value) {
                        userBloc
                            .getTerm(currentTermIndex)
                            .updateSubject(currentIndex - 1, courseName: value);
                        userBloc.updateData();
                      },
                      onTap: _showKeyboardAction,
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ),
        //학점
        Container(
          width: availableWidth * 0.16,
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(
                color: Theme.of(context).dividerColor,
              ),
            ),
            color: Theme.of(context).cardColor,
          ),
          child: Center(
            child: StreamBuilder(
              stream: userBloc.getTerm(currentTermIndex).subjects,
              builder: (_, subjectsSnapshot) {
                if (subjectsSnapshot.hasData) {
                  return CupertinoTextField(
                    controller: TextEditingController(
                      text: subjectsSnapshot
                          .data![currentIndex - 1].courseCredits
                          .toString(),
                    ),
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    padding: EdgeInsets.zero,
                    cursorColor: Theme.of(context).highlightColor,
                    decoration: const BoxDecoration(),
                    style: TextStyle(
                      fontSize: 17,
                      color: Theme.of(context).highlightColor,
                    ),
                    onChanged: (value) {
                      userBloc.getTerm(currentTermIndex).updateSubject(
                          currentIndex - 1,
                          courseCredits:
                              int.parse(value.isEmpty ? '0' : value));
                      userBloc.updateData();
                    },
                    onSubmitted: (value) {
                      userBloc.getTerm(currentTermIndex).updateSubject(
                          currentIndex - 1,
                          courseCredits:
                              int.parse(value.isEmpty ? '0' : value));
                      userBloc.updateData();
                    },
                    onTap: _showKeyboardAction,
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ),
        //성적
        Container(
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(
                color: Theme.of(context).dividerColor,
              ),
            ),
          ),
          child: StreamBuilder(
            stream: userBloc.getTerm(currentTermIndex).subjects,
            builder: (_, subjectsSnapshot) {
              if (subjectsSnapshot.hasData) {
                return PositionedTapDetector2(
                  child: Container(
                    width: availableWidth * 0.16,
                    height: availableHeight * 0.0520625,
                    alignment: Alignment.center,
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: StreamBuilder(
                      stream: gradeCalculatorBloc.selectingGradeIndex,
                      builder: (currentSelectingIndexContext,
                          currentSelectingIndexSnapshot) {
                        return Text(
                          subjectsSnapshot
                              .data![currentIndex - 1].courseGrade.label,
                          style: (currentSelectingIndexSnapshot.data != null)
                              ? (currentSelectingIndexSnapshot.data! ==
                                      currentIndex
                                  ? TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).focusColor,
                                    )
                                  : const TextStyle(
                                      fontSize: 17,
                                    ))
                              : const TextStyle(
                                  fontSize: 17,
                                ),
                        );
                      },
                    ),
                  ),
                  onTap: (position) async {
                    if (FocusScope.of(context).hasFocus) {
                      //log('has Focus');
                      FocusScope.of(context).unfocus();
                      // await keyboard animation
                      await Future.delayed(const Duration(milliseconds: 350));
                    }
                    _buildSelectGradeSheet(
                      context: context,
                      currentTermIndex: currentTermIndex,
                      currentIndex: currentIndex,
                      currentGradeType:
                          subjectsSnapshot.data![currentIndex - 1].courseGrade,
                      position: position,
                    );
                    gradeCalculatorBloc.updateSelectingGradeIndex(currentIndex);
                  },
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
        //전공
        Expanded(
          child: Center(
            child: StreamBuilder(
              stream: userBloc.getTerm(currentTermIndex).subjects,
              builder: (_, subjectsSnapshot) {
                if (subjectsSnapshot.hasData) {
                  return Checkbox(
                    value:
                        subjectsSnapshot.data![currentIndex - 1].isMajorCourse,
                    activeColor: Theme.of(context).focusColor,
                    checkColor: Theme.of(context).scaffoldBackgroundColor,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 0.5,
                        color: Theme.of(context).dividerColor,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    onChanged: (newValue) {
                      userBloc.getTerm(currentTermIndex).updateSubject(
                          currentIndex - 1,
                          isMajorCourse: newValue!);

                      userBloc.getTerm(currentTermIndex).updateSubjects();

                      userBloc.updateData();
                    },
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ],
    );
  }

  void _showKeyboardAction() {
    userBloc.updateIsShowingKeyboard(true);
  }

  void _buildSelectGradeSheet({
    required BuildContext context,
    required int currentTermIndex,
    required int currentIndex,
    required Grade currentGradeType,
    required TapPosition position,
  }) {
    gradeCalculatorBloc.updateShowingGradeSelector(true);
    userBloc.updateIsShowingKeyboard(false);

    if (position.global.dy >=
        (availableHeight - CustomPickerModalBottomSheet.sheetHeight)) {
      Future.delayed(
        const Duration(milliseconds: 350),
        () {
          listScrollController.animateTo(
            (position.global.dy -
                (availableHeight - CustomPickerModalBottomSheet.sheetHeight) +
                listScrollController.offset),
            duration: const Duration(milliseconds: 200),
            curve: Curves.linear,
          );
        },
      );
    }

    showModalBottomSheet(
      elevation: 0,
      barrierColor: Colors.transparent,
      isDismissible: true,
      enableDrag: false,
      context: context,
      builder: (popupContext) {
        int selected = Grade.indexOfGrade(currentGradeType);
        return CustomPickerModalBottomSheet(
          title: '성적을 선택해주세요',
          onPressedCancel: () {
            Navigator.pop(popupContext);
          },
          onPressedSave: () {
            userBloc.getTerm(currentTermIndex).updateSubject(
                  currentIndex - 1,
                  courseGrade: Grade.getByIndex(selected),
                  isPassFail:
                      (Grade.getByIndex(selected) == Grade.P) ? true : null,
                );
            userBloc.updateData();

            Navigator.pop(popupContext);
          },
          picker: CupertinoPicker(
            itemExtent: availableHeight * 0.05,
            scrollController: FixedExtentScrollController(
              initialItem: Grade.indexOfGrade(currentGradeType),
            ),
            children: List.generate(
              11,
              (index) {
                return Center(
                  child: Text(Grade.gradeLabelAtIndex(index)),
                );
              },
            ),
            onSelectedItemChanged: (index) {
              selected = index;
            },
          ),
        );
      },
    ).whenComplete(() {
      gradeCalculatorBloc.updateShowingGradeSelector(false);
      gradeCalculatorBloc.updateSelectingGradeIndex(null);
    });
  }
}
