class WorkingDay {
  String name;
  List<String> hours;

  WorkingDay({
    this.name,
    this.hours,
  });

  factory WorkingDay.fromJson(Map<dynamic, dynamic> parsedJson) {
    return WorkingDay(
      name: parsedJson['name'],
      hours: new List<String>.from(parsedJson['hours']),
    );
  }
}
