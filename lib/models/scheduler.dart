import 'package:cpu_scheduler/models/process.dart';
import 'package:flutter/foundation.dart';

class Scheduler {
  late List<Process> _processList;
  late int _completionTime;
  late double _aveTurnAroundTime, _aveWaitingTime;

  Scheduler({
    required List<Process> processList,
  }) {
    _processList = processList;
    _completionTime = -1;
    _aveTurnAroundTime = -1;
    _aveWaitingTime = -1;
  }

  int get completionTime => _completionTime;
  double get aveTurnAroundTime => _aveTurnAroundTime;
  double get aveWaitingTime => _aveTurnAroundTime;
  List<Process> get processList => _processList;

  void fCFS() {
    int time = 0;
    for (Process process in _processList) {
      int waitingTime = time - process.arrivalTime;
      time += process.burstTime;
      int turnAroundTime = waitingTime + process.burstTime;
      int responseTime = waitingTime;

      process.setProcessTime(waitingTime, turnAroundTime, responseTime);
    }
    _averageResults(time, _processList);
    _printResults(_processList);
  }

  void nonPreemptiveSJF() {
    int time = 0;
    List<Process> processCopy = List.from(_processList);
    List<Process> processOrder = [];
    int i = 0;

    while (processCopy.isNotEmpty) {
      Process process = processCopy[i];
      processOrder.add(process);

      // Compute for the following time
      int waitingTime = time - process.arrivalTime;
      time += process.burstTime;
      int turnAroundTime = waitingTime + process.burstTime;
      int responseTime = waitingTime;

      // Save the computed time to the process
      process.setProcessTime(waitingTime, turnAroundTime, responseTime);

      // Remove the process from the list copy
      processCopy.removeAt(i);

      // Find the processes that have arrivaltime <= time
      if (processCopy.isNotEmpty) {
        List<Process> queue = processCopy
            .where((element) => element.arrivalTime <= time)
            .toList();

        // Find the process with lowest burst time
        mergeSort(queue, compare: _sortByBurstTime);

        // Find the index of the process with lowest burst time
        i = processCopy.indexOf(queue.first);
      }
    }

    _averageResults(time, processOrder);
    _printResults(processOrder);
  }

  int _sortByBurstTime(Process p0, Process p1) {
    if (p0.burstTime < p1.burstTime) {
      return -1;
    } else if (p0.burstTime < p1.burstTime) {
      return 1;
    }
    return 0;
  }

  void _averageResults(int completionTime, List<Process> order) {
    _completionTime = completionTime;
    double totalTurnAroundTime = 0;
    double totalWaitingTime = 0;
    double totalResponseTime = 0;

    for (Process process in order) {
      totalTurnAroundTime += process.turnAroundTime;
      totalWaitingTime += process.waitingTime;
      totalResponseTime += process.responseTime;
    }

    _aveTurnAroundTime = totalTurnAroundTime / order.length;
    _aveWaitingTime = totalWaitingTime / order.length;
  }

  void _printResults(List<Process> processList) {
    for (Process process in processList) {
      print(
          'ID: ${process.pid} Waiting Time: ${process.waitingTime} TurnAround Time: ${process.turnAroundTime} Response Time: ${process.responseTime}');
    }
    print(
        'Summary: Ave TurnaroundTime : $_aveTurnAroundTime Ave WaitingTime: $_aveWaitingTime');
  }
}
