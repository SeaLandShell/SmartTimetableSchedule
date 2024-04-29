import 'package:flutter/material.dart'; // 导入 Flutter 的 material 包

class KeepAliveWrapper extends StatefulWidget { // 定义一个 StatefulWidget 类 KeepAliveWrapper
  const KeepAliveWrapper({ // 构造函数，接受 key、child 和 keepAlive 参数
    Key? key, // key 参数
    @required this.child, // 必填的 child 参数
    this.keepAlive = true, // 默认为 true 的 keepAlive 参数
  }) : super(key: key); // 调用父类的构造函数并传入 key 参数

  final Widget? child; // 定义一个 child 字段，类型为 Widget
  final bool keepAlive; // 定义一个 keepAlive 字段，类型为 bool

  @override
  State<KeepAliveWrapper> createState() => _KeepAliveWrapperState(); // 重写 createState 方法，返回 _KeepAliveWrapperState 的实例
}

class _KeepAliveWrapperState extends State<KeepAliveWrapper> // 定义一个 State 类 _KeepAliveWrapperState，继承自 State<KeepAliveWrapper>
    with AutomaticKeepAliveClientMixin { // 混入 AutomaticKeepAliveClientMixin

  @override
  Widget build(BuildContext context) { // 重写 build 方法
    return widget.child!; // 返回 child 字段对应的 Widget
  }

  @override
  bool get wantKeepAlive => widget.keepAlive; // 实现 wantKeepAlive 方法，返回 keepAlive 字段的值

  @override
  void didUpdateWidget(covariant KeepAliveWrapper oldWidget) { // 重写 didUpdateWidget 方法
    if (oldWidget.keepAlive != widget.keepAlive) { // 如果旧的 keepAlive 值与新的不同
      // keepAlive 状态需要更新，实现在 AutomaticKeepAliveClientMixin 中
      updateKeepAlive(); // 调用 updateKeepAlive 方法
    }
    super.didUpdateWidget(oldWidget); // 调用父类的 didUpdateWidget 方法
  }
}