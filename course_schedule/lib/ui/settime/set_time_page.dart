import 'dart:math'; // 导入Dart标准库中的math库，用于数学计算

import 'package:flutter/cupertino.dart'; // 导入Flutter框架的Cupertino库，用于iOS风格的UI组件
import 'package:flutter/material.dart'; // 导入Flutter框架的material库，用于Material风格的UI组件
import 'package:course_schedule/components/pickerview/picker_view.dart'; // 导入自定义的PickerView组件
import 'package:course_schedule/components/pickerview/picker_view_popup.dart'; // 导入自定义的PickerViewPopup组件
import 'package:course_schedule/data/values.dart'; // 导入自定义的值文件，包含应用程序中使用的常量值
import 'package:course_schedule/entity/time.dart'; // 导入自定义的时间实体类
import 'package:course_schedule/provider/store.dart'; // 导入数据提供者Store
import 'package:course_schedule/utils/dialog_util.dart'; // 导入自定义的对话框工具类
import 'package:flutter/services.dart'; // 导入Flutter框架的services库，用于访问平台特定的服务

class SetTimePage extends StatefulWidget {
  // 设置时间页面的有状态组件
  @override
  _SetTimePageState createState() => _SetTimePageState(); // 创建状态类的实例
}

class _SetTimePageState extends State<SetTimePage> {
  // 设置时间页面的状态类
  final int maxClassLength = 12; // 一天的最大节数
  final List<TimeEntity> _data = []; // 存储时间实体的列表
  final List<Time> _timeOptions = []; // 存储时间选项的列表

  @override
  void initState() {
    // 在初始化状态时调用的方法
    super.initState(); // 调用父类的初始化方法

    _data.clear(); // 清空数据列表
    // 获取存储在数据提供者中的课程时间信息，并添加到数据列表中
    Store.getInstanceReadMode(context).classTime.forEach((element) {
      _data.add(element.clone());
    });
    if (_data.length > maxClassLength) {
      // 如果数据列表长度大于一天的最大节数
      _data.removeRange(12, _data.length); // 移除多余的课程时间信息
    } else if (_data.length < maxClassLength) {
      // 如果数据列表长度小于一天的最大节数
      for (var i = _data.length; i < 12; ++i) {
        // 添加缺失的课程时间信息
        _data.add(TimeEntity());
      }
    }

    _timeOptions.clear(); // 清空时间选项列表
    // 生成小时从6到23、分钟从0到55（间隔5分钟）的时间选项，并添加到时间选项列表中
    for (int i = 6; i <= 23; ++i) {
      for (int j = 0; j < 60; j += 5) {
        _timeOptions.add(Time(hour: i, minute: j));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // 构建页面的方法
    return Scaffold(
      // 使用Scaffold创建页面的基本布局结构
      backgroundColor: Values.bgWhite, // 设置背景颜色为白色
      appBar: AppBar(
        // 页面顶部的应用栏
        title: Text("设置时间"), // 设置标题文本为“设置时间”
        actions: [
          // 应用栏右侧的操作按钮集合
          IconButton(
              // 操作按钮，点击时触发保存操作
              splashRadius: 16, // 设置点击时的水波纹半径
              padding: const EdgeInsets.all(5), // 设置内边距
              icon: Icon(
                // 按钮图标
                Icons.save, // 使用保存图标
                size: 24, // 图标大小
              ),
              tooltip: "保存", // 按钮的提示文本
              onPressed: _saveAction) // 点击按钮时触发保存操作
        ],
        systemOverlayStyle: SystemUiOverlayStyle.light, // 设置状态栏样式为浅色
      ),
      body: _buildBody(), // 设置页面主体内容为_buildBody方法返回的内容
    );
  }

  Widget _buildBody() {
    // 构建页面主体的方法
    return ListView(
      // 使用ListView展示垂直列表
      children: _buildItems(), // 设置列表子组件为_buildItems方法返回的内容
    );
  }

  List<Widget> _buildItems() {
    // 构建列表子组件的方法
    // 使用List.generate生成包含maxClassLength个元素的列表，每个元素为一个时间选择项
    List<Widget> list = List.generate(maxClassLength, (index) {
      return Padding(
        // 使用Padding包裹列表项，设置底部间距
        padding: const EdgeInsets.only(bottom: 8.0),
        child: StatefulBuilder(
          // 使用StatefulBuilder包裹列表项，使得每个列表项都能够更新自身状态
          builder: (context, setState) {
            final time = _data[index]; // 获取当前列表项对应的时间实体
            return Ink(
              // 使用Ink包裹列表项
              color: Colors.white, // 设置背景颜色为白色
              child: InkWell(
                // 使用InkWell包裹Ink，使得列表项能够响应触摸事件
                onTap: () {
                  // 点击列表项时触发事件，显示选择时间对话框
                  _showSelectTimeDialog(time, index, setState);
                },
                onLongPress: () {
                  // 长按列表项时触发事件，弹出确认对话框
                  DialogUtil.showConfirmDialog(context, "是否要清空该时间?", () {
                    setState(() {
                      // 更新列表项状态，清空时间信息
                      time.start = null;
                      time.end = null;
                    });
                  });
                },
                child: Container(
                    // 列表项的内容容器
                    width: double.infinity, // 设置宽度为父容器宽度
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 8), // 设置内边距
                    child: Row(
                      // 使用水平布局展示列表项内容
                      children: [
                        Text("第${index + 1}节", // 显示节次信息
                            style: const TextStyle(fontSize: 16)),
                        Expanded(child: Container()), // 占位控件，使得时间信息能够靠右对齐
                        ..._buildTimeWidget(time) // 使用展开运算符将时间信息添加到列表项中
                      ],
                    )),
              ),
            );
          },
        ),
      );
    });

    return list; // 返回列表子组件列表
  }

  List<Widget> _buildTimeWidget(TimeEntity? timeEntity) {
    // 构建时间信息部件的方法
    if (timeEntity == null || timeEntity.isEmpty) {
      // 如果时间实体为空或者没有时间信息
      return []; // 返回空列表
    } else {
      // 如果时间实体不为空且包含时间信息
      return [
        // 返回包含时间信息的部件列表
        Text(timeEntity.start.toString(),
            style: const TextStyle(fontSize: 16)), // 开始时间文本
        Text("-", style: const TextStyle(fontSize: 16)), // 分隔符文本
        Text(timeEntity.end.toString(),
            style: const TextStyle(fontSize: 16)), // 结束时间文本
      ];
    }
  }

  int _getIndexFormTimeOptions(Time time) {
    // 获取时间在时间选项列表中的索引的方法
    return (time.hour - 6) * 12 + (time.minute / 5).floor(); // 计算时间在时间选项列表中的索引
  }

  void _showSelectTimeDialog(
      // 显示选择时间对话框的方法
      TimeEntity entity,
      int index,
      StateSetter setState) {
    int startRow1 = 0; // 初始化开始时间选项的行索引1
    int startRow2 = 1; // 初始化结束时间选项的行索引2
    if (!entity.isEmpty) {
      // 如果时间实体不为空，即已经选择了时间
      startRow1 =
          _getIndexFormTimeOptions(entity.start!); // 获取开始时间选项在时间选项列表中的索引
      startRow2 = _getIndexFormTimeOptions(entity.end!); // 获取结束时间选项在时间选项列表中的索引
    } else if (entity.isEmpty && index > 0 && !_data[index - 1].isEmpty) {
      // 如果时间实体为空，且不是第一个时间段，且前一个时间段有时间信息
      startRow1 =
          _getIndexFormTimeOptions(_data[index - 1].end!) + 2; // 设置开始时间选项的行索引1
      startRow2 = startRow1 + 9; // 设置结束时间选项的行索引2
    }
    // 创建一个PickerController实例，用于控制PickerView
    PickerController pickerController =
        PickerController(count: 2, selectedItems: [startRow1, startRow2]);
    PickerViewPopup.showMode(PickerShowMode.BottomSheet, // 对话框展示模式，底部弹出
        controller: pickerController, // 设置PickerController
        context: context, // 上下文对象
        title: Text(
          // 对话框标题
          '选择时间',
          style: TextStyle(fontSize: 14),
        ),
        cancel: Text(
          // 取消按钮文本
          '取消',
          style: TextStyle(color: Colors.grey),
        ),
        confirm: Text(
          // 确定按钮文本
          '确定',
          style: TextStyle(color: Colors.blue),
        ),
        onConfirm: (controller) {
          // 确定按钮点击时的回调函数
          int index1 =
              pickerController.selectedRowAt(section: 0)!; // 获取开始时间选项的行索引1
          int index2 =
              pickerController.selectedRowAt(section: 1)!; // 获取结束时间选项的行索引2
          if (entity.start != _timeOptions[index1] || // 如果开始时间或结束时间与之前不同
              entity.end != _timeOptions[index2]) {
            setState(() {
              // 更新状态，设置开始时间和结束时间
              entity.start = _timeOptions[index1];
              entity.end = _timeOptions[index2];
            });
          }
        },
        onSelectRowChanged: (section, row) {
          // 选中行发生变化时的回调函数
          int index1 =
              pickerController.selectedRowAt(section: 0)!; // 获取开始时间选项的行索引1
          int index2 =
              pickerController.selectedRowAt(section: 1)!; // 获取结束时间选项的行索引2
          if (index2 < index1) {
            // 如果结束时间选项的行索引小于开始时间选项的行索引1
            pickerController.animateToRow(
                // 动画滚动到行索引1的下一行
                min(_timeOptions.length - 1, index1 + 1),
                atSection: 1);
          }
        },
        builder: (context, popup) {
          // 自定义对话框的构建器函数
          return Container(
            // 对话框容器
            height: 250, // 对话框高度
            child: popup, // 对话框内容
          );
        },
        itemExtent: 40, // 选项行高度
        numberofRowsAtSection: (section) {
          // 获取指定分区的行数
          return _timeOptions.length; // 返回时间选项列表的长度
        },
        itemBuilder: (section, row) {
          // 构建选项行的函数
          return Text(
            // 返回文本部件，显示时间选项
            _timeOptions[row].toString(), // 获取时间选项文本
            style: TextStyle(fontSize: 16), // 设置文本样式
          );
        });
  }

  void _saveAction() {
    // 保存操作的方法
    DialogUtil.showConfirmDialog(context, "确定要保存吗?", () {
      // 弹出确认对话框
      Store.getInstanceReadMode(context).classTime =
          _data; // 将更新后的时间信息存储到数据提供者中
      Navigator.pop(context); // 返回上一个页面
    });
  }
}
