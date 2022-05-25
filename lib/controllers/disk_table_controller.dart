import 'package:pluto_grid/pluto_grid.dart';
import 'package:get/get.dart';

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

  bool schedule(String text, String timeQuantum) {
    if (stateManager == null) {
      return false;
    } else {
      return true;
    }
  }
}
