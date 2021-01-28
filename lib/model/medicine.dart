class Medicine {
  String id;
  String name;
  String category;
  int daysOfTreat;
  int pillsPerDay;

  Medicine({
    this.id,
    this.name,
    this.category,
    this.daysOfTreat,
    this.pillsPerDay,
  });

  factory Medicine.fromJson(Map<dynamic, dynamic> parsedJson) {
    return Medicine(
      id: parsedJson['id'],
      name: parsedJson['name'],
      category: parsedJson['category'],
      daysOfTreat: parsedJson['days_of_treat'],
      pillsPerDay: parsedJson['pills_per_day'],
    );
  }
}
