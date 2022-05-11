import 'package:cpu_scheduler/process_table.dart';
import 'package:cpu_scheduler/table_controller.dart';
import 'package:flutter/material.dart' as mat;
import 'package:fluent_ui/fluent_ui.dart';
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

class _MyHomePageState extends State<MyHomePage> {
  RxBool simulating = false.obs;
  List<String> cpuSchedulingAlgo = [
    'First Come First Serve',
    'Shortest-Job-First (Non Preemptive)',
    'Shortest-Job-First (Preemptive)',
    'Priority (Non Preemptive)',
    'Priority (Preemptive)',
    'Round Robin',
  ];
  RxString text = 'First Come First Serve'.obs;
  TableController controller = TableController();

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      content: SizedBox(
        height: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CommandBar(
              primaryItems: [
                CommandBarButton(
                  icon: const Icon(FluentIcons.add),
                  label: const Text('Add Process'),
                  onPressed: () {
                    controller.addProcess();
                  },
                ),
                CommandBarButton(
                  icon: const Icon(FluentIcons.delete),
                  label: const Text('Delete Process'),
                  onPressed: () {
                    controller.deleteProcess();
                  },
                ),
                CommandBarButton(
                  icon: const Text('CPU Scheduling Algorithm'),
                  label: SizedBox(
                    width: 280,
                    child: DropDownButton(
                        title: Obx(() => Text(text.value)),
                        items: cpuSchedulingAlgo
                            .map((algo) => MenuFlyoutItem(
                                text: Text(algo),
                                onPressed: () {
                                  text.value = algo;
                                }))
                            .toList()),
                  ),
                  onPressed: () {},
                ),
                CommandBarButton(
                  icon: Obx(() => simulating.isTrue
                      ? const Icon(FluentIcons.stop)
                      : const Icon(FluentIcons.play_solid)),
                  label: Obx(
                    () => simulating.isTrue
                        ? const Text('Stop')
                        : const Text('Start Scheduling Simulation'),
                  ),
                  onPressed: () {
                    if (simulating.isFalse) {
                      simulating.value = true;
                      controller.getData();
                    } else {
                      print('Stopped');
                      simulating.value = false;
                    }
                  },
                ),
              ],
            ),
            Expanded(
                child:
                    mat.Material(child: ProcessTable(controller: controller))),
          ],
        ),
      ),
    );
  }
}

class TestWidget extends StatelessWidget {
  TestWidget({Key? key}) : super(key: key);

  final rowData = [
    {'id': '100', 'title': 'Flutter Basics', 'author': 'David John'},
    {'id': '102', 'title': 'Git and GitHub', 'author': 'Merlin Nick'},
  ];

  @override
  Widget build(BuildContext context) {
    return mat.DataTable(
      columns: const <mat.DataColumn>[
        mat.DataColumn(
            label: Flexible(
          child: Text("",
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.bold)),
        )),
        mat.DataColumn(
            label: Expanded(
          flex: 4,
          child: Text("Nom de l'article",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.bold)),
        )),
      ],
      rows: <mat.DataRow>[
        const mat.DataRow(
          cells: <mat.DataCell>[
            mat.DataCell(mat.TextField(
              decoration: mat.InputDecoration(
                border: mat.OutlineInputBorder(),
                hintText: 'Enter a search term',
              ),
            )),
            mat.DataCell(mat.TextField(
              decoration: mat.InputDecoration(
                border: mat.OutlineInputBorder(),
                hintText: 'Enter a search term',
              ),
            )),
          ],
        ),
        const mat.DataRow(
          cells: <mat.DataCell>[
            mat.DataCell(mat.TextField(
              decoration: mat.InputDecoration(
                border: mat.OutlineInputBorder(),
                hintText: 'Enter a search term',
              ),
            )),
            mat.DataCell(Text('Hello')),
          ],
        ),
        ...rowData
            .map((item) => mat.DataRow(cells: [
                  mat.DataCell(Text('#' + item['id'].toString())),
                  mat.DataCell(Text(item['title'] ?? '')),
                  // mat.DataCell(Text(item['author'] ?? '')),
                  // const mat.DataCell(FlutterLogo())
                ]))
            .toList()
      ],
    );
  }
}
