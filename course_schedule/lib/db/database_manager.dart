import 'package:course_schedule/db/app_database.dart';
import 'package:course_schedule/db/domain/user_db.dart';

import '../model/member.dart';
import '../model/schedule.dart';
import 'dao/schedule_dao.dart';

class DataBaseManager {
  DataBaseManager._();
  static Future<AppDatabase> database() async {
    // 关键
    // $FloorMyDataBase是生成的类 名称为$Floor+你创建的数据库类名字
    final database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    return database;
  }

  /// 查询
  static Future<List<UserDb>> queryAllUser() async {
    var myDataBase = await database();
    return myDataBase.userDao.findAllUsers();
  }

  /// 根据Id查询
  static Future<UserDb?> queryUserById(int userId) async {
    var myDataBase = await database();
    return myDataBase.userDao.findUserById(userId);
  }

  /// 插入
  static Future<void> insertUser(UserDb user) async {
    var myDataBase = await database();
    return await myDataBase.userDao.insertUser(user);
  }

  /// 更新 返回[int] 表示受影响的行数
  static Future<void> updateUser(UserDb user) async {
    var myDataBase = await database();
    return await myDataBase.userDao.updateUser(user);
  }

  /// 删除 返回[int] 表示受影响的行数
  static Future<void> deleteUser(UserDb user) async {
    var myDataBase = await database();
    return await myDataBase.userDao.deleteUser(user);
  }


  /// 查询
  static Future<List<Schedule>> queryAllSchedule() async {
    var myDataBase = await database();
    return myDataBase.scheduleDao.findAllSchedule();
  }

  /// 根据Id查询
  static Future<Schedule?> queryScheduleById(String courseId) async {
    var myDataBase = await database();
    return myDataBase.scheduleDao.findScheduleById(courseId);
  }

  /// 插入
  static Future<void> insertSchedule(Schedule schedule) async {
    var myDataBase = await database();
    return await myDataBase.scheduleDao.insertSchedule(schedule);
  }

  /// 更新 返回[int] 表示受影响的行数
  static Future<void> updateSchedule(Schedule schedule) async {
    var myDataBase = await database();
    return await myDataBase.scheduleDao.updateSchedule(schedule);
  }

  /// 删除 返回[int] 表示受影响的行数
  static Future<void> deleteSchedule(Schedule schedule) async {
    var myDataBase = await database();
    return await myDataBase.scheduleDao.deleteSchedule(schedule);
  }
  static Future<Schedule?> findScheduleByCourseNum(String courseNum) async {
    var myDataBase = await database();
    return await myDataBase.scheduleDao.findScheduleByCourseNum(courseNum);
  }

  static Future<Member?> findMemberByUserIdCourseId(String userId,String courseId) async {
    var myDataBase = await database();
    return await myDataBase.memberDao.findMemberById(userId,courseId);
  }
  static Future<void> insertMember(Member member) async {
    var myDataBase = await database();
    return await myDataBase.memberDao.insertMember(member);
  }
  
}