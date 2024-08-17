import 'package:job_search_app/constants/assets_location.dart';

class Job {
  final int id;
  final String title;
  final String type;
  final int employmentType;
  final int workplace;
  final String description;
  final String domain;
  final int hidden;
  final int featured;
  final int minSalary;
  final int maxSalary;
  final int? hourlyWage;
  final String? internshipMotivation;
  final int? internshipDuration;
  final int yearsOfExperience;
  final String city;
  final String country;
  final String skills;
  final String address;
  final String file;
  final int societe_id;
  final String createdAt;
  final String updatedAt;
  Map<String, dynamic>? companyProfile; // Allow null
  final thumbnail = Assets.googleSvg;

  Job({
    required this.id,
    required this.title,
    required this.type,
    required this.employmentType,
    required this.workplace,
    required this.description,
    required this.domain,
    required this.hidden,
    required this.featured,
    required this.minSalary,
    required this.maxSalary,
    this.hourlyWage,
    this.internshipMotivation,
    this.internshipDuration,
    required this.yearsOfExperience,
    required this.city,
    required this.country,
    required this.skills,
    required this.address,
    required this.file,
    required this.societe_id,
    required this.createdAt,
    required this.updatedAt,
    this.companyProfile, // Allow null
  });
factory Job.fromJson(Map<String, dynamic> json) {
  return Job(
    id: json['id'] as int? ?? 0,
    title: json['title'] as String? ?? '',
    type: json['type'] as String? ?? '',
    employmentType: json['employmentType'] as int? ?? 0,
    workplace: json['workplace'] as int? ?? 0,
    description: json['description'] as String? ?? '',
    domain: json['domain'] as String? ?? '',
    hidden: json['hidden'] as int? ?? 0,
    featured: json['featured'] as int? ?? 0,
    minSalary: json['minSalary'] as int? ?? 0,
    maxSalary: json['maxSalary'] as int? ?? 0,
    hourlyWage: json['hourlyWage'] as int?, // Can be null
    internshipMotivation: json['internshipMotivation'] as String?, // Can be null
    internshipDuration: json['internshipDuration'] as int?, // Can be null
    yearsOfExperience: json['yearsOfExperience'] as int? ?? 0,
    city: json['city'] as String? ?? '',
    country: json['country'] as String? ?? '',
    skills: json['skills'] as String? ?? '',
    address: json['address'] as String? ?? '',
    file: json['file'] as String? ?? '',
    societe_id: json['societe_id'] as int? ?? 0,
    createdAt: json['created_at'] as String? ?? '',
    updatedAt: json['updated_at'] as String? ?? '',
    companyProfile: json['companyProfile'] as Map<String, dynamic>?, // Can be null
  );
}
}
