import 'package:get/get.dart';

class DiskResultsController {
  late RxInt _totalSeekTime;
  late RxDouble _averageSeektime;

  DiskResultsController() {
    _totalSeekTime = 0.obs;
    _averageSeektime = 0.0.obs;
  }

  void setResults(int totalSeekTime, double averageSeekTime) {
    _totalSeekTime.value = totalSeekTime;
    _averageSeektime.value = averageSeekTime;
  }

  RxInt get totalSeekTime => _totalSeekTime;
  RxDouble get averageSeekTime => _averageSeektime;
}
