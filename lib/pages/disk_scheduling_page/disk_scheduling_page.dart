import 'package:cpu_scheduler/controllers/disk_results_controller.dart';
import 'package:cpu_scheduler/controllers/disk_table_controller.dart';
import 'package:cpu_scheduler/pages/disk_scheduling_page/disk_process_table.dart';
import 'package:cpu_scheduler/services/warning_message.dart';
import 'package:flutter/material.dart' as mat;
import 'package:fluent_ui/fluent_ui.dart';
import 'package:get/get.dart';
import '/services/constants.dart';

class DiskSchedulingPage extends StatefulWidget {
  const DiskSchedulingPage({Key? key}) : super(key: key);

  @override
  State<DiskSchedulingPage> createState() => _DiskSchedulingPageState();
}

class _DiskSchedulingPageState extends State<DiskSchedulingPage> {
  RxString text = 'First Come First Serve'.obs;
  RxString text2 = 'Ascending'.obs;
  late DiskTableController diskController;
  late DiskResultsController results;
  TextEditingController currentPosition = TextEditingController();
  TextEditingController trackSize = TextEditingController();

  @override
  void initState() {
    results = DiskResultsController();
    diskController = DiskTableController(results);
    currentPosition.text = '50';
    trackSize.text = '200';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return mat.Container(
      color: const Color.fromARGB(255, 250, 250, 250),
      child: SizedBox(
        height: 300,
        child: mat.Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              mat.Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: mat.Container(
                  decoration: BoxDecoration(
                    color: mat.Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    boxShadow: [
                      BoxShadow(
                        color: mat.Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset:
                            const Offset(0, 1), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      CommandBar(
                        primaryItems: [
                          CommandBarButton(
                            icon: const Text('Disk Scheduling Algorithm'),
                            label: SizedBox(
                              width: 280,
                              child: DropDownButton(
                                  title: Obx(() => Text(text.value)),
                                  items: diskSchedulingAlgo
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
                            label: const Text('Add Request'),
                            onPressed: () {
                              diskController.addRequest();
                            },
                          ),
                          CommandBarButton(
                            icon: const Icon(FluentIcons.delete),
                            label: const Text('Delete Request'),
                            onPressed: () {
                              diskController.deleteRequest();
                            },
                          ),
                          CommandBarButton(
                            icon: const Icon(FluentIcons.play_solid),
                            label: const Text('Schedule'),
                            onPressed: () {
                              int currHead = int.parse(currentPosition.text);
                              int diskSize = int.parse(trackSize.text);
                              bool success = diskController.schedule(
                                  text.value, currHead, diskSize, text2.value);
                              if (!success) {
                                showWarningMessage(
                                    context: context,
                                    title: 'Invalid Current Head Value',
                                    message:
                                        'Please make sure that the value for current position is between 0 and track size - 1');
                              }
                            },
                          ),
                        ],
                      ),
                      CommandBar(
                        primaryItems: [
                          CommandBarButton(
                            icon: const Text('Current Position'),
                            label: SizedBox(
                              width: 40,
                              //height: 35,
                              child: TextFormBox(
                                  controller: currentPosition,
                                  autovalidateMode: AutovalidateMode.always,
                                  validator: (input) {
                                    if (input != null &&
                                        !GetUtils.isNum(input)) {
                                      currentPosition.clear();
                                    }
                                  }),
                            ),
                            onPressed: () {
                              if (currentPosition.text == '') {
                                currentPosition.text = '50';
                              }
                            },
                          ),
                          CommandBarButton(
                            icon: const Text('Track Size'),
                            label: SizedBox(
                              width: 40,
                              //height: 35,
                              child: TextFormBox(
                                  controller: trackSize,
                                  autovalidateMode: AutovalidateMode.always,
                                  validator: (input) {
                                    if (input != null &&
                                        !GetUtils.isNum(input)) {
                                      trackSize.clear();
                                    }
                                  }),
                            ),
                            onPressed: () {
                              if (trackSize.text == '') {
                                trackSize.text = '200';
                              }
                            },
                          ),
                          CommandBarButton(
                            icon: const Text('Direction'),
                            label: SizedBox(
                              width: 280,
                              child: DropDownButton(
                                  title: Obx(() => Text(text2.value)),
                                  items: directions
                                      .map((algo) => MenuFlyoutItem(
                                          text: Text(algo),
                                          onPressed: () {
                                            text2.value = algo;
                                          }))
                                      .toList()),
                            ),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                  child: mat.Material(
                      child: DiskProcessTable(
                controller: diskController,
                results: results,
              ))),
            ],
          ),
        ),
      ),
    );
  }
}
