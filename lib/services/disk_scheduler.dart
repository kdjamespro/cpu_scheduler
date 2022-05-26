import 'package:cpu_scheduler/models/request.dart';

class DiskScheduler {
  late List<Request> _requestList;
  late int _totalSeekTime, _startPosition, _trackSize;
  late double _averageSeekTime;
  late bool _ascending = false;

  DiskScheduler({
    required List<Request> requestList,
    required int startPosition,
    required int trackSize,
    required String direction,
  }) {
    _requestList = requestList;
    _startPosition = startPosition;
    _trackSize = trackSize;
    _totalSeekTime = 0;
    _averageSeekTime = 0;
    direction == 'Ascending' ? _ascending = true : _ascending = false;
  }

  int get totalSeekTime => _totalSeekTime;
  double get averageSeekTime => _averageSeekTime;

  void fcfs() {
    int head = _startPosition;
    int totalSeekTime = 0;
    List<Request> requests = List.from(_requestList);

    for (var request in requests) {
      // Compute for the seek time for each request
      totalSeekTime += (request.location - head).abs();
      print('${request.location} - $head = ${(request.location - head).abs()}');

      head = request.location;
    }

    _totalSeekTime = totalSeekTime;
    _averageSeekTime = totalSeekTime / _requestList.length;

    print(_totalSeekTime);
    print(_averageSeekTime);
  }

  void sstf() {
    List<Request> requests = List.from(_requestList);
    int head = _startPosition;
    int totalSeekTime = 0;
    while (requests.isNotEmpty) {
      int minDifference = (requests.first.location - head).abs();
      int minIndex = 0;

      for (int i = 1; i < requests.length; i++) {
        int difference = (requests[i].location - head).abs();
        if (difference == minDifference) {
          if (_ascending) {
            if (requests[minIndex].location > head) {
              continue;
            } else {
              minDifference = difference;
              minIndex = i;
            }
          }
        } else if (difference < minDifference) {
          minDifference = difference;
          minIndex = i;
        }
      }
      print('${requests[minIndex].location} - $head = $minDifference');
      totalSeekTime += minDifference;
      head = requests[minIndex].location;
      requests.remove(requests[minIndex]);
    }

    _totalSeekTime = totalSeekTime;
    _averageSeekTime = totalSeekTime / _requestList.length;

    print(_totalSeekTime);
    print(_averageSeekTime);
  }

  void scan() {
    int head = _startPosition;
    int totalSeekTime = 0;
    int diskEnd = 0;
    List<Request> requests = List.from(_requestList);

    requests.sort();

    int end = 0;
    if (_ascending) {
      end = requests.last.location;
    } else {
      end = requests.first.location;
    }

    List<Request> queue = [];
    int i = requests.indexWhere((element) => element.location >= head) - 1;

    if (_ascending) {
      diskEnd = _trackSize - 1;
      queue.addAll(requests.sublist(i + 1, requests.length));
      queue.addAll(requests.sublist(0, i + 1).reversed);
    } else {
      queue.addAll(requests.sublist(0, i + 1).reversed);
      queue.addAll(requests.sublist(i + 1, requests.length));
    }
    for (var request in queue) {
      // Compute for the seek time for each request in queue
      totalSeekTime += (request.location - head).abs();
      print('${request.location} - $head = ${(request.location - head).abs()}');
      // Check if queue reached the last request
      if (request.location == end) {
        // Compute for the seek time to get from the last request to the end of the disk
        totalSeekTime += (request.location - diskEnd).abs();
        print(
            '${request.location} - $diskEnd = ${(request.location - diskEnd).abs()}');
        // Set the head of the disk at the end
        head = diskEnd;
      } else {
        // Update the head of the disk
        head = request.location;
      }
    }

    _totalSeekTime = totalSeekTime;
    _averageSeekTime = totalSeekTime / _requestList.length;

    print(_totalSeekTime);
    print(_averageSeekTime);
  }

  void cScan() {
    int head = _startPosition;
    int totalSeekTime = 0;
    int diskStart = 0;
    int diskEnd = _trackSize - 1;
    List<Request> requests = List.from(_requestList);

    requests.sort();

    int end = 0;

    if (_ascending) {
      end = requests.last.location;
    } else {
      end = requests.first.location;
    }

    List<Request> queue = [];

    int i = requests.indexWhere((element) => element.location >= head) - 1;

    if (_ascending) {
      queue.addAll(requests.sublist(i + 1, requests.length));
      queue.addAll(requests.sublist(0, i + 1));
    } else {
      queue.addAll(requests.sublist(0, i + 1).reversed);
      queue.addAll(requests.sublist(i + 1, requests.length).reversed);
    }

    for (var request in queue) {
      // Compute for the seek time for each request in queue
      totalSeekTime += (request.location - head).abs();
      print('${request.location} - $head = ${(request.location - head).abs()}');

      // Check if queue reached the last request
      if (request.location == end) {
        if (_ascending) {
          // Compute for the seek time to get from the last request to the end of the disk
          totalSeekTime += (request.location - diskEnd).abs();
          print(
              '${request.location} - $diskEnd = ${(request.location - diskEnd).abs()}');

          // Compute for the seek time of moving from the disk end to zero
          totalSeekTime += (diskEnd - diskStart).abs();
          print('$diskEnd - $diskStart = ${(diskEnd - diskStart).abs()}');

          // Set the head of the disk to 0
          head = 0;
        } else {
          // Compute for the seek time to get from the last request to the end of the disk
          totalSeekTime += (request.location - diskStart).abs();
          print(
              '${request.location} - $diskStart = ${(request.location - diskStart).abs()}');

          // Compute for the seek time of moving from the disk end to zero
          totalSeekTime += (diskStart - diskEnd).abs();
          print('$diskStart - $diskEnd = ${(diskStart - diskEnd).abs()}');

          // Set the head of the disk to 0
          head = diskEnd;
        }
      } else {
        // Update the head of the disk
        head = request.location;
      }
    }

    _totalSeekTime = totalSeekTime;
    _averageSeekTime = totalSeekTime / _requestList.length;

    print(_totalSeekTime);
    print(_averageSeekTime);
  }

  void look() {
    int head = _startPosition;
    int totalSeekTime = 0;
    List<Request> requests = List.from(_requestList);

    // Sort the requests
    requests.sort();

    List<Request> queue = [];
    int i = requests.indexWhere((element) => element.location >= head) - 1;
    if (_ascending) {
      queue.addAll(requests.sublist(i + 1, requests.length));
      queue.addAll(requests.sublist(0, i + 1).reversed);
    } else {
      queue.addAll(requests.sublist(0, i + 1).reversed);
      queue.addAll(requests.sublist(i + 1, requests.length));
    }

    for (var request in queue) {
      // Compute for the seek time for each request in queue
      totalSeekTime += (request.location - head).abs();
      print('${request.location} - $head = ${(request.location - head).abs()}');

      head = request.location;
    }

    _totalSeekTime = totalSeekTime;
    _averageSeekTime = totalSeekTime / _requestList.length;

    print(_totalSeekTime);
    print(_averageSeekTime);
  }

  void cLook() {
    int head = _startPosition;
    int totalSeekTime = 0;
    List<Request> requests = List.from(_requestList);

    // Sort the requests
    requests.sort();

    print(requests);

    List<Request> queue = [];

    int i = requests.indexWhere((element) => element.location >= head) - 1;

    if (_ascending) {
      queue.addAll(requests.sublist(i + 1, requests.length));
      queue.addAll(requests.sublist(0, i + 1));
    } else {
      queue.addAll(requests.sublist(0, i + 1).reversed);
      queue.addAll(requests.sublist(i + 1, requests.length).reversed);
    }

    for (var request in queue) {
      // Compute for the seek time for each request in queue
      totalSeekTime += (request.location - head).abs();
      print('${request.location} - $head = ${(request.location - head).abs()}');

      head = request.location;
    }

    _totalSeekTime = totalSeekTime;
    _averageSeekTime = totalSeekTime / _requestList.length;

    print(_totalSeekTime);
    print(_averageSeekTime);
  }
}
