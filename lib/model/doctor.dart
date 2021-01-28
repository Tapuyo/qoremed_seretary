import 'working_day.dart';

Future getdoc()async{

}

class Doctor {
  String id;
  String name;
  String firstName;
  String lastName;
  String email;
  String phone;
  String speciality;
  String about;
  String avatar;
  double rating;
  int price;
  int idSpeciality;
  int goodReviews;
  int totaScore;
  int satisfaction;
  int visitDuration;
  List<WorkingDay> workingDays;

  Doctor({
    this.id,
    this.name,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.speciality,
    this.about,
    this.avatar,
    this.rating,
    this.price,
    this.idSpeciality,
    this.goodReviews,
    this.totaScore,
    this.satisfaction,
    this.visitDuration,
    this.workingDays,
  });

  factory Doctor.fromJson(Map<dynamic, dynamic> parsedJson){
    var list = parsedJson['working_days'] as List;
    List<WorkingDay> workingDaysList =
        list.map((i) => WorkingDay.fromJson(i)).toList();
    return Doctor(
      id: parsedJson['user_id'],
      firstName: parsedJson['first_name'],
      lastName: parsedJson['last_name'],
      email: parsedJson['email'],
      phone: parsedJson['phone'],
      about: parsedJson['about'],
      rating: parsedJson['rating'],
      price: parsedJson['price'],
      idSpeciality: parsedJson['id_speciality'],
      speciality: parsedJson['speciality'],
      goodReviews: parsedJson['good_reviews'],
      totaScore: parsedJson['tota_score'],
      satisfaction: parsedJson['satisfaction'],
      visitDuration: parsedJson['visit_duration'],
      workingDays: workingDaysList,
      //workingDays: new List<WorkingDay>.from(parsedJson['working_days']),
    );
  }
}

class Doctors {


  List<Doctor> doctorList;

  Doctors({this.doctorList});

  factory Doctors.fromJSON(Map<dynamic, dynamic> json) {
    return Doctors(doctorList: parserecipes(json));
  }

  static List<Doctor> parserecipes(doctorJSON) {

    var dList = doctorJSON['doctors'] as List;
    List<Doctor> doctorList =
        dList.map((data) => Doctor.fromJson(data)).toList();
    return doctorList;
  }
}



final doctors = [
  Doctor(
    name: 'Tawfiq Bahri',
    speciality: 'Family Doctor, Cardiologist',
    about:
        'Candidate of medical sciences, gynecologist, specialist with experience more than 5 years.',
    avatar: 'assets/images/icon_doctor_1.png',
    rating: 4.5,
    price: 100,
  ),
  Doctor(
    name: 'Trashae Hubbard',
    speciality: 'Family Doctor, Therapist',
    about:
        'Candidate of medical sciences, gynecologist, specialist with experience more than 5 years.',
    avatar: 'assets/images/icon_doctor_2.png',
    rating: 4.7,
    price: 90,
  ),
  Doctor(
    name: 'Jesus Moruga',
    speciality: 'Family Doctor, Therapist',
    about:
        'Candidate of medical sciences, gynecologist, specialist with experience more than 5 years.',
    avatar: 'assets/images/icon_doctor_3.png',
    rating: 4.3,
    price: 100,
  ),
  Doctor(
    name: 'Gabriel Moreira',
    speciality: 'Family Doctor, Therapist',
    about:
        'Candidate of medical sciences, gynecologist, specialist with experience more than 5 years.',
    avatar: 'assets/images/icon_doctor_4.png',
    rating: 4.7,
    price: 100,
  ),
  Doctor(
    name: 'Liana Lee',
    speciality: 'Family Doctor, Therapist',
    about:
        'Candidate of medical sciences, gynecologist, specialist with experience more than 5 years.',
    avatar: 'assets/images/icon_doctor_5.png',
    rating: 4.7,
    price: 100,
  ),
];
