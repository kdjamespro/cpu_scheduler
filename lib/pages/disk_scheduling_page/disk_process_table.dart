import 'package:cpu_scheduler/controllers/disk_results_controller.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as mat;
import '../../controllers/disk_table_controller.dart';

class DiskProcessTable extends StatefulWidget {
  const DiskProcessTable(
      {Key? key, required this.controller, required this.results})
      : super(key: key);
  final DiskTableController controller;
  final DiskResultsController results;
  @override
  State<DiskProcessTable> createState() => _DiskProcessTableState();
}

class _DiskProcessTableState extends State<DiskProcessTable> {
  final List<PlutoColumn> columns = [];
  late DiskTableController controller;

  late List<PlutoRow> rows;

  late PlutoGridStateManager stateManager;

  @override
  void initState() {
    super.initState();
    controller = widget.controller;
    columns.addAll([
      PlutoColumn(
        frozen: PlutoColumnFrozen.left,
        title: 'Id',
        field: 'request_id',
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
          TextSpan(text: 'Request ID'),
        ]),
      ),
      PlutoColumn(
        enableColumnDrag: false,
        title: 'Location',
        field: 'location',
        type: PlutoColumnType.number(),
      ),
    ]);

    rows = controller.requests;
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
                padding: const mat.EdgeInsets.all(10),
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
                    stateManager.notifyListeners();
                  },
                  onLoaded: (PlutoGridOnLoadedEvent event) {
                    controller.setStateManager(event.stateManager);
                    stateManager = event.stateManager;
                  },
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
                      child: const Center(child: mat.Text("Graph")),
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
                                'Total Seek Time: ${widget.results.totalSeekTime}',
                                style: FluentTheme.of(context)
                                    .typography
                                    .bodyStrong,
                              ))),
                          Obx((() => Text(
                                'Average Seek Time: ${widget.results.averageSeekTime}',
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
