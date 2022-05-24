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
  RxString text = 'First Come First Serve'.obs;
  TableController controller = TableController();
  FlyoutController open = FlyoutController();
  TextEditingController timeQuantum = TextEditingController();

  @override
  void initState() {
    timeQuantum.text = '1';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      padding: mat.EdgeInsets.all(0),
      content: mat.Container(
        color: Color.fromARGB(255, 250, 250, 250),
        child: SizedBox(
          height: 300,
          child: mat.Padding(
            padding: const EdgeInsets.all(8),
            child: mat.Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  mat.Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    child: mat.Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: Offset(0, 1), // changes position of shadow
                          ),
                        ],
                      ),
                      child: CommandBar(
                        primaryItems: [
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
                            icon: const Icon(FluentIcons.play_solid),
                            label: const Text('Schedule'),
                            onPressed: () {
                              bool success = controller.schedule(
                                  text.value, timeQuantum.text);
                              if (!success) {
                                showWarningMessage(
                                    context: context,
                                    title: 'Uninitialized Burst Time',
                                    message:
                                        'Please make sure that there is no process with 0 burst time');
                              }
                            },
                          ),
                          CommandBarButton(
                            icon: const Icon(FluentIcons.clock),
                            label: Flyout(
                                position: FlyoutPosition.below,
                                placement: FlyoutPlacement.start,
                                controller: open,
                                child: const Text('Time Quantum'),
                                content: (context) {
                                  return FlyoutContent(
                                    child: SizedBox(
                                      width: 50,
                                      child: TextFormBox(
                                          autovalidateMode:
                                              AutovalidateMode.always,
                                          controller: timeQuantum,
                                          onFieldSubmitted: (text) {
                                            if (text == '') {
                                              timeQuantum.text = '1';
                                            }
                                          },
                                          validator: (input) {
                                            if (input != null &&
                                                !GetUtils.isNum(input)) {
                                              timeQuantum.clear();
                                            }
                                          }),
                                    ),
                                  );
                                }),
                            onPressed: () {
                              open.open();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                      child: mat.Material(
                          child: ProcessTable(controller: controller))),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
