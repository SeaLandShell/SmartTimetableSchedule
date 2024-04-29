import 'dart:convert';
import 'package:dio/dio.dart';
import 'dart:async';

import 'package:http/http.dart' as http;
import '../data/token_repository.dart';
import '../model/code.dart';
import '../model/user.dart';
import '../utils/shared_preferences_util.dart';
import 'globalVariables.dart';

class ApiClient {
  static String baseUrl = GlobalVariables.instance.baseUrl;
  var dio = ApiClient.createDio();
  static Dio createDio() {
    var options = BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: Duration(milliseconds: 10000),
        receiveTimeout: Duration(milliseconds: 100000),
        contentType: Headers.jsonContentType);
    options.headers["Authorzation"]=GlobalVariables.instance.access_token;
    return Dio(options);
  }
  Future<Code> fetchCode() async {
    final response = await http
        .get(Uri.parse('$baseUrl/code'));
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return Code.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<User> registerUser(String username,String phone, String password, String role) async {
      final userType = role == '教师' ? '01' : '02';
      final response = await http.post(
        Uri.parse('$baseUrl/acuser/acuser/register'),
        body: {
          'username': username,
          'phone': phone,
          'password': password,
          'userType': userType,
        },
      );
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        return User.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        return User.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      }
    }
  Future<User> loginUser(String phone, String password, String code,String uuid) async {
    final response = await http.post(
      Uri.parse('$baseUrl/acuser/acuser/login'),
      body: {
        'phone': phone,
        'password': password,
        'code': code,
        'uuid': uuid
      },
    );
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return User.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw("网络请求错误");
    }
  }
  Future<User> searchUserByTuStuNumber(String stuTuNumber) async {
    final response = await http.get(
      Uri.parse('$baseUrl/acuser/acuser/stuTuNumber?stuTuNumber=$stuTuNumber'),
    );
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return User.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw("网络请求错误");
    }
  }

  Future<User> upadtePasswordUser(String phone, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/acuser/acuser/updatePassword'),
      body: {
        'phone': phone,
        'password': password
      },
    );
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return User.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw("网络请求错误");
    }
  }
}
