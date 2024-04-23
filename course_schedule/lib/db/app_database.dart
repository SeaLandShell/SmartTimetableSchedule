import 'dart:async';
import 'package:course_schedule/db/dao/member_dao.dart';
import 'package:course_schedule/db/dao/schedule_dao.dart';
import 'package:course_schedule/model/index.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'package:floor/floor.dart';

import 'dao/user_dao.dart';
import 'domain/user_db.dart';


part 'app_database.g.dart'; // 生成的代码会在那里

@Database(version: 1, entities: [UserDb,Schedule,Member])
abstract class AppDatabase extends FloorDatabase {
  UserDao get userDao;
  ScheduleDao get scheduleDao;
  MemberDao get memberDao;
}