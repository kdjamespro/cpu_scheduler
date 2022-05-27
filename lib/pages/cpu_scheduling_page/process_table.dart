import 'package:cpu_scheduler/controllers/cpu_results_controller.dart';
import 'package:cpu_scheduler/controllers/table_controller.dart';
import 'package:cpu_scheduler/models/process_duration.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as mat;
import '../../controllers/table_controller.dart';
import 'package:get/get.dart';

class ProcessTable extends StatefulWidget {
  const ProcessTable(
      {Key? key, required this.controller, required this.results})
      : super(key: key);
  final TableController controller;
  final CpuResultsController results;
  @override
  State<ProcessTable> createState() => _ProcessTableState();
}

class _ProcessTableState extends State<ProcessTable> {
  final List<PlutoColumn> columns = [];
  late TableController controller;
  late ScrollController _scrollController;

  late List<PlutoRow> rows;

  late PlutoGridStateManager stateManager;

  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
    controller = widget.controller;
    columns.addAll([
      PlutoColumn(
        frozen: PlutoColumnFrozen.left,
        title: 'Id',
        field: 'process_id',
        type: PlutoColumnType.text(),
        enableColumnDrag: false,
        readOnly: true,
        enableEditingMode: false,
        titleSpan: const TextSpan(children: [
          WidgetSpan(
              child: Icon(
            mat.Icons.lock_outlined,
            size: 17,
          )),
          TextSpan(text: 'Process ID'),
        ]),
      ),
      PlutoColumn(
        enableColumnDrag: false,
        title: 'Arrival Time',
        field: 'arrival_time',
        type: PlutoColumnType.number(),
      ),
      PlutoColumn(
        enableColumnDrag: false,
        title: 'Burst Time',
        field: 'burst_time',
        type: PlutoColumnType.number(),
      ),
      PlutoColumn(
        enableColumnDrag: false,
        title: 'Priority',
        field: 'priority',
        type: PlutoColumnType.number(),
      ),
    ]);

    rows = controller.processess;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 250, 250, 250),
      child: Padding(
        padding: const EdgeInsets.only(left: 8, top: 8, bottom: 8, right: 10),
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: const Offset(0, 1), // changes position of shadow
                    ),
                  ],
                ),
                child: PlutoGrid(
                  columns: columns,
                  rows: rows,
                  configuration: const PlutoGridConfiguration(
                      enterKeyAction: PlutoGridEnterKeyAction.toggleEditing),
                  onChanged: (PlutoGridOnChangedEvent event) {
                    print(event);
                    stateManager.notifyListeners();
                  },
                  onLoaded: (PlutoGridOnLoadedEvent event) {
                    controller.setStateManager(event.stateManager);
                    stateManager = event.stateManager;
                  },
                  // createHeader: (stateManager) => _Header(stateManager: stateManager),
                ),
              ),
            ),
            Container(
              width: 475,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.only(bottom: 4, left: 8),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: const Offset(
                                0, 1), // changes position of shadow
                          ),
                        ],
                      ),
                      width: double.infinity,
                      child: SizedBox(
                        height: 32,
                        child: Center(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            controller: _scrollController,
                            child: Obx(
                              () => Row(
                                  children: widget
                                          .results.processOrder.isNotEmpty
                                      ? List.generate(
                                          widget.results.processOrder.length,
                                          (index) {
                                          ProcessDuration element = widget
                                              .results.processOrder
                                              .elementAt(index);
                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    height: 48,
                                                    width: 80,
                                                    color: element.displayColor,
                                                    child: Center(
                                                      child: Text(
                                                        element.pid,
                                                        style: FluentTheme.of(
                                                                context)
                                                            .typography
                                                            .bodyStrong!
                                                            .copyWith(
                                                                color: element
                                                                    .fontColor),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Container(
                                                height: 24,
                                                width: 80,
                                                child: Row(children: [
                                                  index > 0
                                                      ? const SizedBox()
                                                      : Text(
                                                          '${element.startTime}'),
                                                  const Spacer(),
                                                  Text('${element.endTime}')
                                                ]),
                                              ),
                                            ],
                                          );
                                        })
                                      : []),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.only(top: 4, left: 8),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: const Offset(
                                0, 1), // changes position of shadow
                          ),
                        ],
                      ),
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Obx((() => Text(
                                'Completion Time: ${widget.results.completionTime}',
                                style: FluentTheme.of(context)
                                    .typography
                                    .bodyStrong,
                              ))),
                          Obx((() => Text(
                                'Average Turn Around Time: ${widget.results.averageTurnAroundTime}',
                                style: FluentTheme.of(context)
                                    .typography
                                    .bodyStrong,
                              ))),
                          Obx((() => Text(
                                'Average Waiting Time: ${widget.results.averageWaitingTime}',
                                style: FluentTheme.of(context)
                                    .typography
                                    .bodyStrong,
                              ))),
                        ],
                      ),
                    ),
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
