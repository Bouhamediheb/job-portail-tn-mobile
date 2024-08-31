// ignore_for_file: inference_failure_on_function_invocation

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
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
  List<Job> featuredJobs = [];
  List<Job> filteredFeaturedJobs = [];
  List<String> categories = [];
  String profileName = '';
  Map<int, String> companyNames = {};
  Map<int, String> companyLogos = {};
  bool loading = true;
  String? selectedCategory;
  late String? companyName;
  late String? companyId;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    fetchJobs();
  }

  void showSignOutDialog(BuildContext context) {
    Get.defaultDialog(
      title: '',
      titleStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
        color: Colors.black,
      ),
      content: Column(
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
    final prefs = await SharedPreferences.getInstance();
    final companyId = prefs.getInt('companyId')?.toString();

    if (companyId != null) {
      final response = await http.get(
        Uri.parse('http://localhost:8000/api/offre/jobs/societe/$companyId'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jobList =
            json.decode(response.body) as List<dynamic>;
        print(jobList);

        // Delay the display of the jobs by 2 seconds
        await Future.delayed(const Duration(seconds: 4));

        setState(() {
          jobs = jobList
              .map((data) => Job.fromJson(data as Map<String, dynamic>))
              .toList();
          featuredJobs = jobs.where((job) => job.featured == 1).toList();
          filteredFeaturedJobs = featuredJobs;
          categories = jobs
              .map((job) => job.domain)
              .toSet()
              .toList(); // Extract unique categories
          loading = false;
          _fetchCompanyData();
        });
      } else {
        throw Exception('Failed to load jobs');
      }
    } else {
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
    companyId = prefs.getInt('companyId').toString();
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
    Get.to(() => const FullPageJob(),
        arguments: job); // Pass the job details to FullPageJob
  }

  void _filterFeaturedJobsByCategory(String category) {
    setState(() {
      selectedCategory = category;
      filteredFeaturedJobs =
          featuredJobs.where((job) => job.domain == category).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Get.to(() =>
                  const PostNewJobScreen()); // Navigate to post job screen
            },
            child: const Icon(Icons.add),
          ),
          body: SingleChildScrollView(
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
                          // Replace the GestureDetector around the Image.network with this:
                          PopupMenuButton<String>(
                              onSelected: (value) {
                                if (value == 'Profile') {
                                  // Navigate to ProfileScreen
                                  Get.to(() =>
                                      ProfileScreen()); // Replace with your ProfileScreen
                                } else if (value == 'Deconnexion') {
                                  // Trigger logout logic
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
                                  ? Icon(Icons.error,
                                      color: Colors
                                          .red) // Placeholder if companyId is null
                                  : Image.network(
                                      'http://localhost:8000/api/societe/logo/$companyId',
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.fitHeight,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Icon(Icons.error,
                                            color: Colors.red);
                                      },
                                    )),
                        ],
                      ),
                      VerticalSpace(value: 20, ctx: context),
                      const SearchJob(),
                      VerticalSpace(value: 20, ctx: context),
                      const FeaturedJobsTile(
                        mainText: StaticText.featuredJobs,
                        text: StaticText.seeAll,
                      ),
                      VerticalSpace(value: 8, ctx: context),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: scaleWidth(8, context)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            HorizontalSpace(value: 8, ctx: context),
                            SizedBox(
                              height: scaleHeight(60, context),
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: categories.length,
                                itemBuilder: (context, index) {
                                  final domain = categories[index];
                                  return Padding(
                                    padding:
                                        EdgeInsets.all(scaleWidth(8, context)),
                                    child: GestureDetector(
                                      onTap: () {
                                        _filterFeaturedJobsByCategory(domain);
                                      },
                                      child: Chip(
                                        label: Text(domain),
                                        backgroundColor:
                                            selectedCategory == domain
                                                ? Colors.red
                                                : Colors.grey[200],
                                        labelStyle: TextStyle(
                                          color: selectedCategory == domain
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      VerticalSpace(value: 20, ctx: context),
                      if (filteredFeaturedJobs.isEmpty)
                        Center(
                          child: Text(
                            'Aucune annonce correspondant à ce domaine.',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                            ),
                          ),
                        )
                      else
                        SizedBox(
                          height: scaleHeight(360, context),
                          child: loading
                              ? SkeletonLoader() // Display a skeleton loader while loading
                              : ListView.builder(
                                  itemCount: filteredFeaturedJobs.length,
                                  itemBuilder: (context, index) {
                                    final job = filteredFeaturedJobs[index];
                                    final companyId = job.societe_id;
                                    final companyName =
                                        companyNames[companyId] ?? 'Unknown';
                                    final companyLogo =
                                        companyLogos[companyId] ?? '';

                                    return GestureDetector(
                                      onTap: () {
                                        _navigateToJobDetails(job);
                                      },
                                      child: DisplayCard(
                                        companyName: companyName,
                                        logo:
                                            companyLogos[job.societe_id] ?? '',
                                        role: job.title,
                                        onSave: () => _saveJob(job.id),
                                        location: '${job.city}, ${job.country}',
                                        color: ColorStyles.amber,
                                      ),
                                    );
                                  },
                                ),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: scaleWidth(20, context),
                    vertical: scaleHeight(28, context),
                  ),
                  child: const FeaturedJobsTile(
                    mainText: 'Gérez vos annonces',
                    text: StaticText.seeAll,
                  ),
                ),
                VerticalSpace(value: 8, ctx: context),
                // Display posted jobs or management options for the recruiter here.
              ],
            ),
          ),
        ),
      ),
    );
  }
}
