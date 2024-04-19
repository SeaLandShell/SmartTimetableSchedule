// 引入Dio库，用于进行网络请求
import 'package:course_schedule/utils/shared_preferences_util.dart';
import 'package:dio/dio.dart';

// 引入自定义的HttpUtil工具类，用于处理HTTP请求
import 'package:course_schedule/utils/http_util.dart';

// 定义HomePageModel类
class HomePageModel {
  // 定义一个异步方法shareTimetable，用于分享课程表
  Future<Response<String>> shareTimetable(String timetableJson) async {
    int userID = await SharedPreferencesUtil.getPreference('userID', -1);
    // 发起POST请求，调用HttpUtil中的client来发送请求
    // 请求的URL为"/calendar/shareCalendar"
    // 请求的数据为一个FormData对象，其中包含一个名为"calendar"的字段，值为传入的timetableJson
    return HttpUtil.client.post<String>("/ctimetable/calendar/shareCalendar",
        data: FormData.fromMap({"userID": userID,"calendar": timetableJson}));
  }
}
