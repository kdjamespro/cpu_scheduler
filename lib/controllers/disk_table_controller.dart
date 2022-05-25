import 'package:cpu_scheduler/services/disk_scheduler.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:get/get.dart';
import '/models/request.dart';
import '/services/constants.dart';

class DiskTableController {
  late PlutoGridStateManager? stateManager;
  late List<PlutoRow> requests;
  late int requestCount;

  DiskTableController() {
    requests = <PlutoRow>[].obs;
    requestCount = 0;
    requests.addAll(List.generate(
      3,
      (index) => PlutoRow(cells: {
        'request_id': PlutoCell(value: 'R${index + 1}'),
        'location': PlutoCell(value: 0),
      }),
    ));
    requestCount += 3;
  }

  void setStateManager(PlutoGridStateManager manager) {
    stateManager = manager;
  }

  void addRequest() {
    if (stateManager == null) {
      return;
    } else {
      final newRows = stateManager!.getNewRows(count: 1);

      for (var e in newRows) {
        e.cells['request_id']!.value = 'R${requestCount + 1}';
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
      requestCount += 1;
    }
  }

  void deleteRequest() {
    if (stateManager == null) {
      return;
    } else {
      stateManager!.removeCurrentRow();
    }
  }

  bool schedule(String text, int currentHead, int trackSize, String direction) {
    if (stateManager == null) {
      return false;
    } else {
      stateManager!.moveScrollByRow(
        PlutoMoveDirection.down,
        stateManager!.refRows.length - 2,
      );
      stateManager!.updateCurrentCellPosition(notify: true);
      List<Request> requests = [];

      for (var row in stateManager!.refRows) {
        requests.add(Request(
          rId: row.cells['request_id']!.value,
          location: row.cells['location']!.value,
        ));
      }
      DiskScheduler scheduler = DiskScheduler(
        requestList: requests,
        trackSize: trackSize,
        startPosition: currentHead,
        direction: direction,
      );

      if (text == diskSchedulingAlgo[0]) {
        print(requests.length);
        for (Request row in requests) {
          print('ID: ${row.id} location: ${row.location}');
        }
        // scheduler.;
      } else if (text == diskSchedulingAlgo[1]) {
        scheduler.sstf();
      } else if (text == diskSchedulingAlgo[2]) {
        scheduler.scan();
      } else if (text == diskSchedulingAlgo[3]) {
        scheduler.look();
      } else if (text == diskSchedulingAlgo[4]) {
        scheduler.cScan();
      } else if (text == diskSchedulingAlgo[5]) {
        scheduler.cLook();
      }
      return true;
    }
  }
}
