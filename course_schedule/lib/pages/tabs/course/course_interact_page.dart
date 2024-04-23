import 'package:course_schedule/pages/tabs/plan/today_course.dart';
import 'package:add_calendar_event/add_calendar_event.dart'; // 导入添加日历事件的库
import 'package:flutter/material.dart';

import '../../../components/card_view.dart';
import '../../../components/clipper/bottom_curve_clipper.dart';
import '../../../components/item_button.dart';
import '../../../data/values.dart';
import '../../../model/schedule.dart';
import '../../../provider/store.dart';
import '../../../utils/device_type.dart';
import '../../../utils/dialog_util.dart';
import '../../../utils/util.dart';

class CourseInteractPage extends StatefulWidget {
  final Schedule schedule;
  const CourseInteractPage({super.key,required this.schedule});

  @override
  State<CourseInteractPage> createState() => _CourseInteractPageState();
}

class _CourseInteractPageState extends State<CourseInteractPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(

        padding: EdgeInsets.all(20.0),
      ),
    );
  }
}
