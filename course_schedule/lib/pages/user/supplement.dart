import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;


import '../../db/app_database.dart';
import '../../db/dao/user_dao.dart';
import '../../db/domain/user_db.dart';
import '../../net/globalVariables.dart';
import '../../provider/user_provider.dart';
import '../../utils/dialog_util.dart';
import '../../utils/util.dart';

class SupplementPage extends StatefulWidget {
  const SupplementPage({Key? key}) : super(key: key);

  @override
  State<SupplementPage> createState() => _SupplementPageState();
}

class _SupplementPageState extends State<SupplementPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // 创建一个全局表单键，用于表单验证和数据保存
  static String baseUrl = GlobalVariables.instance.baseUrl;
  static String ip = GlobalVariables.instance.ip;
  late UserDao userDao; // 用户数据库操作对象
  UserDb _user=UserDb();
  File? _imageFile;
  TextEditingController _nameController = TextEditingController(); // 用于姓名输入字段的控制器
  TextEditingController _nickNameController = TextEditingController(); // 用于昵称输入字段的控制器
  TextEditingController _stuNumController = TextEditingController(); // 用于学号/工号输入字段的控制器
  TextEditingController _emailController = TextEditingController(); // 用于邮箱输入字段的控制器
  TextEditingController _birthdayController = TextEditingController(); // 用于生日输入字段的控制器
  late Future<String> phonenum;
  String _selectedGender = '男'; // 存储选择的性别，默认为“男性”
  late String _selectedDepartment; // 用于存储选择的院系，默认为空字符串
  String _avatar = ''; // 用于存储头像路径或 URL
  String phoneNumber='';

  final List<String> _departments = [
    "智慧计算机2001B2",
    "智慧计算机2001B1",
    "管理会计2001B1",
  ];

  int _selectedDepartmentIndex = 0; // 用于存储选择的院系的索引值，默认为 0

  @override
  void initState() {
    super.initState();
    _selectedDepartment = _departments.first;
    phonenum=_loadPrefs();
    _loadUserData(); // 加载用户数据
  }

  Future<String> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance(); // 获取共享偏好实例
    return prefs.getString('phoneNumber') ?? ''; // 返回存储的手机号码，如果为空则返回空字符串
  }

  Future<void> _loadUserData() async {
    phoneNumber=await _loadPrefs() ?? '';
    // 获取UserProvider实例
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    // 设置控制器的初始值
    _nameController.text = userProvider.name ?? '';
    _selectedGender = _user.sex == '1' ? '女' : _user.sex == '0' ? '男' : '男';
    // _selectedDepartmentIndex = _departments.indexOf(_user.deptId as String); // 获取院系索引值
    _selectedDepartmentIndex = _user.deptId??0;
    _selectedDepartment = _departments[_selectedDepartmentIndex]; // 根据索引值获取院系名称
    setState(() {
      _avatar= userProvider.userIcon??'';
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final File file = File(pickedFile.path);
      final url = Uri.parse('$baseUrl/acuser/acuser/avatar?phone=$phoneNumber');
      final request = http.MultipartRequest('POST', url)
        ..files.add(await http.MultipartFile.fromPath('file', file.path))
        ..headers.addAll(GlobalVariables.instance.headers); // 添加全局headers
      final response = await http.Response.fromStream(await request.send());
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if(responseData['code']==500){
          String msg=utf8.decode(responseData['msg'].runes.toList());
          _showSnackBar(context,msg);
          return;
        }
        // 更新头像组件中的图片
        setState(() {
          _avatar= responseData['data']['avatar'];
          print('avatar:$_avatar');
        });
      } else {
        throw Exception('Failed to upload image');
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('完善个人信息'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey, // 使用全局表单键与表单绑定
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: _pickImage, // 点击头像区域触发选择图片操作
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _avatar.isNotEmpty ? NetworkImage(_avatar) : null,
                  child: _avatar.isEmpty ? const Icon(Icons.add_a_photo, size: 40) : null,
                ),
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: '姓名'),
                validator: RequiredValidator(errorText: '请输入姓名'),
              ),
              const SizedBox(height: 10.0),
              DropdownButtonFormField<String>(
                value: _selectedGender,
                onChanged: (newValue) {
                  setState(() {
                    _selectedGender = newValue!;
                  });
                },
                items: ['男', '女'].map((gender) => DropdownMenuItem(value: gender, child: Text(gender))).toList(),
                decoration: const InputDecoration(labelText: '性别'),
                validator: RequiredValidator(errorText: '请选择性别'),
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                controller: _nickNameController,
                decoration: const InputDecoration(labelText: '昵称'),
                validator: RequiredValidator(errorText: '请输入昵称'),
              ),
              const SizedBox(height: 10.0),
              DropdownButtonFormField<String>(
                value: _selectedDepartment,
                onChanged: (newValue) {
                  setState(() {
                    _selectedDepartment = newValue!;
                    _selectedDepartmentIndex = _departments.indexOf(newValue); // 更新选择的院系索引值
                  });
                },
                items: _departments.map((dept) => DropdownMenuItem(value: dept, child: Text(dept))).toList(),
                decoration: const InputDecoration(labelText: '院系'),
                validator: RequiredValidator(errorText: '请选择院系'),
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                controller: _stuNumController,
                decoration: const InputDecoration(labelText: '学工号'),
                validator: RequiredValidator(errorText: '请输入学工号'),
              ),
              const SizedBox(height: 10.0),
          FutureBuilder<String>(
            future: phonenum,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                String phoneNumber=snapshot.data!;
                return TextFormField(
                  initialValue: phoneNumber,
                  readOnly: true,
                  decoration: const InputDecoration(labelText: '手机号'),
                  onChanged: (value) {
                    print('用户手机号: $value');
                  },
                );
              }
              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          ),

              const SizedBox(height: 10.0),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: '邮箱'),
                validator:MultiValidator([
                  EmailValidator(errorText: '请输入有效的电子邮件地址'),
                  RequiredValidator(errorText: '请输入邮箱号'),
                ]).call,
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                controller: _birthdayController,
                decoration: const InputDecoration(labelText: '生日'),
                validator: RequiredValidator(errorText: '请输入生日'),
                onTap: () async {
                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _birthdayController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                    });
                  }
                },
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _saveUserData(context); // 表单验证通过后保存用户数据
                  }
                },
                child: const Text('保存'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveUserData(BuildContext context) async {
    var database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    userDao = database.userDao;
    _user.userName = _nameController.text;
    _user.nickName = _nickNameController.text;
    _user.stuTuNumber = _stuNumController.text;
    _user.phonenumber=phoneNumber;
    _user.email = _emailController.text;
    _user.birthday = _birthdayController.text;
    _user.sex = _selectedGender;
    _user.deptId = _departments.indexOf(_selectedDepartment); // 更新存储的院系为对应的名称
    _user.avatar = _avatar;
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.updateLoginState(
      true,
      _user.userName??'',
      _user.avatar??'',
    );
    final response=await http.put(
      Uri.parse('$baseUrl/acuser/acuser/edit'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': GlobalVariables.instance.access_token,
      },
      body: jsonEncode(_user.toJson()),
    );
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final dynamic data = responseData['data'];
      // 插入更新好的用户数据
      await userDao.insertUser(UserDb.fromJson(data));
      print('先依据provider显示信息，并更新信息和provider，更新远程数据库并存储于本地：${(await userDao.findUserByPhoneNumber(phoneNumber))?.toJson()}');
      Util.showToastCourse("用户数据保存成功",context);
      Navigator.pushNamed(context, '/tabs'); // 导航到指定的页面
    }
  }
  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 1), // 设置持续时间为3秒
      ),
    );
  }
}
