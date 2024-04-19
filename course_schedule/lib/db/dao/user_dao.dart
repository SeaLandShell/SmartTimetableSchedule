// user_dao.dart
import 'package:floor/floor.dart';
import '../domain/user_db.dart';

@dao
abstract class UserDao {
  // 查询所有用户
  @Query('SELECT * FROM UserDb')
  Future<List<UserDb>> findAllUsers();

  // 根据ID查询用户
  @Query('SELECT * FROM UserDb WHERE userId = :id')
  Stream<UserDb?> findUserById(int id);

  // 插入用户
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertUser(UserDb user);

  // 删除用户
  @delete
  Future<void> deleteUser(UserDb user);

  // 更新用户信息
  @update
  Future<void> updateUser(UserDb user);

  // 根据手机号查询用户
  @Query('SELECT * FROM UserDb WHERE phonenumber = :phoneNumber')
  Future<UserDb?> findUserByPhoneNumber(String phoneNumber);

  @Query("SELECT count(*) FROM UserDb WHERE phonenumber = :phoneNumber")
  Future<int?> findUserCountByPhoneNumber(String phoneNumber);

}
