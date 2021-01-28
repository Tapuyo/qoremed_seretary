import 'package:flutter/material.dart';

class HealthCategory {
  int id;
  String name;
  String imagePath;
  String typem;

  HealthCategory({
    @required this.id,
    @required this.name,
    @required this.imagePath,
    @required this.typem,
  });
}

final healthCategories = [
  HealthCategory(
    id: 0,
    name: 'category_women_health',
    imagePath: 'assets/images/pregnant.png',
    typem: 'Obstetrician/Gynecologist'
  ),
  HealthCategory(
    id: 1,
    name: 'category_skin',
    imagePath: 'assets/images/personal-care.png',
    typem: 'Dermatologist'
  ),
  HealthCategory(
    id: 2,
    name: 'category_child',
    imagePath: 'assets/images/baby.png',
    typem: 'Pediatrician'
  ),
  HealthCategory(
    id: 3,
    name: 'category_general_physician',
    imagePath: 'assets/images/stethoscope.png',
    typem: 'Family Medicine Physician'
  ),
  HealthCategory(
    id: 4,
    name: 'category_dental',
    imagePath: 'assets/images/dental-care.png',
    typem: 'Dentist'
  ),
  HealthCategory(
    id: 5,
    name: 'category_ear',
    imagePath: 'assets/images/throat.png',
    typem: 'Otolaryngologist'
  ),
  HealthCategory(
    id: 6,
    name: 'category_homoetherapy',
    imagePath: 'assets/images/medicine.png',
    typem: ''
  ),
  HealthCategory(
    id: 7,
    name: 'category_bone',
    imagePath: 'assets/images/knee.png',
    typem: 'Orthopedic'
  ),
  HealthCategory(
    id: 8,
    name: 'category_sex_specialist',
    imagePath: 'assets/images/sex.png',
    typem: ''
  ),
  HealthCategory(
    id: 9,
    name: 'category_eye',
    imagePath: 'assets/images/view.png',
    typem: 'Ophthalmologist'
  ),
  HealthCategory(
    id: 10,
    name: 'category_digestive',
    imagePath: 'assets/images/stomach.png',
    typem: 'Gastroenterologist'
  ),
  HealthCategory(
    id: 11,
    name: 'category_mental',
    imagePath: 'assets/images/love.png',
    typem: 'Psychiatrist'
  ),
  HealthCategory(
    id: 12,
    name: 'category_physiotherapy',
    imagePath: 'assets/images/healthcare-and-medical.png',
    typem: ''
  ),
  HealthCategory(
    id: 13,
    name: 'category_diabetes',
    imagePath: 'assets/images/glucosemeter.png',
    typem: ''
  ),
  HealthCategory(
    id: 14,
    name: 'category_brain',
    imagePath: 'assets/images/stethoscope-2.png',
    typem: 'Neurologist'
  ),
  HealthCategory(
    id: 15,
    name: 'category_general_surgery',
    imagePath: 'assets/images/surgeon.png',
    typem: 'Surgeon'
  ),
  HealthCategory(
    id: 16,
    name: 'category_lungs',
    imagePath: 'assets/images/lungs.png',
    typem: 'Pulmonologist'
  ),
  HealthCategory(
    id: 17,
    name: 'category_heart',
    imagePath: 'assets/images/electrocardiogram.png',
    typem: 'Cardiologist'
  ),
  HealthCategory(
    id: 18,
    name: 'category_cancer',
    imagePath: 'assets/images/ribbon.png',
    typem: ''
  ),
];
