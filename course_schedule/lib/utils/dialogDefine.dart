import 'package:flutter/material.dart'; // 导入 Flutter Material 库
import 'package:toast/toast.dart'; // 导入 Flutter Toast 库
import '../pages/widgets/myDialog.dart'; // 导入自定义对话框组件

class DialogDefine {
  late BuildContext context; // 上下文对象

  // 显示警告对话框
  void _alertDialog() async {
    var result = await showDialog(
        barrierDismissible: false, // 设置点击灰色背景是否关闭对话框
        context: context, // 上下文对象
        builder: (context) {
          return AlertDialog(
            // 创建警告对话框
            title: const Text("提示信息!"), // 对话框标题
            content: const Text("您确定要删除吗"), // 对话框内容
            actions: [
              // 对话框操作按钮
              TextButton(
                  onPressed: () {
                    print("ok"); // 输出确定按钮点击事件
                    Navigator.of(context).pop("ok"); // 关闭对话框并传递值
                  },
                  child: const Text("确定")), // 确定按钮
              TextButton(
                  onPressed: () {
                    print("cancel"); // 输出取消按钮点击事件
                    Navigator.of(context).pop("取消"); // 关闭对话框并传递值
                  },
                  child: const Text("取消")) // 取消按钮
            ],
          );
        });

    print("-----------");
    print(result); // 输出对话框返回值
  }

  // 显示简单对话框
  void _simpleDialog() async {
    var result = await showDialog(
        barrierDismissible: false, // 设置点击灰色背景是否关闭对话框
        context: context, // 上下文对象
        builder: (context) {
          return SimpleDialog(
            // 创建简单对话框
            title: const Text("请选择语言"), // 对话框标题
            children: [
              // 对话框选项列表
              SimpleDialogOption(
                onPressed: () {
                  print("汉语"); // 输出汉语选项点击事件
                  Navigator.pop(context, "汉语"); // 关闭对话框并传递值
                },
                child: const Text("汉语"), // 汉语选项
              ),
              const Divider(), // 分割线
              SimpleDialogOption(
                onPressed: () {
                  print("英语"); // 输出英语选项点击事件
                  Navigator.pop(context, "英语"); // 关闭对话框并传递值
                },
                child: const Text("英语"), // 英语选项
              ),
              const Divider(), // 分割线
              SimpleDialogOption(
                onPressed: () {
                  print("日语"); // 输出日语选项点击事件
                  Navigator.pop(context, "日语"); // 关闭对话框并传递值
                },
                child: const Text("日语"), // 日语选项
              ),
              const Divider(), // 分割线
            ],
          );
        });

    print("-----------");
    print(result); // 输出对话框返回值
  }

  // 显示底部模态菜单
  void _modelBottomSheet() async {
    var result = await showModalBottomSheet(
        context: context, // 上下文对象
        builder: (context) {
          return SizedBox(
            height: 240, // 高度
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center, // 交叉轴居中对齐
              children: [
                ListTile(
                  title: const Text("分享"), // 分享选项
                  onTap: () {
                    print("分享"); // 输出分享按钮点击事件
                    Navigator.of(context).pop("分享"); // 关闭底部模态菜单并传递值
                  },
                ),
                const Divider(), // 分割线
                ListTile(
                  title: const Text("收藏"), // 收藏选项
                  onTap: () {
                    print("收藏"); // 输出收藏按钮点击事件
                    Navigator.of(context).pop("收藏"); // 关闭底部模态菜单并传递值
                  },
                ),
                const Divider(), // 分割线
                ListTile(
                  title: const Text("取消"), // 取消选项
                  onTap: () {
                    print("取消"); // 输出取消按钮点击事件
                    Navigator.of(context).pop("取消"); // 关闭底部模态菜单并传递值
                  },
                ),
                const Divider(), // 分割线
              ],
            ),
          );
        });
    print(result); // 输出底部模态菜单返回值
  }

  // 显示 Toast 提示信息
  void _toast(String? msg) {
    Toast.show(msg!, duration: Toast.lengthLong, gravity: Toast.bottom);
  }

  // 显示自定义对话框
  void _myDialog() async {
    var result = await showDialog(
        barrierDismissible: false, // 设置点击灰色背景是否关闭对话框
        context: context, // 上下文对象
        builder: (context) {
          return MyDialog(
            // 创建自定义对话框
            title: "提示!", // 对话框标题
            content: "我是一个内容", // 对话框内容
            onTap: () {
              // 自定义对话框关闭事件
              print("close"); // 输出关闭事件
              Navigator.of(context).pop("我是自定义dialog关闭的事件"); // 关闭对话框并传递值
            },
          );
        });
    print(result); // 输出自定义对话框返回值
  }
}
