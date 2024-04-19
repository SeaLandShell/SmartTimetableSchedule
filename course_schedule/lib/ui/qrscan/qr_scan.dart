import 'package:flutter/cupertino.dart'; // 导入Flutter框架的Cupertino库，用于iOS风格的UI组件
import 'package:flutter/material.dart'; // 导入Flutter框架的material库，用于Material风格的UI组件
import 'package:scan/scan.dart'; // 导入名为scan的扫描库

class QRCodeScanPage extends StatelessWidget {
  // QR码扫描页面的无状态组件
  final ScanController controller = ScanController(); // 扫描控制器对象，用于控制扫描操作

  @override
  Widget build(BuildContext context) {
    // 构建页面的方法
    return Container(
      // 容器组件，用于包裹扫描视图
      child: ScanView(
        // 扫描视图组件，用于展示扫描界面
        controller: controller, // 指定扫描控制器
        scanAreaScale: .7, // 扫描区域的比例，设置为0.7表示扫描区域为整个视图的70%
        scanLineColor: Colors.green.shade400, // 扫描线的颜色，设置为浅绿色
        onCapture: (data) {
          // 扫描到结果时的回调函数
          Navigator.pop(context, data); // 返回扫描到的数据
        },
      ),
    );
  }
}
