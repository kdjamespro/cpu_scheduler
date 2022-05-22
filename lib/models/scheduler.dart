import 'package:cpu_scheduler/models/process.dart';
import 'package:collection/collection.dart';

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

      // Save the results in the process object
      process.setWaitingTime(waitingTime);
      process.setTurnAroundTime(turnAroundTime);
      process.setResponseTime(responseTime);
    }
    _averageResults(time, _processList);
    _printResults(_processList);
  }

  void nonPreemptiveSJF() {
    int time = 0;
    List<Process> processCopy = List.from(_processList);
    List<Process> processOrder = [];

    // locates the process with lowest burstTime
    int i = processCopy.indexOf(processCopy.firstWhere(
        (element) =>
            element.arrivalTime == processCopy.first.arrivalTime &&
            element.burstTime < processCopy.first.burstTime,
        orElse: () => processCopy.first));

    while (processCopy.isNotEmpty) {
      Process process = processCopy[i];
      processOrder.add(process);

      // Compute for the following time
      int waitingTime = time - process.arrivalTime;
      time += process.burstTime;
      int turnAroundTime = waitingTime + process.burstTime;
      int responseTime = waitingTime;

      // Save the results in the process object
      process.setWaitingTime(waitingTime);
      process.setTurnAroundTime(turnAroundTime);
      process.setResponseTime(responseTime);

      // Remove the process from the list copy
      processCopy.removeAt(i);

      // Find the processes that have arrivaltime <= time
      if (processCopy.isNotEmpty) {
        List<Process> queue = processCopy
            .where((element) => element.arrivalTime <= time)
            .toList();

        // Find the process with lowest burst time
        mergeSort(queue, compare: _compareByBurstTime);

        // Find the index of the process with lowest burst time
        i = processCopy.indexOf(queue.first);
      }
    }

    _averageResults(time, processOrder);
    _printResults(processOrder);
  }

  void preemptiveSJF() {
    int time = 1;
    List<Process> processCopy = List.from(_processList);
    PriorityQueue<Process> queue = PriorityQueue(_compareByRemainingTime);
    List<Process> processOrder = [];

    // Tracks the processes that haven't arrived yet in the scheduler
    List<Process> notYetArrived = List.from(processCopy);

    // index that used to access the process from the list
    int i = processCopy.indexOf(processCopy.firstWhere(
        (element) =>
            element.arrivalTime == processCopy.first.arrivalTime &&
            element.burstTime < processCopy.first.burstTime,
        orElse: () => processCopy.first));

    while (processCopy.isNotEmpty) {
      Process process = processCopy[i];

      // Add the process if its not present in the queue
      if (!queue.contains(process)) {
        queue.add(process);
      }

      // Remove the process from the list when it arrive
      if (notYetArrived.contains(process)) {
        notYetArrived.remove(process);
      }

      // Check if the time corresponds to a process arrival time
      if (notYetArrived.map((p) => p.arrivalTime).toList().contains(time)) {
        // Catches multiple process arrivals given a specific time
        List<Process> arrivals = notYetArrived
            .where((element) => element.arrivalTime == time)
            .toList();

        // Gets the first process in the list generated
        Process earliestArrival = arrivals.first;
        queue.add(earliestArrival);
        notYetArrived.remove(earliestArrival);

        // Checks the process with least amount of burst time.
        for (int i = 1; i < arrivals.length; i++) {
          if (arrivals[i].remainingTime < earliestArrival.remainingTime) {
            earliestArrival = arrivals[i];
          }
          queue.add(arrivals[i]);
          notYetArrived.remove(arrivals[i]);
        }

        if (process.remainingTime > earliestArrival.remainingTime) {
          processOrder.add(process);
          i = processCopy.indexOf(earliestArrival);
        }
      }

      process.updateRemainingTime(process.remainingTime - 1);
      queue.remove(process);
      // Checks if the process already ended
      if (process.remainingTime == 0) {
        int turnAroundTime = time - process.arrivalTime;
        int waitingTime = turnAroundTime - process.burstTime;

        processOrder.add(process);
        process.setTurnAroundTime(turnAroundTime);
        process.setWaitingTime(waitingTime);
        processCopy.remove(process);

        if (queue.isNotEmpty && processCopy.isNotEmpty) {
          i = processCopy.indexOf(queue.first);
        }
      } else {
        queue.add(process);
      }
      if (processCopy.isNotEmpty) {
        time += 1;
      }
    }
    print(time);
    _printProcessInfo();
    _averageResults(time, _processList);
    _printResults(processOrder);
  }

// For priority algorithms, lower priority value = higher priority
  void nonPreemptivePriority() {
    List<Process> processCopy = List.from(_processList);
    List<Process> queue = [];
    List<Process> processOrder = [];

    // Tracks the processes that haven't arrived yet in the scheduler
    List<Process> notYetArrived = List.from(processCopy);

    int time = 1;
    int i = processCopy.indexOf(processCopy.firstWhere(
        (element) =>
            element.arrivalTime == processCopy.first.arrivalTime &&
            element.priority > processCopy.first.priority,
        orElse: () => processCopy.first));

    while (processCopy.isNotEmpty) {
      Process process = processCopy[i];
      // Add the process if its not present in the queue
      if (!queue.contains(process)) {
        queue.add(process);
      }

      // Remove the process from the list when it arrive
      if (notYetArrived.contains(process)) {
        notYetArrived.remove(process);
      }

      // Check if the time corresponds to a process arrival time
      if (notYetArrived.map((p) => p.arrivalTime).toList().contains(time)) {
        // Catches multiple process arrivals given a specific time
        List<Process> arrivals = notYetArrived
            .where((element) => element.arrivalTime == time)
            .toList();

        // Checks the process with least amount of burst time.
        for (Process arrived in arrivals) {
          queue.add(arrived);
          notYetArrived.remove(arrived);
        }
      }

      process.updateRemainingTime(process.remainingTime - 1);
      if (process.remainingTime == 0) {
        int turnAroundTime = time - process.arrivalTime;
        int waitingTime = turnAroundTime - process.burstTime;

        processOrder.add(process);
        process.setTurnAroundTime(turnAroundTime);
        process.setWaitingTime(waitingTime);
        processCopy.remove(process);
        queue.remove(process);

        if (queue.isNotEmpty && processCopy.isNotEmpty) {
          queue.sort(_compareByPriority);
          i = processCopy.indexOf(queue.first);
        }
      }

      if (processCopy.isNotEmpty) {
        time += 1;
      }
    }
  }

  void preemptivePriority() {
    List<Process> processCopy = List.from(_processList);
    List<Process> queue = [];
    List<Process> processOrder = [];

    // Tracks the processes that haven't arrived yet in the scheduler
    List<Process> notYetArrived = List.from(processCopy);

    int time = 1;
    int i = processCopy.indexOf(processCopy.firstWhere(
        (element) =>
            element.arrivalTime == processCopy.first.arrivalTime &&
            element.priority > processCopy.first.priority,
        orElse: () => processCopy.first));

    while (processCopy.isNotEmpty) {
      Process process = processCopy[i];
      // Add the process if its not present in the queue
      if (!queue.contains(process)) {
        queue.add(process);
      }

      // Remove the process from the list when it arrive
      if (notYetArrived.contains(process)) {
        notYetArrived.remove(process);
      }

      // Check if the time corresponds to a process arrival time
      if (notYetArrived.map((p) => p.arrivalTime).toList().contains(time)) {
        // Catches multiple process arrivals given a specific time
        List<Process> arrivals = notYetArrived
            .where((element) => element.arrivalTime == time)
            .toList();

        // Gets the first process in the list generated
        Process priorityProcess = arrivals.first;
        queue.add(priorityProcess);
        notYetArrived.remove(priorityProcess);

        // Checks the process with least amount of burst time.
        for (int i = 1; i < arrivals.length; i++) {
          if (arrivals[i].remainingTime < priorityProcess.remainingTime) {
            priorityProcess = arrivals[i];
          }
          queue.add(arrivals[i]);
          notYetArrived.remove(arrivals[i]);
        }

        if (process.priority > priorityProcess.priority) {
          processOrder.add(process);
          i = processCopy.indexOf(priorityProcess);
        }
      }

      process.updateRemainingTime(process.remainingTime - 1);
      if (process.remainingTime == 0) {
        int turnAroundTime = time - process.arrivalTime;
        int waitingTime = turnAroundTime - process.burstTime;

        processOrder.add(process);
        process.setTurnAroundTime(turnAroundTime);
        process.setWaitingTime(waitingTime);
        processCopy.remove(process);
        queue.remove(process);

        if (queue.isNotEmpty && processCopy.isNotEmpty) {
          queue.sort(_compareByPriority);
          i = processCopy.indexOf(queue.first);
        }
      }

      if (processCopy.isNotEmpty) {
        time += 1;
      }
    }

    print(time);
    _averageResults(time, _processList);
    _printResults(processOrder);
  }

  int _compareByBurstTime(Process p0, Process p1) {
    if (p0.burstTime < p1.burstTime) {
      return -1;
    } else if (p0.burstTime > p1.burstTime) {
      return 1;
    }
    return 0;
  }

  int _compareByRemainingTime(Process p0, Process p1) {
    if (p0.remainingTime < p1.remainingTime) {
      return -1;
    } else if (p0.remainingTime > p1.remainingTime) {
      return 1;
    }
    return 0;
  }

  int _compareByPriority(Process p0, Process p1) {
    if (p0.priority < p1.priority) {
      return -1;
    } else if (p0.priority > p1.priority) {
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

  void _printProcessInfo() {
    for (Process process in processList) {
      print(
          'ID: ${process.pid} Arrival Time: ${process.arrivalTime} Burst Time: ${process.burstTime}');
    }
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
