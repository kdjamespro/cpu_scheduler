class Process implements Comparable<Process> {
  late int _arrivalTime, _burstTime;
  late String _pid;
  int? _priority;
  late String _status;
  late int _waitingTime, _turnAroundTime, _responseTime;

  Process(
      {required String pid,
      required int arrivalTime,
      required int burstTime,
      int? priority}) {
    _pid = pid;
    _arrivalTime = arrivalTime;
    _burstTime = burstTime;
    _priority = _priority;
    _waitingTime = -1;
    _turnAroundTime = -1;
    _responseTime = -1;
  }

  String get pid => _pid;
  int get arrivalTime => _arrivalTime;
  int get burstTime => _burstTime;
  int get waitingTime => _waitingTime;
  int get turnAroundTime => _turnAroundTime;
  int get responseTime => _responseTime;
  int? get priority => _priority;
  String get status => _status;

  void setProcessTime(int waitingTime, int turnAroundTime, int responseTime) {
    _waitingTime = waitingTime;
    _turnAroundTime = turnAroundTime;
    _responseTime = responseTime;
  }

  @override
  int compareTo(Process other) {
    if (_priority != null && other.priority != null) {
      int otherPriority = other.priority ?? 0;
      int priority = _priority ?? 0;
      if (priority < otherPriority) {
        return -1;
      } else if (priority > otherPriority) {
        return 1;
      } else {
        return 0;
      }
    } else {
      if (_arrivalTime < other.arrivalTime) {
        return -1;
      } else if (_arrivalTime > other._arrivalTime) {
        return 1;
      } else {
        return 0;
      }
    }
  }
}
