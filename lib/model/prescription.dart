import 'doctor.dart';

class Prescription {
  String id;
  String name;
  DateTime date;
  String userId;
  String doctorId;
  Doctor doctor;

  Prescription({
    this.id,
    this.name,
    this.date,
    this.userId,
    this.doctorId,
    this.doctor,
  });

  factory Prescription.fromJson(Map<dynamic, dynamic> parsedJson) {
    return Prescription(
      id: parsedJson['id'],
      name: parsedJson['name'],
      date: parsedJson['date'].toDate(),
      userId: parsedJson['user_id'],
      doctorId: parsedJson['doctor_id'],
    );
  }
}
