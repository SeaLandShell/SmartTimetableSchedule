import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef PickerRowCallBack = int Function(
    int section); // 定义了一个回调函数类型，用于返回每个section中的行数
typedef PickerItemBuilder = Widget Function(
    int section, int row); // 定义了一个回调函数类型，用于构建每个item的Widget
typedef PickerVoidCallBack = void Function(
    int section, int row); // 定义了一个回调函数类型，用于处理选择某一行时的回调

// PickerView类，用于展示一个可滚动的PickerView
class PickerView extends StatefulWidget {
  final PickerRowCallBack numberOfRowsAtSection; // 每个section中行数的回调函数
  final PickerItemBuilder itemBuilder; // 构建每个item的回调函数
  final PickerVoidCallBack? onSelectRowChanged; // 选择某一行时的回调函数
  final double? itemExtent; // 每个item的高度
  final PickerController controller; // 控制器，用于控制PickerView的行为

  // 构造函数
  PickerView({
    required this.numberOfRowsAtSection,
    required this.itemBuilder,
    required this.controller,
    this.itemExtent = 40, // 默认item的高度为40
    this.onSelectRowChanged, // 选择行的回调函数，默认为null
  }) : super(); // 调用父类构造函数

  @override
  State<StatefulWidget> createState() {
    // 创建状态对象的方法
    return PickerViewState(); // 返回一个新的PickerViewState对象
  }
}

// PickerViewState类，用于管理PickerView的状态
class PickerViewState extends State<PickerView> {
  PickerController? _controller; // 控制器对象

  @override
  void initState() {
    // 初始化状态的方法
    super.initState(); // 调用父类的初始化方法
  }

  @override
  void didUpdateWidget(PickerView oldWidget) {
    // 当Widget更新时调用的方法
    super.didUpdateWidget(oldWidget); // 调用父类的方法
    if (widget.controller != oldWidget.controller) {
      // 如果新旧控制器不相同
      _controller = widget.controller; // 更新控制器
    }
  }

  @override
  void didChangeDependencies() {
    // 当依赖关系发生变化时调用的方法
    _controller = widget.controller; // 更新控制器
    super.didChangeDependencies(); // 调用父类的方法
  }

  @override
  Widget build(BuildContext context) {
    // 构建Widget的方法
    return Material(
      // 使用Material组件
      child: Container(
        // 使用Container组件
        color: Colors.white, // 背景颜色为白色
        child: Row(children: _buildPickers()), // 使用Row布局显示所有Picker
      ),
    );
  }

  List<Widget> _buildPickers() {
    // 构建Picker的方法
    List<Widget> children = []; // 创建一个Widget列表

    for (int section = 0; section < _controller!.count; section++) {
      // 遍历所有section
      children.add(Expanded(
          flex: 1,
          child: _buildPickerItem(section: section))); // 添加一个PickerItem到列表中
    }

    return children; // 返回Widget列表
  }

  Widget _buildPickerItem({int? section}) {
    // 构建PickerItem的方法
    FixedExtentScrollController scrollController = _controller!
        .scrollControllers[section!]; // 获取当前section对应的ScrollController

    return Container(
      // 使用Container组件
      child: CupertinoPicker.builder(
        // 使用CupertinoPicker.builder构建Picker
        backgroundColor: Colors.white, // 背景颜色为白色
        scrollController: scrollController, // 设置ScrollController
        diameterRatio: 1, // 直径比率为1
        itemExtent: widget.itemExtent ?? 40, // 设置item的高度，默认为40
        childCount: widget.numberOfRowsAtSection(section), // 获取当前section的行数
        onSelectedItemChanged: (row) {
          // 当选择某一行时的回调函数
          if (widget.onSelectRowChanged != null) {
            // 如果回调函数不为null
            widget.onSelectRowChanged!(section, row); // 调用回调函数
          }
        },
        itemBuilder: (context, row) {
          // 构建每个item的方法
          return Container(
              // 使用Container组件
              alignment: Alignment.center, // 对齐方式为居中
              child: widget.itemBuilder(section, row)); // 返回构建好的item
        },
      ),
    );
  }
}


// PickerController类，用于控制PickerView的行为
class PickerController {
  final int count; // Picker的数量
  final List<FixedExtentScrollController> scrollControllers; // ScrollController列表，用于控制每个Picker的滚动

  // 构造函数
  PickerController({required this.count, List<int>? selectedItems})
      : scrollControllers = [] {
    // 初始化scrollControllers列表
    for (int i = 0; i < count; i++) { // 遍历所有Picker
      if (selectedItems != null && i < selectedItems.length) { // 如果传入了选中项列表，并且当前Picker有对应的选中项
        scrollControllers.add(FixedExtentScrollController(
            initialItem: selectedItems[i])); // 创建ScrollController并添加到列表中
      } else { // 如果没有传入选中项列表，或者当前Picker没有对应的选中项
        scrollControllers
            .add(FixedExtentScrollController()); // 创建一个空的ScrollController添加到列表中
      }
    }
  }

  // 销毁方法
  void dispose() {
    scrollControllers.forEach((item) { // 遍历所有ScrollController
      item.dispose(); // 销毁每个ScrollController
    });
  }

  // 获取当前section选中的行
  int? selectedRowAt({required int section}) {
    try {
      FixedExtentScrollController scrollController =
      scrollControllers[section]; // 获取对应section的ScrollController
      return scrollController.selectedItem; // 返回选中的行
    } catch (err) {
      return null; // 发生错误时返回null
    }
  }

  // 跳转到指定的行
  void jumpToRow(int row, {required int atSection}) {
    try {
      if (scrollControllers.length <= atSection) { // 如果指定的section超出范围
        return; // 直接返回
      }
      FixedExtentScrollController scrollController =
      scrollControllers[atSection]; // 获取对应section的ScrollController
      scrollController
          .jumpToItem(row); // 调用ScrollController的jumpToItem方法跳转到指定的行
    } catch (err) {}
  }

  // 动画滚动到指定的行
  Future<void> animateToRow(
      int row, {
        required int atSection,
        Duration duration = const Duration(milliseconds: 300),
        Curve curve = Curves.easeInOut,
      }) async {
    try {
      if (scrollControllers.length <= atSection) { // 如果指定的section超出范围
        return; // 直接返回
      }
      FixedExtentScrollController scrollController =
      scrollControllers[atSection]; // 获取对应section的ScrollController
      await scrollController.animateToItem(
          row, // 调用ScrollController的animateToItem方法滚动到指定的行
          duration: duration,
          curve: curve);
    } catch (err) {}
  }
}



//PickerView 类是一个具有多个Picker的组件，用于显示可滚动的选择器。
// PickerController 类用于控制 PickerView 的行为，包括滚动到指定行、动画滚动到指定行等。
// PickerRowCallBack、PickerItemBuilder 和 PickerVoidCallBack 是三种回调函数类型，用于构建 PickerView 中每一行的行数、每一行的内容以及选择某一行时的回调。
// PickerView 的构造函数接受 numberOfRowsAtSection、itemBuilder、controller 等参数，用于构建 PickerView 组件。
// PickerView 的 build 方法构建了一个 Row，包含了多个 CupertinoPicker，每个 CupertinoPicker 对应一个 PickerItem。
// PickerController 类包含了多个 FixedExtentScrollController，每个 FixedExtentScrollController 对应一个 PickerItem 的滚动控制。