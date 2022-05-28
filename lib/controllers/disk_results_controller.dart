import 'package:get/get.dart';

class DiskResultsController {
  late RxInt _totalSeekTime;
  late RxDouble _averageSeektime;
  late RxDouble _trackStart;
  late RxDouble _trackEnd;
  late RxList<double> _accessOrder;

  DiskResultsController() {
    _totalSeekTime = 0.obs;
    _averageSeektime = 0.0.obs;
    _trackEnd = 0.0.obs;
    _trackStart = 0.0.obs;
    _accessOrder = <double>[].obs;
  }

  void setResults(
      int totalSeekTime, double averageSeekTime, List<double> accessOrder) {
    _totalSeekTime.value = totalSeekTime;
    _averageSeektime.value = averageSeekTime;
    _accessOrder.clear();
    _accessOrder.addAll(accessOrder);
  }

  void setTrackRange(int trackStart, int trackEnd) {
    _trackStart.value = trackStart.toDouble();
    _trackEnd.value = trackEnd.toDouble();
  }

  RxInt get totalSeekTime => _totalSeekTime;
  RxDouble get averageSeekTime => _averageSeektime;
  RxDouble get trackStart => _trackStart;
  RxDouble get trackEnd => _trackEnd;
  RxList<double> get accessOrder => _accessOrder;
}
