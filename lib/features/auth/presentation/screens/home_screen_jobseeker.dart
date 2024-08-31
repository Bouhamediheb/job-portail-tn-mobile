import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:job_search_app/constants/assets_location.dart';
import 'package:job_search_app/constants/dimensions.dart';
import 'package:job_search_app/constants/strings.dart';
import 'package:job_search_app/features/auth/data/controllers/auth_functions.dart';
import 'package:job_search_app/features/auth/presentation/screens/profile_screen_seeker.dart';
import 'package:job_search_app/features/widgets/display_card.dart';
import 'package:job_search_app/features/widgets/featured_jobs_tile.dart';
import 'package:job_search_app/features/widgets/horizontal_space.dart';
import 'package:job_search_app/features/widgets/profile_header.dart';
import 'package:job_search_app/features/widgets/search_job.dart';
import 'package:job_search_app/features/widgets/vetical_space.dart';
import 'package:job_search_app/modals/data/Job.dart';
import 'package:job_search_app/utils/skeleton_loader.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart'; // Ensure you have GetX package in your pubspec.yaml

import '../../../../themes/color_styles.dart';
import 'full_page_job.dart'; // Import the FullPageJob screen

class HomeScreenSeeker extends StatefulWidget {
  const HomeScreenSeeker({super.key});

  @override
  State<HomeScreenSeeker> createState() => _HomeScreenSeekerState();
}

class _HomeScreenSeekerState extends State<HomeScreenSeeker> {
  List<Job> jobs = [];
  List<Job> featuredJobs = [];
  List<Job> filteredFeaturedJobs = [];
  List<String> categories = []; // To store job categories
  String profileName = '';
  Map<int, String> companyNames = {}; // To store company names
  Map<int, String> companyLogos = {}; // To store company logos
  bool loading = true; // Loading state
  String? selectedCategory;
  int? userId;

  @override
  void initState() {
    super.initState();
    fetchJobs();
    _loadUserData();
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
            AuthFunctions.clearSharedPref();
            AuthFunctions.signOutUser(context);

          },
          child: Text('Oui'),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.red, // Text color
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
            Get.back(); // Close the dialog
          },
          child: Text('Non'),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.grey, // Text color
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
    final response =
        await http.get(Uri.parse('http://localhost:8000/api/offre'));

    if (response.statusCode == 200) {
      final List<dynamic> jobList = json.decode(response.body) as List<dynamic>;

      // Delay the display of the jobs by 2 seconds
      await Future.delayed(const Duration(seconds: 4));

      setState(() {
        print(jobList);
        jobs = jobList
            .map((data) => Job.fromJson(data as Map<String, dynamic>))
            .toList();
        featuredJobs = jobs.where((job) => job.featured == 1).toList();
        filteredFeaturedJobs =
            featuredJobs; // Initialize filteredFeaturedJobs with all featuredJobs
        categories = jobs
            .map((job) => job.domain)
            .toSet()
            .toList(); // Extract unique categories
        loading = false; // Set loading to false after the delay and data fetch
        _fetchCompanyData();
      });
    } else {
      throw Exception('Failed to load jobs');
    }
  }

  Future<void> _fetchCompanyData() async {
    for (var job in jobs) {
      final companyId = job.societe_id;
      if (companyId == null) continue;

      // Fetch company profile
      final profileResponse = await http.get(
          Uri.parse('http://localhost:8000/api/societe/profile/$companyId'));
      if (profileResponse.statusCode == 200) {
        final companyData =
            json.decode(profileResponse.body) as Map<String, dynamic>;
        print("Company Data : $companyData");
        setState(() {
          companyNames[companyId] = companyData['name'] as String ?? 'Unknown';
          companyLogos[companyId] =
              'http://localhost:8000/api/societe/logo/$companyId'; // URL to the logo
        });
      }
    }
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');
    if (userJson != null) {
      final userData = jsonDecode(userJson) as Map<String, dynamic>;
      final firstName = userData['firstname'] ?? '';
      final lastName = userData['lastname'] ?? '';
      userId = userData['id'] as int ;
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
      Get.snackbar('Annonce déjà sauvegardée', 'Cette annonce est déjà sauvegardée.',
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
      // Filter featured jobs based on the selected category
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
          body: SingleChildScrollView(
            // Wrap the entire content in a SingleChildScrollView
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
                            lightWelcomeText: "Heureux de vous revoir ,",
                            boldWelcomeText: profileName,
                          ),
                          PopupMenuButton<String>(
                                onSelected: (value) {
                                  if (value == 'Profile') {
                                    // Navigate to ProfileScreen
                                    Get.to(() =>
                                        ProfileScreenSeeker()); // Replace with your ProfileScreen
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
                                child:  userId == null
                                    ? Icon(Icons.error,
                                        color: Colors
                                            .red)
                                    : Container(
                                      //rounded
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(
                                            scaleWidth(30, context)),
                                      ),
                                      
                                      child: Image.network(
                                          'http://localhost:8000/api/profil/image/$userId',
                                          width: 50,
                                          height: 50,                                          

                                          fit: BoxFit.fitHeight,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Icon(Icons.error,
                                                color: Colors.red);
                                          },
                                        ),
                                    )),
                        ],
                      ),
                      VerticalSpace(value: 39, ctx: context),
                      const SearchJob(),
                      VerticalSpace(value: 40, ctx: context),
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
                                    child: ChoiceChip(
                                      backgroundColor: Colors.white10,
                                      label: Text(domain),
                                      selectedColor:
                                          const Color.fromARGB(255, 43, 57, 82),
                                      checkmarkColor: Colors.white,
                                      //if selected text color white
                                      labelStyle: TextStyle(
                                        color: selectedCategory == domain
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                      selected: selectedCategory == domain,
                                      onSelected: (isSelected) {
                                        if (isSelected) {
                                          _filterFeaturedJobsByCategory(domain);
                                        } else {
                                          setState(() {
                                            selectedCategory = null;
                                            filteredFeaturedJobs =
                                                featuredJobs; // Reset to show all featured jobs
                                          });
                                        }
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                            SizedBox(
                              height: scaleHeight(160, context),
                              child: loading
                                  ? ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount:
                                          3, // Number of skeleton loaders to show
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: EdgeInsets.only(
                                              right: scaleWidth(16, context)),
                                          child:
                                              const SkeletonLoader(), // Display the skeleton loader
                                        );
                                      },
                                    )
                                  : ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: filteredFeaturedJobs.length,
                                      itemBuilder: (context, index) {
                                        final job = filteredFeaturedJobs[index];
                                        return Padding(
                                          padding: EdgeInsets.only(
                                              right: scaleWidth(8, context)),
                                          child: GestureDetector(
                                            onTap: () => _navigateToJobDetails(
                                                job), // Navigate to FullPageJob on tap
                                            child: DisplayCard(
                                              companyName:
                                                  companyNames[job.societe_id] ??
                                                      'Unknown', // Company name
                                              onSave: () => _saveJob(
                                                  job.id), // Save job on icon tap
                                              role: job.title,
                                              logo:
                                                  companyLogos[job.societe_id] ??
                                                      '', // Company logo
                                              location:
                                                  '${job.city}, ${job.country}',
                                              color: const Color.fromARGB(255, 43,
                                                  57, 82), // Customize as needed
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                            ),
                          ],
                        ),
                      ),
                      // FEATURED JOBS CAROUSEL
                      VerticalSpace(value: 40, ctx: context),
                      // Add any other widgets or sections here as needed
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
