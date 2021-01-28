import 'doctor.dart';

class Booking {
  String id;
  Doctor doctor;
  String doctorId;
  String userId;
  String date; // Monday, 3 Feb
  String formattedDate; // dd-MM-yyyy
  String time; // 08:00 AM
  String patient;
  String mobile;
  String patientMobile;
  String email;
  int healthConcern;

  Booking({
    this.id,
    this.doctor,
    this.doctorId,
    this.userId,
    this.date,
    this.formattedDate,
    this.time,
    this.patient,
    this.mobile,
    this.patientMobile,
    this.email,
    this.healthConcern,
  });

  factory Booking.fromJson(Map<dynamic, dynamic> parsedJson) {
    return Booking(
      doctorId: parsedJson['doctor_id'],
      userId: parsedJson['user_id'],
      date: parsedJson['date'],
      time: parsedJson['time'],
      patient: parsedJson['patient'],
      mobile: parsedJson['mobile'],
      patientMobile: parsedJson['patient_mobile'],
      email: parsedJson['email'],
      healthConcern: parsedJson['health_concern'],
    );
  }
}
