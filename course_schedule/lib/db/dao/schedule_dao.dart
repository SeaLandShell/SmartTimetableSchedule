// user_dao.dart
import 'package:course_schedule/model/index.dart';
import 'package:floor/floor.dart';
import '../domain/user_db.dart';

@dao
abstract class ScheduleDao {
  // 查询所有用户
  @Query('SELECT * FROM Schedule')
  Future<List<Schedule>> findAllSchedule();

  @Query('SELECT * FROM Schedule WHERE courseId = :id')
  Future<Schedule?> findScheduleById(String id);

  // 插入用户
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertSchedule(Schedule schedule);

  // 删除用户
  @delete
  Future<void> deleteSchedule(Schedule schedule);

  // 更新用户信息
  @update
  Future<void> updateSchedule(Schedule schedule);

  // 根据手机号查询用户
  @Query('SELECT * FROM Schedule WHERE courseNum = :courseNum')
  Future<Schedule?> findScheduleByCourseNum(String courseNum);

  @Query("SELECT count(*) FROM Schedule WHERE courseNum = :courseNum")
  Future<int?> findScheduleCountByCourseNum(String courseNum);

}
