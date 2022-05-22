import 'package:cpu_scheduler/models/scheduler.dart';
import 'package:cpu_scheduler/services/warning_message.dart';
import 'package:flutter/foundation.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:get/get.dart';
import '/models/process.dart';
import '/services/constants.dart';
// import 'package:collection/collection.dart' as col;

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
        'process_id': PlutoCell(value: 'P${index + 1}'),
        'arrival_time': PlutoCell(value: 0),
        'burst_time': PlutoCell(value: 0),
        'priority': PlutoCell(value: 0),
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
        e.cells['process_id']!.value = 'P${processCount + 1}';
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

  bool schedule(String text) {
    if (stateManager == null) {
      return false;
    } else {
      List<Process> process = [];
      bool abort = false;
      for (var row in stateManager!.refRows) {
        int val = row.cells['burst_time']!.value;
        if (val == 0) {
          abort = true;
        }
      }
      if (abort) {
        return false;
      }
      for (var row in stateManager!.refRows) {
        process.add(Process(
          pid: row.cells['process_id']!.value,
          arrivalTime: row.cells['arrival_time']!.value,
          burstTime: row.cells['burst_time']!.value,
          priority: row.cells['priority']!.value,
        ));
      }

      // Sort the processes by arrival time or priority
      mergeSort(process);

      Scheduler scheduler = Scheduler(processList: process);
      if (text == cpuSchedulingAlgo[0]) {
        scheduler.fCFS();
      } else if (text == cpuSchedulingAlgo[1]) {
        scheduler.nonPreemptiveSJF();
      } else if (text == cpuSchedulingAlgo[2]) {
        scheduler.preemptiveSJF();
      } else if (text == cpuSchedulingAlgo[3]) {
        scheduler.nonPreemptivePriority();
      } else if (text == cpuSchedulingAlgo[4]) {
        scheduler.preemptivePriority();
      }

      return true;
    }
  }
}
