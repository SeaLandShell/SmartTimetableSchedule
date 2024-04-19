import 'package:floor/floor.dart';

import 'app_database.dart';

// 数据库提供者类
class DatabaseProvider {
  // 单例模式，_instance为唯一实例
  static final DatabaseProvider _instance = DatabaseProvider._();

  // 数据库实例
  late AppDatabase _database;

  // 工厂构造函数
  factory DatabaseProvider() {
    return _instance;
  }

  // 私有构造函数
  DatabaseProvider._();

  // 初始化数据库
  Future<void> initializeDatabase() async {
    // 使用Floor库的方法构建数据库实例
    _database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  }

  // 获取数据库实例
  AppDatabase get database {
    return _database;
  }
}
