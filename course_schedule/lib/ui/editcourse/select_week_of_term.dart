import 'package:flutter/material.dart'; // 导入Flutter框架的material库
import 'package:course_schedule/provider/store.dart'; // 导入store.dart文件，提供了课程信息的管理

typedef selectWeekOfTermCallBack = void Function(
    List<bool> checkStates); // 定义了一个回调函数类型

class SelectWeekOfTerm extends StatefulWidget {
  // 选择学期周数组件的StatefulWidget
  final double height; // 组件高度
  final selectWeekOfTermCallBack okBtnOnClick; // 确定按钮点击回调函数
  final int weekOfTerm; // 当前学期的周数

  SelectWeekOfTerm(
      { // 构造函数
      required this.height, // 必需的参数：高度
      required this.okBtnOnClick, // 必需的参数：确定按钮点击回调函数
      required this.weekOfTerm, // 必需的参数：当前学期的周数
      Key? key // Widget的标识符
      })
      : super(key: key); // 调用父类的构造函数

  @override
  _SelectWeekOfTermState createState() =>
      _SelectWeekOfTermState(); // 创建选择学期周数组件的状态
}

class _SelectWeekOfTermState extends State<SelectWeekOfTerm> {
  // 选择学期周数组件的State
  late final List<bool> states; // 存储每周是否选中的状态列表
  late final int maxWeekNum; // 最大周数

  @override
  void initState() {
    // 初始化状态的方法
    super.initState(); // 调用父类的初始化方法
    maxWeekNum = Store.getInstanceReadMode(context).maxWeekNum; // 获取最大周数
    states = List.generate(
        maxWeekNum, // 生成状态列表
        (index) =>
            (widget.weekOfTerm >> (maxWeekNum - index - 1)) & 0x1 ==
            1); // 根据当前学期的周数初始化每周是否选中的状态
  }

  @override
  Widget build(BuildContext context) {
    // 构建界面的方法
    List<Widget> checkBoxes = _buildCheckGroup(); // 构建选择周数的复选框
    final bool isSelectAll = _isSelectAll(); // 是否全选

    return Container(
        // 容器组件，包含选择周数的界面
        height: widget.height, // 高度
        child: Column(
          // 列布局，垂直排列子组件
          children: [
            Container(
              height: 48,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12), // 左上角圆角
                  topRight: Radius.circular(12), // 右上角圆角
                ),
                color: Colors.white, // 容器的背景颜色
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5), // 阴影颜色
                    spreadRadius: 2, // 阴影扩散程度
                    blurRadius: 3, // 阴影模糊程度
                    offset: Offset(0, 1), // 阴影偏移量
                  ),
                ],
              ),
              child: Stack(
                // 堆叠布局，子组件重叠排列
                children: [
                  Align(
                    // 对齐组件，左对齐
                    alignment: Alignment.centerLeft, // 对齐方式
                    child: TextButton(
                        // 文本按钮组件，用于取消操作
                        onPressed: () {
                          // 点击事件
                          Navigator.of(context).pop(); // 返回上一页
                        },
                        child: Text(
                          // 文本组件，显示“取消”
                          "取消", // 文本内容
                          style: TextStyle(color: Colors.black38), // 文本样式
                        )),
                  ),
                  Center(
                    // 居中对齐
                    child: Container(
                      // 容器组件，用于显示选择周数的标题
                      child: Text(
                        // 文本组件，显示“选择周数”
                        "选择周数", // 文本内容
                        style: TextStyle(fontSize: 16), // 文本样式
                        textAlign: TextAlign.center, // 文本对齐方式
                      ),
                    ),
                  ),
                  Align(
                    // 对齐组件，右对齐
                    alignment: Alignment.centerRight, // 对齐方式
                    child: TextButton(
                        // 文本按钮组件，用于确定操作
                        onPressed: () {
                          // 点击事件
                          widget.okBtnOnClick(states); // 调用确定按钮点击回调函数
                          Navigator.of(context).pop(); // 返回上一页
                        },
                        child: Text("确定")), // 文本内容为“确定”
                  ),
                ],
              ),
            ),
            Row(
              // 行布局，水平排列子组件
              children: [
                TextButton(
                    // 文本按钮组件，用于选择单周
                    onPressed: () {
                      // 点击事件
                      setState(() {
                        // 更新状态
                        for (int i = 1; i <= states.length; i++) {
                          // 遍历每一周
                          states[i - 1] = i % 2 == 1; // 奇数周设为选中状态，偶数周设为未选中状态
                        }
                      });
                    },
                    child: Text("单周")), // 文本内容为“单周”
                TextButton(
                    // 文本按钮组件，用于选择双周
                    onPressed: () {
                      // 点击事件
                      setState(() {
                        // 更新状态
                        for (int i = 1; i <= states.length; i++) {
                          // 遍历每一周
                          states[i - 1] = i % 2 == 0; // 偶数周设为选中状态，奇数周设为未选中状态
                        }
                      });
                    },
                    child: Text("双周")), // 文本内容为“双周”
                TextButton(
                    // 文本按钮组件，用于全选或取消全选
                    onPressed: () {
                      // 点击事件
                      setState(() {
                        // 更新状态
                        for (int i = 1; i <= states.length; i++) {
                          // 遍历每一周
                          states[i - 1] = !isSelectAll; // 切换选中状态
                        }
                      });
                    },
                    child: Text(
                      // 文本内容为“全选”或“取消全选”
                      "全选", // 文本内容
                      style: TextStyle(
                          // 文本样式
                          color: isSelectAll
                              ? Colors.black26
                              : Colors.blue), // 如果已全选则显示灰色，否则显示蓝色
                    )),
              ],
            ),
            Expanded(
              // 扩展组件，填充剩余空间
              child: Container(
                // 容器组件，包裹复选框
                padding: const EdgeInsets.all(12), // 内边距
                width: double.infinity, // 宽度充满父容器
                child: Wrap(
                  // 自动换行布局
                  children: checkBoxes, // 复选框列表
                ),
              ),
            ),
          ],
        )
    );
  }

  bool _isSelectAll() {
    // 判断是否全部选中的方法
    for (bool check in states) {
      // 遍历每一周的选中状态
      if (!check) {
        // 如果存在未选中的周数
        return false; // 返回false
      }
    }
    return true; // 如果全部选中，则返回true
  }

  static const double _checkBtnRadius = 36; // 复选框的半径

  List<Widget> _buildCheckGroup() {
    // 构建选择周数的复选框列表的方法
    final List<Widget> checkBoxes = []; // 存储复选框的列表
    for (int i = 0; i < maxWeekNum; i++) {
      // 遍历每一周
      checkBoxes.add(Padding(
        // 添加填充组件
        padding: const EdgeInsets.all(6.0), // 内边距
        child: GestureDetector(
            // 手势识别组件，用于处理点击事件
            onTap: () {
              // 点击事件
              setState(() {
                // 更新状态
                states[i] = !states[i]; // 切换选中状态
              });
            },
            child: Container(
                // 容器组件，表示复选框
                decoration: BoxDecoration(
                    // 装饰器，设置背景
                    color: states[i]
                        ? Colors.blue
                        : Colors.transparent, // 根据状态设置背景颜色
                    borderRadius: const BorderRadius.all(// 圆角边框
                        Radius.circular(_checkBtnRadius / 2))), // 设置圆角半径
                width: _checkBtnRadius, // 宽度
                height: _checkBtnRadius, // 高度
                child: Center(
                    // 居中对齐
                    child: Text(
                  // 文本组件，显示周数
                  "${i + 1}", // 文本内容，表示第几周
                  style: TextStyle(
                      // 文本样式
                      fontSize: 16, // 字号
                      color:
                          states[i] ? Colors.white : Colors.black), // 根据状态设置颜色
                )))),
      ));
    }
    return checkBoxes; // 返回复选框列表
  }
}
