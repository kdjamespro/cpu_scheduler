class Process {
  int arrivalTime, burstTime;
  String pid;
  int? priority;
  late String status;

  Process(
      {required this.pid,
      required this.arrivalTime,
      required this.burstTime,
      this.priority})
      : super();
}
