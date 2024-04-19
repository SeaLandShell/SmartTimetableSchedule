// To parse this JSON data, do
//
//     late userDb = userDbFromJson(jsonString);

import 'dart:convert';

import 'package:floor/floor.dart';

UserDb userDbFromJson(String str) => UserDb.fromJson(json.decode(str));

String userDbToJson(UserDb data) => json.encode(data.toJson());
@Entity(primaryKeys: ['userId', 'phonenumber'])
class UserDb {
    late String? createBy;
    late String? createTime;
    late String? updateBy;
    late String? updateTime;
    late String? remark;
    late int? userId;
    late int? deptId;
    late String? userName;
    late String? nickName;
    late String? password;
    late String? userType;
    late String? email;
    late String? phonenumber;
    late String? stuTuNumber;
    late String? sex;
    late String? avatar;
    late String? birthday;
    late String? status;
    late String? delFlag;
    late String? loginIp;
    late String? loginDate;
    // UserDb(this.createBy, this.createTime, this.updateBy, this.updateTime, this.remark, this.userId, this.deptId, this.userName, this.nickName, this.password, this.userType, this.email, this.phonenumber, this.stuTuNumber, this.sex, this.avatar, this.birthday, this.status, this.delFlag, this.loginIp, this.loginDate);

    UserDb({
        this.createBy,
        this.createTime,
        this.updateBy,
        this.updateTime,
        this.remark,
        this.userId,
        this.deptId,
        this.userName,
        this.nickName,
        this.password,
        this.userType,
        this.email,
        this.phonenumber,
        this.stuTuNumber,
        this.sex,
        this.avatar,
        this.birthday,
        this.status,
        this.delFlag,
        this.loginIp,
        this.loginDate,
    });

    UserDb copyWith({
        String? createBy,
        String? createTime,
        String? updateBy,
        String? updateTime,
        String? remark,
        int? userId,
        int? deptId,
        String? userName,
        String? nickName,
        String? password,
        String? userType,
        String? email,
        String? phonenumber,
        String? stuTuNumber,
        String? sex,
        String? avatar,
        String? birthday,
        String? status,
        String? delFlag,
        String? loginIp,
        String? loginDate,
    }) =>
        UserDb(
            createBy: createBy ?? this.createBy,
            createTime: createTime ?? this.createTime,
            updateBy: updateBy ?? this.updateBy,
            updateTime: updateTime ?? this.updateTime,
            remark: remark ?? this.remark,
            userId: userId ?? this.userId,
            deptId: deptId ?? this.deptId,
            userName: userName ?? this.userName,
            nickName: nickName ?? this.nickName,
            password: password ?? this.password,
            userType: userType ?? this.userType,
            email: email ?? this.email,
            phonenumber: phonenumber ?? this.phonenumber,
            stuTuNumber: stuTuNumber ?? this.stuTuNumber,
            sex: sex ?? this.sex,
            avatar: avatar ?? this.avatar,
            birthday: birthday ?? this.birthday,
            status: status ?? this.status,
            delFlag: delFlag ?? this.delFlag,
            loginIp: loginIp ?? this.loginIp,
            loginDate: loginDate ?? this.loginDate,
        );

    factory UserDb.fromJson(Map<String, dynamic> json) => UserDb(
        createBy: json["createBy"] != null ? utf8.decode(json["createBy"].toString().codeUnits) : '',
        createTime: json["createTime"] != null ? utf8.decode(json["createTime"].toString().codeUnits) : '',
        updateBy: json["updateBy"] != null ? utf8.decode(json["updateBy"].toString().codeUnits) : '',
        updateTime: json["updateTime"] != null ? utf8.decode(json["updateTime"].toString().codeUnits) : '',
        remark: json["remark"] != null ? utf8.decode(json["remark"].toString().codeUnits) : '',
        userId: json["userId"],
        deptId: json["deptId"],
        userName: json["userName"] != null ? utf8.decode(json["userName"].toString().codeUnits) : '',
        nickName: json["nickName"] != null ? utf8.decode(json["nickName"].toString().codeUnits) : '',
        password: json["password"] != null ? utf8.decode(json["password"].toString().codeUnits) : '',
        userType: json["userType"] != null ? utf8.decode(json["userType"].toString().codeUnits) : '',
        email: json["email"] != null ? utf8.decode(json["email"].toString().codeUnits) : '',
        phonenumber: json["phonenumber"] != null ? utf8.decode(json["phonenumber"].toString().codeUnits) : '',
        stuTuNumber: json["stuTuNumber"] != null ? utf8.decode(json["stuTuNumber"].toString().codeUnits) : '',
        sex: json["sex"] != null ? utf8.decode(json["sex"].toString().codeUnits) : '',
        avatar: json["avatar"] != null ? utf8.decode(json["avatar"].toString().codeUnits) : '',
        birthday: json["birthday"] != null ? utf8.decode(json["birthday"].toString().codeUnits) : '',
        status: json["status"] != null ? utf8.decode(json["status"].toString().codeUnits) : '',
        delFlag: json["delFlag"] != null ? utf8.decode(json["delFlag"].toString().codeUnits) : '',
        loginIp: json["loginIp"] != null ? utf8.decode(json["loginIp"].toString().codeUnits) : '',
        loginDate: json["loginDate"] != null ? utf8.decode(json["loginDate"].toString().codeUnits) : '',
    );

    Map<String, dynamic> toJson() => {
        "createBy": createBy??'',
        "createTime": createTime??'',
        "updateBy": updateBy??'',
        "updateTime": updateTime??'',
        "remark": remark??'',
        "userId": userId.toString(),
        "deptId": deptId.toString(),
        "userName": userName??'',
        "nickName": nickName??'',
        "password": password??'',
        "userType": userType??'',
        "email": email??'',
        "phonenumber": phonenumber??'',
        "stuTuNumber": stuTuNumber??'',
        "sex": sex??'',
        "avatar": avatar??'',
        "birthday": birthday??'',
        "status": status??'',
        "delFlag": delFlag??'',
        "loginIp": loginIp??'',
        "loginDate": loginDate??'',
    };
}
