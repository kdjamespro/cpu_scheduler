import 'package:pluto_grid/pluto_grid.dart';
import 'package:get/get.dart';
import '/models/process.dart';

class TableController {
  late PlutoGridStateManager? stateManager;
  late List<PlutoRow> processess;
  late int processCount;

  TableController() {
    processess = <PlutoRow>[].obs;
    processCount = 0;
    processess.addAll(List.generate(
      3,
      (index) => PlutoRow(cells: {
        'process_id': PlutoCell(value: 'P$index'),
        'arrival_time': PlutoCell(value: 0),
        'burst_time': PlutoCell(value: 0),
        'status': PlutoCell(value: 'saved'),
      }),
    ));
    processCount += 3;
  }

  void setStateManager(PlutoGridStateManager manager) {
    stateManager = manager;
  }

  void addProcess() {
    if (stateManager == null) {
      return;
    } else {
      final newRows = stateManager!.getNewRows(count: 1);

      for (var e in newRows) {
        e.cells['process_id']!.value = 'P$processCount';
        e.cells['status']!.value = 'created';
      }

      stateManager!.appendRows(newRows);

      stateManager!.setCurrentCell(
        newRows.first.cells.entries.first.value,
        stateManager!.refRows.length - 1,
      );

      stateManager!.moveScrollByRow(
        PlutoMoveDirection.down,
        stateManager!.refRows.length - 2,
      );

      stateManager!.setKeepFocus(true);
      processCount += 1;
    }
  }

  void deleteProcess() {
    if (stateManager == null) {
      return;
    } else {
      stateManager!.removeCurrentRow();
    }
  }

  void getData() {
    if (stateManager == null) {
      return;
    } else {
      List<Process> process = [];

      for (var row in stateManager!.refRows) {
        process.add(Process(
            pid: row.cells['process_id']!.value,
            arrivalTime: row.cells['arrival_time']!.value,
            burstTime: row.cells['burst_time']!.value));
      }

      for (var proc in process) {
        print(proc.pid);
        print(proc.arrivalTime);
      }
    }
  }
}
