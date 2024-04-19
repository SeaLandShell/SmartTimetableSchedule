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

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  UserDao get userDao {
    return _userDaoInstance ??= _$UserDao(database, changeListener);
  }
}

class _$UserDao extends UserDao {
  _$UserDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
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
                },
            changeListener),
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
                },
            changeListener),
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
                },
            changeListener);

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
  Stream<UserDb?> findUserById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM UserDb WHERE userId = ?1',
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
        arguments: [id],
        queryableName: 'UserDb',
        isView: false);
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
