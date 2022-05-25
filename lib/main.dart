import 'package:cpu_scheduler/controllers/disk_table_controller.dart';
import 'package:cpu_scheduler/pages/cpu_scheduling_page/cpu_scheduling_page.dart';
import 'package:cpu_scheduler/pages/disk_scheduling_page/disk_scheduling_page.dart';
import 'package:cpu_scheduler/controllers/table_controller.dart';
import 'package:flutter/material.dart' as mat;
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const FluentApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: MyHomePage(title: 'Cpu Scheduler'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _controller;
  RxString text = 'First Come First Serve'.obs;
  RxString text2 = 'Ascending'.obs;
  TableController controller = TableController();
  FlyoutController open = FlyoutController();
  TextEditingController timeQuantum = TextEditingController();
  DiskTableController diskController = DiskTableController();

  @override
  void initState() {
    timeQuantum.text = '1';
    super.initState();
    _controller = mat.TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(0),
      child: Scaffold(
        appBar: mat.TabBar(
          controller: _controller,
          tabs: const [
            mat.Padding(
              padding: mat.EdgeInsets.all(12.0),
              child: mat.Text(
                "CPU Scheduling",
                style: mat.TextStyle(color: mat.Colors.black),
              ),
            ),
            Padding(
              padding: mat.EdgeInsets.all(12.0),
              child: mat.Text(
                "Disk Scheduling",
                style: mat.TextStyle(color: mat.Colors.black),
              ),
            ),
          ],
        ),
        body: TabBarView(
          controller: _controller,
          children: const [
            // start of 1st tab
            CpuSchedulingPage(),
            // start of 2nd tab
            DiskSchedulingPage(),
          ],
        ),
      ),
    );
  }
}
