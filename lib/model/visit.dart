class Visit {
  String id;
  DateTime date;
  String address;
  String diagnosis;
  String recommendation;
  String userId;
  String doctorId;

  Visit({
    this.id,
    this.date,
    this.address,
    this.diagnosis,
    this.recommendation,
    this.userId,
    this.doctorId,
  });

  factory Visit.fromJson(Map<dynamic, dynamic> parsedJson) {
    return Visit(
      id: parsedJson['id'],
      date: parsedJson['date'].toDate(),
      address: parsedJson['address'],
      diagnosis: parsedJson['diagnosis'],
      recommendation: parsedJson['recommendation'],
      userId: parsedJson['user_id'],
      doctorId: parsedJson['doctor_id'],
    );
  }
}
