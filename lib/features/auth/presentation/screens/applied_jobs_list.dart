import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:portail_tn/constants/dimensions.dart';
import 'package:portail_tn/constants/named_routes.dart';
import 'package:portail_tn/controllers/data_controller.dart';
import 'package:portail_tn/features/auth/presentation/screens/full_page_job.dart';
import 'package:portail_tn/features/auth/presentation/screens/profile_screen_recruter.dart';
import 'package:portail_tn/modals/data/Job.dart';
import 'package:portail_tn/themes/color_styles.dart';
import 'package:portail_tn/themes/font_styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppliedJobList extends StatefulWidget {
  AppliedJobList({super.key});

  @override
  _AppliedJobListState createState() => _AppliedJobListState();
}

class _AppliedJobListState extends State<AppliedJobList> {
  final DataController controller = Get.put(DataController());
  final Map<int, String> companyNames = {};
  final Map<int, String> companyLogos = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Vos candidatures',
          style: TextStyle(
            color: ColorStyles.darkTitleColor,
            fontSize: 19,
            fontWeight: FontWeight.w800,
          ),
        ),
        backgroundColor: ColorStyles.pureWhite,
      ),
       bottomNavigationBar: BottomNavigationBar(
          elevation: 1,
          backgroundColor: Colors.white,
          selectedItemColor: Color.fromARGB(255, 43, 57, 82),
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Accueil',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmark),
              label: 'Vos candidats',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profil',
            ),
          ],
          onTap: (index) {
            if (index == 0) {
              Get.toNamed(NamedRoutes.homeScreenRecruter);
            } else if (index == 1) {
              Get.toNamed(NamedRoutes.appliedJobList);
            } else {
            }
          },
        ),
      body: FutureBuilder<List<Job>>(
        future: _fetchAppliedJobs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error fetching jobs!',
                style: FontStyles.boldStyle,
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No applied jobs!'),
            );
          }

          final jobs = snapshot.data!;
          // Fetch company data after jobs are retrieved

          return ListView.builder(
            itemCount: jobs.length,
            itemBuilder: (context, index) {
              final job = jobs[index];
              final companyName = companyNames[job.societe_id] ?? 'Unknown';
              final companyLogo = companyLogos[job.societe_id] ??
                  'https://via.placeholder.com/150'; // Placeholder image URL

              return GestureDetector(
                onTap: () {
                  _navigateToJobDetails(job);
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: scaleHeight(10, context),
                    horizontal: scaleWidth(12, context),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(scaleWidth(12, context)),
                    decoration: BoxDecoration(
                      color: index % 2 == 0
                          ? ColorStyles.c5386E4
                          : const Color(0xFF3A5C99),
                      borderRadius:
                          BorderRadius.circular(scaleRadius(8, context)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          //rounded white backgreound
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.circular(scaleWidth(30, context)),
                          ),
                          child: Image.network(
                            'http://localhost:8000/api/societe/logo/${job.societe_id}',
                            width: scaleWidth(60, context),
                            height: scaleHeight(60, context),
                          ),
                        ),
                        SizedBox(width: scaleWidth(12, context)),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                job.title,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: scaleHeight(2, context)),
                              Text(
                                job.description,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(height: scaleHeight(2, context)),
                              Text(
                                'Location: ${job.city}, ${job.country}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: scaleHeight(2, context)),
                              Text(
                                'Postulé le : ' +
                                    job.createdAt.substring(0, 10),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<List<Job>> _fetchAppliedJobs() async {
    // Get the user ID from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId') ?? 0; // Default to 0 if not found

    if (userId == 0) {
      throw Exception('User ID not found');
    }

    final response = await http
        .get(Uri.parse('http://localhost:8000/api/postulation/user/$userId'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body) as List<dynamic>;
      final jobs = data.map((item) {
        final jobData = item['offre'] as Map<String, dynamic>;
        print(jobData);
        return Job.fromJson(jobData);
      }).toList();
      return jobs;
    } else {
      throw Exception('Failed to load applied jobs');
    }
  }

  void _navigateToJobDetails(Job job) {
    Get.to(() => FullPageJob(),
        arguments: job); // Pass the job details to FullPageJob
  }
}
