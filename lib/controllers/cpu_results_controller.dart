import 'package:cpu_scheduler/models/process.dart';
import 'package:cpu_scheduler/models/process_duration.dart';
import 'package:get/get.dart';

class CpuResultsController {
  late RxInt _completionTime;
  late RxDouble _averageTurnAroundTime, _averageWaitingTime;
  late RxList<ProcessDuration> _processOrder;

  CpuResultsController() {
    _completionTime = 0.obs;
    _averageTurnAroundTime = 0.0.obs;
    _averageWaitingTime = 0.0.obs;
    _processOrder = <ProcessDuration>[].obs;
  }

  void setResults(int completionTime, double averageTurnAroundTime,
      double averageWaitingTime) {
    _completionTime.value = completionTime;
    _averageTurnAroundTime.value = averageTurnAroundTime;
    _averageWaitingTime.value = averageWaitingTime;
  }

  void setOrder(List<ProcessDuration> processOrder) {
    _processOrder.clear();
    _processOrder.addAll(processOrder);
  }

  RxInt get completionTime => _completionTime;
  RxDouble get averageTurnAroundTime => _averageTurnAroundTime;
  RxDouble get averageWaitingTime => _averageWaitingTime;
  RxList<ProcessDuration> get processOrder => _processOrder;
}
