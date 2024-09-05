// ignore_for_file: inference_failure_on_function_invocation

import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart'; // Add this for spinner

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:job_search_app/features/auth/presentation/screens/full_page_job_recruter.dart';
import 'package:job_search_app/features/auth/presentation/screens/post_job.dart';
import 'package:job_search_app/features/auth/presentation/screens/profile_screen_recruter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:job_search_app/constants/assets_location.dart';
import 'package:job_search_app/constants/dimensions.dart';
import 'package:job_search_app/constants/strings.dart';
import 'package:job_search_app/features/auth/data/controllers/auth_functions.dart';
import 'package:job_search_app/features/widgets/display_card.dart';
import 'package:job_search_app/features/widgets/featured_jobs_tile.dart';
import 'package:job_search_app/features/widgets/horizontal_space.dart';
import 'package:job_search_app/features/widgets/profile_header.dart';
import 'package:job_search_app/features/widgets/search_job.dart';
import 'package:job_search_app/features/widgets/vetical_space.dart';
import 'package:job_search_app/modals/data/Job.dart';
import 'package:job_search_app/utils/skeleton_loader.dart';

import '../../../../themes/color_styles.dart';
import 'full_page_job.dart';

class HomeScreenRecruter extends StatefulWidget {
  const HomeScreenRecruter({super.key});

  @override
  State<HomeScreenRecruter> createState() => _HomeScreenRecruterState();
}

class _HomeScreenRecruterState extends State<HomeScreenRecruter> {
  List<Job> jobs = [];
  List<Job> jobsList = [];  // Define as an instance variable
  List<Job> internshipsList = [];  // Define as an instance variable
  List<Job> filteredFeaturedJobs = [];
  List<String> categories = [];
  String profileName = '';
  Map<int, String> companyNames = {};
  Map<int, String> companyLogos = {};
  bool loading = true;
  String? selectedCategory;
  String? companyName = "";
  String? companyId;  // Remove 'late' and initialize with null

  @override
  void initState() {
    super.initState();
    _loadUserData();
    fetchJobs();
  }

  void showSignOutDialog(BuildContext context) {
    Get.defaultDialog(
      title: '',
      titleStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
        color: Colors.black,
      ),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Voulez-vous vraiment vous déconnecter ?',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      backgroundColor: Colors.white,
      radius: 10,
      confirm: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () {
            AuthFunctions.signOutUser(context);
          },
          child: Text('Oui'),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      cancel: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () {
            Get.back();
          },
          child: Text('Non'),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.grey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  Future<void> fetchJobs() async {
  setState(() {
    loading = true;
  });

  final prefs = await SharedPreferences.getInstance();
  final companyId = prefs.getInt('companyId')?.toString();

  if (companyId != null) {
    final response = await http.get(
      Uri.parse('http://localhost:8000/api/offre/societe/$companyId'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jobList = json.decode(response.body) as List<dynamic>;
      print(jobList);

      await Future.delayed(const Duration(seconds: 4)); // Simulate network delay

      setState(() {
        jobs = jobList
            .map((data) => Job.fromJson(data as Map<String, dynamic>))
            .toList();
        jobsList = jobs.where((job) => job.type == 'job').toList();
        internshipsList = jobs.where((job) => job.type == 'internship').toList();
        filteredFeaturedJobs = jobsList;
        categories = jobsList.map((job) => job.domain).toSet().toList();
        loading = false;
      });

      _fetchCompanyData();
    } else {
      setState(() {
        loading = false;
      });
      throw Exception('Failed to load jobs');
    }
  } else {
    setState(() {
      loading = false;
    });
    throw Exception('Company ID not found');
  }
}


  Future<void> _fetchCompanyData() async {
    for (var job in jobs) {
      final companyId = job.societe_id;
      if (companyId == null) continue;

      final profileResponse = await http.get(
          Uri.parse('http://localhost:8000/api/societe/profile/$companyId'));
      if (profileResponse.statusCode == 200) {
        final companyData =
            json.decode(profileResponse.body) as Map<String, dynamic>;
        print("Company Data : $companyData");
        setState(() {
          companyNames[companyId] = companyData['name'] as String ?? 'Unknown';
          companyLogos[companyId] =
              'http://localhost:8000/api/societe/logo/$companyId';
        });
      }
    }
  }

  // Fetch user data to get companyId
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    companyId = prefs.getInt('companyId')?.toString();
    print('Company ID: $companyId');
    final userJson = prefs.getString('user');
    companyName = prefs.getString('societeName');
    print('Company Name: $companyName');
    if (userJson != null) {
      final userData = jsonDecode(userJson) as Map<String, dynamic>;
      final firstName = userData['firstname'] ?? '';
      final lastName = userData['lastname'] ?? '';
      companyId = userData['company_id'] as String;
      print('Company ID: $companyId');
      setState(() {
        profileName = '$firstName $lastName';
      });
    }
  }

  Future<void> _saveJob(int jobId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? savedJobs = prefs.getStringList('saved_jobs') ?? [];

    if (!savedJobs.contains(jobId.toString())) {
      savedJobs.add(jobId.toString());
      await prefs.setStringList('saved_jobs', savedJobs);
      print('Job saved with id $jobId');
      Get.snackbar('Annonce sauvegardée', 'Cette annonce a été sauvegardée.',
          snackPosition: SnackPosition.BOTTOM);
    } else {
      Get.snackbar(
          'Annonce déjà sauvegardée', 'Cette annonce est déjà sauvegardée.',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void _navigateToJobDetails(Job job) {
    Get.to(() =>  FullPageJobRecruter(), arguments: job);
  }


// Inside the build method
@override
Widget build(BuildContext context) {
  return Container(
    color: Colors.white,
    child: SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color.fromARGB(255, 43, 57, 82),
          onPressed: () {
            Get.to(() => JobFormScreen());
          },
          child: const Icon(Icons.add, color: Colors.white),
        ),
        body: loading
            ? Center(
                child: SpinKitFadingCircle(
                  color: Color.fromARGB(255, 43, 57, 82), // Customize color
                  size: 50.0, // Customize size
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: scaleWidth(20, context),
                        vertical: scaleHeight(28, context),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ProfileHeader(
                                lightWelcomeText: "Bienvenue, ",
                                boldWelcomeText: companyName ?? '',
                              ),
                              PopupMenuButton<String>(
                                onSelected: (value) {
                                  if (value == 'Profile') {
                                    Get.to(() => ProfileScreen());
                                  } else if (value == 'Deconnexion') {
                                    showSignOutDialog(context);
                                  }
                                },
                                itemBuilder: (BuildContext context) {
                                  return [
                                    PopupMenuItem<String>(
                                      value: 'Profile',
                                      child: Text('Profile'),
                                    ),
                                    PopupMenuItem<String>(
                                      value: 'Deconnexion',
                                      child: Text('Deconnexion'),
                                    ),
                                  ];
                                },
                                child: companyId == null
                                    ? Icon(Icons.error, color: Colors.red)
                                    : Image.network(
                                        'http://localhost:8000/api/societe/logo/$companyId',
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.fitHeight,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Icon(Icons.error, color: Colors.red);
                                        },
                                      ),
                              ),
                            ],
                          ),
                          VerticalSpace(value: 20, ctx: context),
                          const SearchJob(),
                          VerticalSpace(value: 20, ctx: context),
                          const FeaturedJobsTile(
                            mainText: StaticText.vosJobs,
                            text: StaticText.seeAll,
                          ),
                          VerticalSpace(value: 12, ctx: context),

                          // Display jobs
                          if (jobsList.isEmpty && internshipsList.isEmpty)
                            Center(
                              child: Text(
                                'Aucune annonce correspondant à ce domaine.',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 16,
                                ),
                              ),
                            )
                          else ...[
                            if (jobsList.isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: scaleHeight(160, context),
                                    child: Expanded(
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: jobsList.length,
                                        itemBuilder: (context, index) {
                                          final job = jobsList[index];
                                          final companyId = job.societe_id;
                                          final companyName =
                                              companyNames[companyId] ?? 'Unknown';
                                          final companyLogo =
                                              companyLogos[companyId] ?? '';
                                      
                                          return Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: scaleWidth(8, context)),
                                            child: GestureDetector(
                                              onTap: () {
                                                _navigateToJobDetails(job);
                                              },
                                              child: DisplayCard(
                                                companyName: companyName,
                                                logo: companyLogos[job.societe_id] ?? '',
                                                role: job.title,
                                                onSave: () => _saveJob(job.id),
                                                location: '${job.city}, ${job.country}',
                                                color: const Color.fromARGB(255, 43, 57, 82),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            if (internshipsList.isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  VerticalSpace(value: 12, ctx: context),
                                  const FeaturedJobsTile(
                                    mainText: StaticText.vosInternships,
                                    text: StaticText.seeAll,
                                  ),
                                  VerticalSpace(value: 12, ctx: context),
                                  SizedBox(
                                    height: scaleHeight(160, context),
                                    child: Expanded(
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: internshipsList.length,
                                        itemBuilder: (context, index) {
                                          final internship = internshipsList[index];
                                          final companyId = internship.societe_id;
                                          final companyName =
                                              companyNames[companyId] ?? 'Unknown';
                                          final companyLogo =
                                              companyLogos[companyId] ?? '';
                                      
                                          return Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: scaleWidth(8, context)),
                                            child: GestureDetector(
                                              onTap: () {
                                                _navigateToJobDetails(internship);
                                              },
                                              child: DisplayCard(
                                                companyName: companyName,
                                                logo: companyLogos[internship.societe_id] ?? '',
                                                role: internship.title,
                                                onSave: () => _saveJob(internship.id),
                                                location: '${internship.city}, ${internship.country}',
                                                color: const Color.fromARGB(255, 43, 57, 82),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
        ),
      ),
    );
  }
}
