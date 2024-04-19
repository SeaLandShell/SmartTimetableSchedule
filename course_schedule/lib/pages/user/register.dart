import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:form_field_validator/form_field_validator.dart';

import '../../models/user.dart';
import '../../net/apiClient.dart';
import '../../net/globalVariables.dart'; // 导入网络请求的apiClient文件，假设路径为'../../net/apiClient.dart'

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // 表单的全局Key，用于校验表单
  final TextEditingController _usernameController = TextEditingController(); // 用户名输入框的控制器
  final TextEditingController _phoneController = TextEditingController(); // 手机号输入框的控制器
  final TextEditingController _passwordController = TextEditingController(); // 密码输入框的控制器
  final TextEditingController _confirmPasswordController = TextEditingController(); // 确认密码输入框的控制器
  final TextEditingController _verificationCodeController = TextEditingController(); // 验证码输入框的控制器
  ApiClient apiClient=ApiClient(); // 实例化ApiClient，用于发送注册请求
  late Future<User> user;
  static const double _space=10.0;

  String baseUrl=GlobalVariables.instance.baseUrl; // 服务器基本URL
  String _selectedRole = '教师'; // 默认选择的角色为教师
  String _verificationCode = ''; // 存储从服务器获取的验证码
  bool _isObscure = true; // 控制密码显示
  bool _isObscure1 = true; // 控制确认密码显示
  int _countdown = 0; // 初始倒计时时间，60秒

  // 倒计时方法
  void _startCountdown() {
    setState(() {
      _countdown = 60; // 重置倒计时时间为60秒
    });
    // 创建定时器，每秒减少一秒
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (_countdown == 0) {
        timer.cancel(); // 取消定时器
      } else {
        setState(() {
          _countdown--; // 倒计时减1
        });
      }
    });
  }

  // 发送验证码的方法
  Future<void> _sendVerificationCode() async {
    final response = await http.get(
        Uri.parse('$baseUrl/acuser/sms?phone=${_phoneController.text}')
    );
    final responseData = json.decode(response.body);
    final msg = responseData['msg'];
    if (msg != null) {
      setState(() {
        _verificationCode = msg;
        _startCountdown(); // 开始倒计时
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          '注册',
          style: TextStyle(
            color: Colors.blue,
            fontFamily: "Courier",
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SafeArea(child: Container(
          height: MediaQuery.of(context).size.height - AppBar().preferredSize.height, // 减去AppBar高度
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Colors.blue.withOpacity(0.2), // 从白色到非常浅的蓝色
            ],
          ),
        ),
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey, // 绑定表单Key
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                autovalidateMode: AutovalidateMode.disabled, // 禁用自动验证模式
                controller: _usernameController,
                decoration: InputDecoration(labelText: '姓名',prefixIcon: const Icon(Icons.account_circle),),
                validator: RequiredValidator(errorText: '请输入姓名'),
              ),
              const SizedBox(height: _space),
              TextFormField(
                autovalidateMode: AutovalidateMode.disabled, // 禁用自动验证模式
                controller: _phoneController,
                decoration: const InputDecoration(labelText: '手机号',prefixIcon: Icon(Icons.phone), ),
                validator: MultiValidator([
                  RequiredValidator(errorText: '请输入手机号'),
                  LengthRangeValidator(
                    min: 11,
                    max: 11,
                    errorText: '手机号必须为11位',
                  ),
                  PatternValidator(
                    r'^[0-9]*$',
                    errorText: '手机号只能包含数字',
                  ),
                ]).call,
              ),
              const SizedBox(height: _space),
              TextFormField(
                autovalidateMode: AutovalidateMode.disabled, // 禁用自动验证模式
                controller: _passwordController,
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
              const SizedBox(height: _space),
              TextFormField(
                autovalidateMode: AutovalidateMode.disabled, // 禁用自动验证模式
                controller: _confirmPasswordController,
                decoration: InputDecoration(labelText: '确认密码',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(_isObscure1 ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _isObscure1 = !_isObscure1;
                      });
                    },
                  ),
                ),
                obscureText: _isObscure1,
                validator: (value) {
                  if (value == null || value.isEmpty) { // 如果输入为空
                    return '请输入密码'; // 提示用户输入密码
                  }
                  if (value != _passwordController.text) {
                    return '两次密码输入不一致';
                  }
                  return null;
                },
              ),
              const SizedBox(height: _space),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('角色', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: _space), // 添加间距
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Radio<String>(
                        value: '教师',
                        groupValue: _selectedRole,
                        onChanged: (value) {
                          setState(() {
                            _selectedRole = value!;
                          });
                        },
                      ),
                      Text('教师'),
                      const SizedBox(width: _space), // 添加间距
                      Radio<String>(
                        value: '学生',
                        groupValue: _selectedRole,
                        onChanged: (value) {
                          setState(() {
                            _selectedRole = value!;
                          });
                        },
                      ),
                      Text('学生'),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: _space),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Text('验证码'), // 文本说明
                  ),
                  Expanded(
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.disabled, // 禁用自动验证模式
                      controller: _verificationCodeController,
                      decoration: InputDecoration(labelText: '验证码'),
                    ),
                  ),
                  // const SizedBox(width: _space),
                  ElevatedButton(
                    onPressed: _countdown == 0 ? () {
                    if (_formKey.currentState!.validate()) {
                        _sendVerificationCode();
                      }
                    } : null, // 如果倒计时不为0，则禁用按钮
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _countdown == 0 ? Colors.lightBlueAccent : Colors.grey, // 根据倒计时状态设置按钮颜色
                    ),
                    child: Text(_countdown == 0 ? '获取验证码' : '$_countdown 秒后重试',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25.0),
              SizedBox(
                height: 41.0, // 设置按钮的高度为41.0
                child: ElevatedButton(
                  onPressed: _countdown!=0 && _verificationCode.trim() == _verificationCodeController.text.trim()
                      ? (){
                    if (_formKey.currentState!.validate()) {
                      // 验证表单通过后，执行注册逻辑
                      user=apiClient.registerUser(_usernameController.text, _phoneController.text, _passwordController.text, _selectedRole);
                      String res_msg='';
                      int? res_code;
                      Object res_data=();
                      user.then((value) => {
                        res_msg=utf8.decode(value.msg.runes.toList()),
                        res_code=value.code as int?,
                        res_data=value.data,
                        if(res_msg=="手机号已存在" && res_code==500){
                          _showSnackBar("手机号已存在，请重新注册"),
                        }else if(res_msg=="注册成功" && res_code==200){
                          _countdown=0,
                          _showSnackBar("注册成功"),
                          Navigator.pop(context),
                        }
                      });
                    }
                  } : (){
                    if (_formKey.currentState!.validate()) {
                      _countdown!=0 ? _showSnackBar("验证码错误") : _showSnackBar("请获取验证码！");
                    }
                  }, // 如果倒计时不为0，则禁用按钮
                  style: ButtonStyle(
                    // backgroundColor: MaterialStateProperty.all<Color>(_countdown == 0 ? Colors.lightBlueAccent : Colors.grey), // 根据倒计时状态设置按钮颜色
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.lightBlueAccent),
                  ),
                  child: const Text(
                    '注册',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              // const SizedBox(height: 20.0),//试验安全域
            ],
          ),
        ),
      ),
    ),
      ),
    );
  }
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 1), // 设置持续时间为3秒
      ),
    );
  }
  @override
  void dispose() {
    // 取消未完成的异步操作
    super.dispose();
  }
}