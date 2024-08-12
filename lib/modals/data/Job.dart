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
  final String? internshipDuration;
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
      id: json['id'] as int,
      title: json['title'] as String,
      type: json['type'] as String,
      employmentType: json['employmentType'] as int,
      workplace: json['workplace'] as int,
      description: json['description'] as String,
      domain: json['domain'] as String,
      hidden: json['hidden'] as int,
      featured: json['featured'] as int,
      minSalary: json['minSalary'] as int,
      maxSalary: json['maxSalary'] as int,
      hourlyWage: json['hourlyWage'] != null ? json['hourlyWage'] as int : null,
      internshipMotivation: json['internshipMotivation'] != null ? json['internshipMotivation'] as String : null,
      internshipDuration: json['internshipDuration'] != null ? json['internshipDuration'] as String : null,
      yearsOfExperience: json['yearsOfExperience'] as int,
      city: json['city'] as String,
      country: json['country'] as String,
      skills: json['skills'] as String,
      address: json['address'] as String,
      file: json['file'] as String,
      societe_id: json['societe_id'] as int,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      companyProfile: json['companyProfile'] != null ? json['companyProfile'] as Map<String, dynamic> : null, // Allow null
    );
  }
}
