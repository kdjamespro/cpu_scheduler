import 'package:get/get.dart';

class CpuResultsController {
  late RxInt _completionTime;
  late RxDouble _averageTurnAroundTime, _averageWaitingTime;

  CpuResultsController() {
    _completionTime = 0.obs;
    _averageTurnAroundTime = 0.0.obs;
    _averageWaitingTime = 0.0.obs;
  }

  void setResults(int completionTime, double averageTurnAroundTime,
      double averageWaitingTime) {
    _completionTime.value = completionTime;
    _averageTurnAroundTime.value = averageTurnAroundTime;
    _averageWaitingTime.value = averageWaitingTime;
  }

  RxInt get completionTime => _completionTime;
  RxDouble get averageTurnAroundTime => _averageTurnAroundTime;
  RxDouble get averageWaitingTime => _averageWaitingTime;
}
