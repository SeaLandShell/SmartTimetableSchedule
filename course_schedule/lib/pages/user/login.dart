import 'dart:convert';
import 'dart:typed_data';
import 'package:course_schedule/utils/shared_preferences_util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/token_repository.dart';
import '../../db/app_database.dart';
import '../../db/domain/user_db.dart';
import '../../model/code.dart';
import '../../model/user.dart';
import '../../net/apiClient.dart';
import '../../provider/user_provider.dart';
import '../../utils/util.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}


class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // 全局表单状态的 key，用于验证表单和保存表单数据
  final TextEditingController _phoneController = TextEditingController(); // 手机号输入框的控制器
  final TextEditingController _passwordController = TextEditingController(); // 密码输入框的控制器
  final TextEditingController _imgVerificateController = TextEditingController(); // 密码输入框的控制器
  String _uuid=''; // 存储验证码的UUID
  ApiClient apiClient=ApiClient();
  late Future<Code> code;
  late Future<User> user;
  static const double externalHeight = 10.0;
  bool _isObscure = true; // 控制密码显示

  // Function to fetch new code
  Future<void> _refreshCode() async {
    setState(() {
      code = apiClient.fetchCode();
    });
  }

  @override
  void initState() {
    super.initState();
    _uuid = ''; // 初始化_uuid变量
    code=apiClient.fetchCode();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          '便利课表堂', // 页面标题
          style: TextStyle(
            color: Colors.blue, // 标题颜色
            fontFamily: "Courier", // 标题字体
          ),
        ),
        centerTitle: false, // 标题靠左
      ),
      body:SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SafeArea( // 使用 SafeArea 处理安全区域
          child: Container(
            height: MediaQuery.of(context).size.height - AppBar().preferredSize.height, // 减去AppBar高度
            decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.blue.withOpacity(0.2),
                Colors.blue.withOpacity(0.5),
              ],
            ),
          ),
          padding: const EdgeInsets.all(20.0),
          child: Form( // 表单
            key: _formKey, // 绑定全局表单状态的 key
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 40.0), // 顶部间距
                const Text(
                  'Welcome Login!', // 欢迎文本
                  style: TextStyle(
                    fontSize: 35.0, // 文本大小
                    fontWeight: FontWeight.bold, // 加粗
                    color: Colors.black, // 文本颜色
                  ),
                ),
                SizedBox(height: 10.0), // 文本间距
                const Text(
                  '欢迎登录便利课表堂', // 说明文本
                  style: TextStyle(
                    fontSize: 12.0, // 文本大小
                    color: Colors.black, // 文本颜色
                  ),
                ),
                const SizedBox(height: externalHeight), // 间距
                TextFormField( // 手机号输入框
                  controller: _phoneController, // 控制手机号输入框的文本
                  decoration: const InputDecoration(
                    labelText: '手机号', // 输入框标签
                    prefixIcon: Icon(Icons.phone), // 输入框前缀图标
                  ),
                  validator: (value) { // 验证器：检查输入是否合法
                    if (value == null || value.isEmpty) { // 如果输入为空
                      return '请输入11位手机号'; // 提示用户输入手机号
                    }else if (value.length != 11 || !RegExp(r'^[0-9]*$').hasMatch(value)) {
                      return '手机号必须是11位数字';
                    }
                    return null; // 输入合法，返回 null
                  },
                ),
                const SizedBox(height: externalHeight), // 间距 // 输入框前缀图标
                TextFormField( // 密码输入框
                  controller: _passwordController, // 控制密码输入框的文本
                  decoration: InputDecoration(
                    labelText: '密码',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(_isObscure ? Icons.visibility : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _isObscure = !_isObscure;
                        });
                      },
                    ),
                  ),
                  obscureText: _isObscure,
                  validator: MultiValidator([
                    RequiredValidator(errorText: '请输入密码'),
                    PatternValidator(
                      r'^(?=.*?[A-Za-z])(?=.*?[0-9]).{6,}$',
                      errorText: '密码必须由字母和数字组成，且至少6位',
                    ),
                  ]).call,
                ),
                const SizedBox(height: externalHeight), // 间距
                Row( // 验证码行
                  children: [
                    const Expanded(
                      flex: 2,
                      child: Text('验证码'), // 文本说明
                    ),
                    Expanded(
                      flex: 4,
                      child: TextFormField( // 验证码输入框
                        controller: _imgVerificateController,
                        decoration: const InputDecoration(
                          hintText: '请输入验证码', // 输入框提示文本
                        ),
                        validator: (value) { // 验证器：检查输入是否合法
                          if (value == null || value.isEmpty) { // 如果输入为空
                            return '请输入验证码'; // 提示用户输入密码
                          }
                          return null; // 输入合法，返回 null
                        },
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: GestureDetector(
                        onTap: _refreshCode,
                        child: Stack(
                        children: [FutureBuilder<Code>(
                        future: code,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            int? flag_code = snapshot.data!.code as int?;
                            _uuid = snapshot.data!.uuid; // 设置获取到的 uuid 值
                            SharedPreferences prefs;
                            code.then((value) async => {
                              prefs=await SharedPreferences.getInstance(),
                              await prefs.setString('uuid', _uuid),
                            });
                            Uint8List bytes = base64Decode(snapshot.data!.img);
                            return Image.memory(
                              bytes,
                              fit: BoxFit.contain,
                            );
                          } else if (snapshot.hasError) {
                            return Text('${snapshot.error}');
                          }
                          // By default, show a loading spinner.
                          return const CircularProgressIndicator();
                        },
                      ),
                          const Positioned(
                            bottom: 0,
                            right: 0,
                            child: Text(
                              '点击重试？', // New text
                              style: TextStyle(
                                fontSize: 12.0, // Adjust font size as needed
                                color: Color(0xff1a16c1), // Adjust color as needed
                              ),
                            ),
                          ),
                        ]
                    ),
                    ),
                      // child: Image.network(_codeUrl), // 显示验证码图片
                    ),
                  ],
                ),
                const SizedBox(height: 20.0), // 间距
                SizedBox( // 登录按钮
                  height: 41.0,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) { // 验证表单
                        // 执行登录操作
                        user=apiClient.loginUser(_phoneController.text, _passwordController.text,
                            _imgVerificateController.text, _uuid);
                        // if (kIsWeb) {
                        //   Navigator.pushNamed(context, '/collegeLogin');
                        //   return;
                        // }
                        User user1=await apiClient.loginUser(_phoneController.text, _passwordController.text,
                            _imgVerificateController.text, _uuid);
                        // 使用数据库生成器创建数据库实例，传递数据库文件的名称（'app_database.db'）
                        var database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
                        // 从数据库实例中获取 PersonDao 实例
                        var userDao = database.userDao;
                        late UserDb resData;
                        String resMsg;
                        resMsg=utf8.decode(user1.msg.runes.toList());
                        int? count=await userDao.findUserCountByPhoneNumber(_phoneController.text);
                        if(resMsg=="登录成功"){
                          // 保存当前用户唯一标识
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setString('phoneNumber', _phoneController.text);
                          resData=UserDb.fromJson(user1.data);
                          await SharedPreferencesUtil.savePreference('userID', resData.userId);
                          // await prefs.setString('userName', resData.userName??'');
                          // await prefs.setString('userType', resData.userType??'');
                          // UserDb? kkkkk=await userDao.findUserByPhoneNumber(_phoneController.text);
                          // print('count:$count');
                          // print('aaaaaa:${kkkkk?.password}');
                          Map<String, dynamic>? map =user1.mapData;
                          print('map:$map');
                          TokenRepository.getInstance().token = map["access_token"];
                          TokenRepository.getInstance().expire = map["expires_in"];
                          final userProvider = Provider.of<UserProvider>(context, listen: false);
                          userProvider.updateLoginState(
                            true,
                            resData.userName??'',
                            resData.avatar??'',
                          );
                          Navigator.pop(context);
                          if(count==0){
                            user.then((value) => {
                              Util.showToastCourse(resMsg, context),
                              Navigator.pushNamed(context, '/supplement')
                            });
                            return;
                          }else{
                            user.then((value) => {
                              Util.showToastCourse(resMsg, context),
                              Navigator.pushNamed(context, '/tabs')
                            });
                            return;
                          }
                        }
                        user.then((value) async => {
                          Util.showToastCourse(resMsg, context),
                        });
                        return;
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.lightBlueAccent), // 按钮背景颜色
                    ),
                    child: const Text(
                      '登录', // 按钮文本
                      style: TextStyle(
                        fontSize: 16, // 文本大小
                        color: Colors.white, // 文本颜色
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10.0), // 间距
                Row(
                children: [
                  Expanded(
                    child:
                      Align( // 注册按钮
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, "/forgetPassword"); // 跳转到注册页面
                          },
                          child: Text('忘记密码？'), // 注册按钮文本
                        ),
                      ),
                  ),
                  Expanded(
                    child:
                      Align( // 注册按钮
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, "/register"); // 跳转到注册页面
                          },
                          child: Text('没有账号？立即注册'), // 注册按钮文本
                        ),
                      ),),
                    ],
                  ),
                // SizedBox(height: 120.0), // 底部间距
                ],
            ),
          ),
        ),
      ),
      ),
    );
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
