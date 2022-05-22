import 'package:cpu_scheduler/process_table.dart';
import 'package:cpu_scheduler/services/warning_message.dart';
import 'package:cpu_scheduler/table_controller.dart';
import 'package:flutter/material.dart' as mat;
import 'package:fluent_ui/fluent_ui.dart';
import 'package:get/get.dart';
import '/services/constants.dart';

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
  // TODO:  Add a controller that will handle when we change the algorithm

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
                  icon: const Icon(FluentIcons.play_solid),
                  label: const Text('Schedule'),
                  onPressed: () {
                    bool success = controller.schedule(text.value);
                    if (!success) {
                      showWarningMessage(
                          context: context,
                          title: 'Uninitialized Burst Time',
                          message:
                              'Please make sure that there is no process with 0 burst time');
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
