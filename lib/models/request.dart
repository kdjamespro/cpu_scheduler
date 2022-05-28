class Request implements Comparable<Request> {
  late String _id;
  late int _location;

  Request({required String rId, required int location}) {
    _id = rId;
    _location = location;
  }

  String get id => _id;
  int get location => _location;

  @override
  int compareTo(Request other) {
    if (_location < other.location) {
      return -1;
    } else if (_location > other._location) {
      return 1;
    } else {
      return 0;
    }
  }
}
