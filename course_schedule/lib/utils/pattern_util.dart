class PatternUtil {
  PatternUtil._(); // 私有构造函数，防止类被实例化

  // 判断手机号是否为中国手机号
  static bool isChinesePhone(String? phone) {
    return phone != null && RegExp(r"^1[3-9]\d{9}$").hasMatch(phone); // 使用正则表达式匹配手机号格式
  }

  // 判断是否为有效的邮箱地址
  static bool isEmail(String? email) {
    return email != null && RegExp("^[a-zA-Z0-9\\+\\.\\_\\%\\-\\+]{1,256}" +
        "\\@" +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
        "(" +
        "\\." +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
        r")+$")
        .hasMatch(email); // 使用正则表达式匹配邮箱地址格式
  }

  // 判断用户名是否有效（长度大于等于3）
  static bool isUserNameValid(String? name) {
    return name != null && name.length >= 3; // 判断用户名是否不为空且长度大于等于3
  }

  // 判断账号是否有效（根据是否包含 @ 判断是手机号还是邮箱）
  static bool isAccountValid(String? account) {
    if (account == null) { // 如果账号为空
      return false; // 返回 false
    }
    if (account.contains('@')) { // 如果账号包含 @ 符号
      return isEmail(account); // 判断是否为有效的邮箱地址
    } else {
      return isChinesePhone(account); // 判断是否为中国手机号
    }
  }

  // 判断密码是否有效（长度大于等于6）
  static bool isPasswordValid(String? password) {
    return password != null && password.length >= 6; // 判断密码是否不为空且长度大于等于6
  }
}
