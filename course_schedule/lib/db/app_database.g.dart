// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  UserDao? _userDaoInstance;

  ScheduleDao? _scheduleDaoInstance;

  MemberDao? _memberDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `UserDb` (`createBy` TEXT, `createTime` TEXT, `updateBy` TEXT, `updateTime` TEXT, `remark` TEXT, `userId` INTEGER, `deptId` INTEGER, `userName` TEXT, `nickName` TEXT, `password` TEXT, `userType` TEXT, `email` TEXT, `phonenumber` TEXT, `stuTuNumber` TEXT, `sex` TEXT, `avatar` TEXT, `birthday` TEXT, `status` TEXT, `delFlag` TEXT, `loginIp` TEXT, `loginDate` TEXT, PRIMARY KEY (`userId`, `phonenumber`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Schedule` (`courseId` TEXT, `courseNum` TEXT, `courseName` TEXT, `coursePic` TEXT, `clazzName` TEXT, `term` TEXT, `synopsis` TEXT, `arrivesNum` INTEGER, `resourcesNum` INTEGER, `experiencesNum` INTEGER, `appraise` INTEGER, `teacherId` INTEGER, `teacherName` TEXT, `id` INTEGER, `gmtCreate` TEXT, `gmtModified` TEXT, PRIMARY KEY (`courseId`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Member` (`userId` INTEGER, `courseId` TEXT, `arrive` INTEGER, `resource` INTEGER, `experience` INTEGER, `score` INTEGER, `remark` TEXT, `id` INTEGER, `gmtCreate` TEXT, `gmtModified` TEXT, PRIMARY KEY (`userId`, `courseId`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  UserDao get userDao {
    return _userDaoInstance ??= _$UserDao(database, changeListener);
  }

  @override
  ScheduleDao get scheduleDao {
    return _scheduleDaoInstance ??= _$ScheduleDao(database, changeListener);
  }

  @override
  MemberDao get memberDao {
    return _memberDaoInstance ??= _$MemberDao(database, changeListener);
  }
}

class _$UserDao extends UserDao {
  _$UserDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _userDbInsertionAdapter = InsertionAdapter(
            database,
            'UserDb',
            (UserDb item) => <String, Object?>{
                  'createBy': item.createBy,
                  'createTime': item.createTime,
                  'updateBy': item.updateBy,
                  'updateTime': item.updateTime,
                  'remark': item.remark,
                  'userId': item.userId,
                  'deptId': item.deptId,
                  'userName': item.userName,
                  'nickName': item.nickName,
                  'password': item.password,
                  'userType': item.userType,
                  'email': item.email,
                  'phonenumber': item.phonenumber,
                  'stuTuNumber': item.stuTuNumber,
                  'sex': item.sex,
                  'avatar': item.avatar,
                  'birthday': item.birthday,
                  'status': item.status,
                  'delFlag': item.delFlag,
                  'loginIp': item.loginIp,
                  'loginDate': item.loginDate
                }),
        _userDbUpdateAdapter = UpdateAdapter(
            database,
            'UserDb',
            ['userId', 'phonenumber'],
            (UserDb item) => <String, Object?>{
                  'createBy': item.createBy,
                  'createTime': item.createTime,
                  'updateBy': item.updateBy,
                  'updateTime': item.updateTime,
                  'remark': item.remark,
                  'userId': item.userId,
                  'deptId': item.deptId,
                  'userName': item.userName,
                  'nickName': item.nickName,
                  'password': item.password,
                  'userType': item.userType,
                  'email': item.email,
                  'phonenumber': item.phonenumber,
                  'stuTuNumber': item.stuTuNumber,
                  'sex': item.sex,
                  'avatar': item.avatar,
                  'birthday': item.birthday,
                  'status': item.status,
                  'delFlag': item.delFlag,
                  'loginIp': item.loginIp,
                  'loginDate': item.loginDate
                }),
        _userDbDeletionAdapter = DeletionAdapter(
            database,
            'UserDb',
            ['userId', 'phonenumber'],
            (UserDb item) => <String, Object?>{
                  'createBy': item.createBy,
                  'createTime': item.createTime,
                  'updateBy': item.updateBy,
                  'updateTime': item.updateTime,
                  'remark': item.remark,
                  'userId': item.userId,
                  'deptId': item.deptId,
                  'userName': item.userName,
                  'nickName': item.nickName,
                  'password': item.password,
                  'userType': item.userType,
                  'email': item.email,
                  'phonenumber': item.phonenumber,
                  'stuTuNumber': item.stuTuNumber,
                  'sex': item.sex,
                  'avatar': item.avatar,
                  'birthday': item.birthday,
                  'status': item.status,
                  'delFlag': item.delFlag,
                  'loginIp': item.loginIp,
                  'loginDate': item.loginDate
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<UserDb> _userDbInsertionAdapter;

  final UpdateAdapter<UserDb> _userDbUpdateAdapter;

  final DeletionAdapter<UserDb> _userDbDeletionAdapter;

  @override
  Future<List<UserDb>> findAllUsers() async {
    return _queryAdapter.queryList('SELECT * FROM UserDb',
        mapper: (Map<String, Object?> row) => UserDb(
            createBy: row['createBy'] as String?,
            createTime: row['createTime'] as String?,
            updateBy: row['updateBy'] as String?,
            updateTime: row['updateTime'] as String?,
            remark: row['remark'] as String?,
            userId: row['userId'] as int?,
            deptId: row['deptId'] as int?,
            userName: row['userName'] as String?,
            nickName: row['nickName'] as String?,
            password: row['password'] as String?,
            userType: row['userType'] as String?,
            email: row['email'] as String?,
            phonenumber: row['phonenumber'] as String?,
            stuTuNumber: row['stuTuNumber'] as String?,
            sex: row['sex'] as String?,
            avatar: row['avatar'] as String?,
            birthday: row['birthday'] as String?,
            status: row['status'] as String?,
            delFlag: row['delFlag'] as String?,
            loginIp: row['loginIp'] as String?,
            loginDate: row['loginDate'] as String?));
  }

  @override
  Future<UserDb?> findUserById(int id) async {
    return _queryAdapter.query('SELECT * FROM UserDb WHERE userId = ?1',
        mapper: (Map<String, Object?> row) => UserDb(
            createBy: row['createBy'] as String?,
            createTime: row['createTime'] as String?,
            updateBy: row['updateBy'] as String?,
            updateTime: row['updateTime'] as String?,
            remark: row['remark'] as String?,
            userId: row['userId'] as int?,
            deptId: row['deptId'] as int?,
            userName: row['userName'] as String?,
            nickName: row['nickName'] as String?,
            password: row['password'] as String?,
            userType: row['userType'] as String?,
            email: row['email'] as String?,
            phonenumber: row['phonenumber'] as String?,
            stuTuNumber: row['stuTuNumber'] as String?,
            sex: row['sex'] as String?,
            avatar: row['avatar'] as String?,
            birthday: row['birthday'] as String?,
            status: row['status'] as String?,
            delFlag: row['delFlag'] as String?,
            loginIp: row['loginIp'] as String?,
            loginDate: row['loginDate'] as String?),
        arguments: [id]);
  }

  @override
  Future<UserDb?> findUserByPhoneNumber(String phoneNumber) async {
    return _queryAdapter.query('SELECT * FROM UserDb WHERE phonenumber = ?1',
        mapper: (Map<String, Object?> row) => UserDb(
            createBy: row['createBy'] as String?,
            createTime: row['createTime'] as String?,
            updateBy: row['updateBy'] as String?,
            updateTime: row['updateTime'] as String?,
            remark: row['remark'] as String?,
            userId: row['userId'] as int?,
            deptId: row['deptId'] as int?,
            userName: row['userName'] as String?,
            nickName: row['nickName'] as String?,
            password: row['password'] as String?,
            userType: row['userType'] as String?,
            email: row['email'] as String?,
            phonenumber: row['phonenumber'] as String?,
            stuTuNumber: row['stuTuNumber'] as String?,
            sex: row['sex'] as String?,
            avatar: row['avatar'] as String?,
            birthday: row['birthday'] as String?,
            status: row['status'] as String?,
            delFlag: row['delFlag'] as String?,
            loginIp: row['loginIp'] as String?,
            loginDate: row['loginDate'] as String?),
        arguments: [phoneNumber]);
  }

  @override
  Future<int?> findUserCountByPhoneNumber(String phoneNumber) async {
    return _queryAdapter.query(
        'SELECT count(*) FROM UserDb WHERE phonenumber = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [phoneNumber]);
  }

  @override
  Future<void> insertUser(UserDb user) async {
    await _userDbInsertionAdapter.insert(user, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateUser(UserDb user) async {
    await _userDbUpdateAdapter.update(user, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteUser(UserDb user) async {
    await _userDbDeletionAdapter.delete(user);
  }
}

class _$ScheduleDao extends ScheduleDao {
  _$ScheduleDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _scheduleInsertionAdapter = InsertionAdapter(
            database,
            'Schedule',
            (Schedule item) => <String, Object?>{
                  'courseId': item.courseId,
                  'courseNum': item.courseNum,
                  'courseName': item.courseName,
                  'coursePic': item.coursePic,
                  'clazzName': item.clazzName,
                  'term': item.term,
                  'synopsis': item.synopsis,
                  'arrivesNum': item.arrivesNum,
                  'resourcesNum': item.resourcesNum,
                  'experiencesNum': item.experiencesNum,
                  'appraise':
                      item.appraise == null ? null : (item.appraise! ? 1 : 0),
                  'teacherId': item.teacherId,
                  'teacherName': item.teacherName,
                  'id': item.id,
                  'gmtCreate': item.gmtCreate,
                  'gmtModified': item.gmtModified
                }),
        _scheduleUpdateAdapter = UpdateAdapter(
            database,
            'Schedule',
            ['courseId'],
            (Schedule item) => <String, Object?>{
                  'courseId': item.courseId,
                  'courseNum': item.courseNum,
                  'courseName': item.courseName,
                  'coursePic': item.coursePic,
                  'clazzName': item.clazzName,
                  'term': item.term,
                  'synopsis': item.synopsis,
                  'arrivesNum': item.arrivesNum,
                  'resourcesNum': item.resourcesNum,
                  'experiencesNum': item.experiencesNum,
                  'appraise':
                      item.appraise == null ? null : (item.appraise! ? 1 : 0),
                  'teacherId': item.teacherId,
                  'teacherName': item.teacherName,
                  'id': item.id,
                  'gmtCreate': item.gmtCreate,
                  'gmtModified': item.gmtModified
                }),
        _scheduleDeletionAdapter = DeletionAdapter(
            database,
            'Schedule',
            ['courseId'],
            (Schedule item) => <String, Object?>{
                  'courseId': item.courseId,
                  'courseNum': item.courseNum,
                  'courseName': item.courseName,
                  'coursePic': item.coursePic,
                  'clazzName': item.clazzName,
                  'term': item.term,
                  'synopsis': item.synopsis,
                  'arrivesNum': item.arrivesNum,
                  'resourcesNum': item.resourcesNum,
                  'experiencesNum': item.experiencesNum,
                  'appraise':
                      item.appraise == null ? null : (item.appraise! ? 1 : 0),
                  'teacherId': item.teacherId,
                  'teacherName': item.teacherName,
                  'id': item.id,
                  'gmtCreate': item.gmtCreate,
                  'gmtModified': item.gmtModified
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Schedule> _scheduleInsertionAdapter;

  final UpdateAdapter<Schedule> _scheduleUpdateAdapter;

  final DeletionAdapter<Schedule> _scheduleDeletionAdapter;

  @override
  Future<List<Schedule>> findAllSchedule() async {
    return _queryAdapter.queryList('SELECT * FROM Schedule',
        mapper: (Map<String, Object?> row) => Schedule(
            courseId: row['courseId'] as String?,
            courseNum: row['courseNum'] as String?,
            courseName: row['courseName'] as String?,
            coursePic: row['coursePic'] as String?,
            clazzName: row['clazzName'] as String?,
            term: row['term'] as String?,
            synopsis: row['synopsis'] as String?,
            arrivesNum: row['arrivesNum'] as int?,
            resourcesNum: row['resourcesNum'] as int?,
            experiencesNum: row['experiencesNum'] as int?,
            appraise:
                row['appraise'] == null ? null : (row['appraise'] as int) != 0,
            teacherId: row['teacherId'] as int?,
            teacherName: row['teacherName'] as String?,
            id: row['id'] as int?,
            gmtCreate: row['gmtCreate'] as String?,
            gmtModified: row['gmtModified'] as String?));
  }

  @override
  Future<Schedule?> findScheduleById(String id) async {
    return _queryAdapter.query('SELECT * FROM Schedule WHERE courseId = ?1',
        mapper: (Map<String, Object?> row) => Schedule(
            courseId: row['courseId'] as String?,
            courseNum: row['courseNum'] as String?,
            courseName: row['courseName'] as String?,
            coursePic: row['coursePic'] as String?,
            clazzName: row['clazzName'] as String?,
            term: row['term'] as String?,
            synopsis: row['synopsis'] as String?,
            arrivesNum: row['arrivesNum'] as int?,
            resourcesNum: row['resourcesNum'] as int?,
            experiencesNum: row['experiencesNum'] as int?,
            appraise:
                row['appraise'] == null ? null : (row['appraise'] as int) != 0,
            teacherId: row['teacherId'] as int?,
            teacherName: row['teacherName'] as String?,
            id: row['id'] as int?,
            gmtCreate: row['gmtCreate'] as String?,
            gmtModified: row['gmtModified'] as String?),
        arguments: [id]);
  }

  @override
  Future<Schedule?> findScheduleByCourseNum(String courseNum) async {
    return _queryAdapter.query('SELECT * FROM Schedule WHERE courseNum = ?1',
        mapper: (Map<String, Object?> row) => Schedule(
            courseId: row['courseId'] as String?,
            courseNum: row['courseNum'] as String?,
            courseName: row['courseName'] as String?,
            coursePic: row['coursePic'] as String?,
            clazzName: row['clazzName'] as String?,
            term: row['term'] as String?,
            synopsis: row['synopsis'] as String?,
            arrivesNum: row['arrivesNum'] as int?,
            resourcesNum: row['resourcesNum'] as int?,
            experiencesNum: row['experiencesNum'] as int?,
            appraise:
                row['appraise'] == null ? null : (row['appraise'] as int) != 0,
            teacherId: row['teacherId'] as int?,
            teacherName: row['teacherName'] as String?,
            id: row['id'] as int?,
            gmtCreate: row['gmtCreate'] as String?,
            gmtModified: row['gmtModified'] as String?),
        arguments: [courseNum]);
  }

  @override
  Future<int?> findScheduleCountByCourseNum(String courseNum) async {
    return _queryAdapter.query(
        'SELECT count(*) FROM Schedule WHERE courseNum = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [courseNum]);
  }

  @override
  Future<void> insertSchedule(Schedule schedule) async {
    await _scheduleInsertionAdapter.insert(
        schedule, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateSchedule(Schedule schedule) async {
    await _scheduleUpdateAdapter.update(schedule, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteSchedule(Schedule schedule) async {
    await _scheduleDeletionAdapter.delete(schedule);
  }
}

class _$MemberDao extends MemberDao {
  _$MemberDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _memberInsertionAdapter = InsertionAdapter(
            database,
            'Member',
            (Member item) => <String, Object?>{
                  'userId': item.userId,
                  'courseId': item.courseId,
                  'arrive': item.arrive,
                  'resource': item.resource,
                  'experience': item.experience,
                  'score': item.score,
                  'remark': item.remark,
                  'id': item.id,
                  'gmtCreate': item.gmtCreate,
                  'gmtModified': item.gmtModified
                }),
        _memberUpdateAdapter = UpdateAdapter(
            database,
            'Member',
            ['userId', 'courseId'],
            (Member item) => <String, Object?>{
                  'userId': item.userId,
                  'courseId': item.courseId,
                  'arrive': item.arrive,
                  'resource': item.resource,
                  'experience': item.experience,
                  'score': item.score,
                  'remark': item.remark,
                  'id': item.id,
                  'gmtCreate': item.gmtCreate,
                  'gmtModified': item.gmtModified
                }),
        _memberDeletionAdapter = DeletionAdapter(
            database,
            'Member',
            ['userId', 'courseId'],
            (Member item) => <String, Object?>{
                  'userId': item.userId,
                  'courseId': item.courseId,
                  'arrive': item.arrive,
                  'resource': item.resource,
                  'experience': item.experience,
                  'score': item.score,
                  'remark': item.remark,
                  'id': item.id,
                  'gmtCreate': item.gmtCreate,
                  'gmtModified': item.gmtModified
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Member> _memberInsertionAdapter;

  final UpdateAdapter<Member> _memberUpdateAdapter;

  final DeletionAdapter<Member> _memberDeletionAdapter;

  @override
  Future<List<Member>> findAllMember() async {
    return _queryAdapter.queryList('SELECT * FROM Member',
        mapper: (Map<String, Object?> row) => Member(
            userId: row['userId'] as int?,
            courseId: row['courseId'] as String?,
            arrive: row['arrive'] as int?,
            resource: row['resource'] as int?,
            experience: row['experience'] as int?,
            score: row['score'] as int?,
            remark: row['remark'] as String?,
            id: row['id'] as int?,
            gmtCreate: row['gmtCreate'] as String?,
            gmtModified: row['gmtModified'] as String?));
  }

  @override
  Future<Member?> findMemberById(
    String userId,
    String courseId,
  ) async {
    return _queryAdapter.query(
        'SELECT * FROM Member WHERE userId = ?1 and courseId = ?2',
        mapper: (Map<String, Object?> row) => Member(
            userId: row['userId'] as int?,
            courseId: row['courseId'] as String?,
            arrive: row['arrive'] as int?,
            resource: row['resource'] as int?,
            experience: row['experience'] as int?,
            score: row['score'] as int?,
            remark: row['remark'] as String?,
            id: row['id'] as int?,
            gmtCreate: row['gmtCreate'] as String?,
            gmtModified: row['gmtModified'] as String?),
        arguments: [userId, courseId]);
  }

  @override
  Future<void> insertMember(Member Member) async {
    await _memberInsertionAdapter.insert(Member, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateMember(Member Member) async {
    await _memberUpdateAdapter.update(Member, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteMember(Member Member) async {
    await _memberDeletionAdapter.delete(Member);
  }
}
