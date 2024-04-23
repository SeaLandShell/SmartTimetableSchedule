// user_dao.dart
import 'package:floor/floor.dart';
import '../../model/member.dart';

@dao
abstract class MemberDao {
  // 查询所有用户
  @Query('SELECT * FROM Member')
  Future<List<Member>> findAllMember();

  @Query('SELECT * FROM Member WHERE userId = :userId and courseId = :courseId')
  Future<Member?> findMemberById(String userId,String courseId);

  // 插入用户
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertMember(Member Member);

  // 删除用户
  @delete
  Future<void> deleteMember(Member Member);

  // 更新用户信息
  @update
  Future<void> updateMember(Member Member);

}
