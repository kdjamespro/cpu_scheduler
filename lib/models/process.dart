import 'package:equatable/equatable.dart';

class Process extends Equatable implements Comparable<Process> {
  late int _arrivalTime, _burstTime;
  late String _pid;
  late String _status;
  late int _waitingTime,
      _turnAroundTime,
      _responseTime,
      _remainingTime,
      _priority;

  Process(
      {required String pid,
      required int arrivalTime,
      required int burstTime,
      required int priority}) {
    _pid = pid;
    _arrivalTime = arrivalTime;
    _burstTime = burstTime;
    _priority = priority;
    _waitingTime = -1;
    _turnAroundTime = -1;
    _responseTime = -1;
    _remainingTime = burstTime;
  }

  String get pid => _pid;
  int get arrivalTime => _arrivalTime;
  int get burstTime => _burstTime;
  int get waitingTime => _waitingTime;
  int get turnAroundTime => _turnAroundTime;
  int get responseTime => _responseTime;
  int get remainingTime => _remainingTime;
  int get priority => _priority;
  String get status => _status;

  @override
  List<Object> get props => [_pid];

  void setWaitingTime(int waitingTime) {
    _waitingTime = waitingTime;
  }

  void setTurnAroundTime(int turnAroundTime) {
    _turnAroundTime = turnAroundTime;
  }

  void setResponseTime(int responseTime) {
    _responseTime = responseTime;
  }

  void updateRemainingTime(int remainingTime) {
    _remainingTime = remainingTime;
  }

  @override
  int compareTo(Process other) {
    if (_arrivalTime < other.arrivalTime) {
      return -1;
    } else if (_arrivalTime > other._arrivalTime) {
      return 1;
    } else {
      return 0;
    }
  }
}
