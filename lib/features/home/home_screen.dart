import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
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
import 'package:shared_preferences/shared_preferences.dart';

import '../../themes/color_styles.dart';
import '../full_page_job.dart'; // Import the FullPageJob screen

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Job> jobs = [];
  List<Job> featuredJobs = [];
  String profileName = '';
  Map<int, String> companyNames = {}; // To store company names
  Map<int, String> companyLogos = {}; // To store company logos
  bool loading = true; // Loading state

  @override
  void initState() {
    super.initState();
    fetchJobs();
    _loadUserData();
  }

  Future<void> fetchJobs() async {
    final response = await http.get(Uri.parse('http://localhost:8000/api/offre'));

    if (response.statusCode == 200) {
      final List<dynamic> jobList = json.decode(response.body) as List<dynamic>;

      // Delay the display of the jobs by 2 seconds
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        jobs = jobList.map((data) => Job.fromJson(data as Map<String, dynamic>)).toList();
        featuredJobs = jobs.where((job) => job.featured == 1).toList();
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
      final profileResponse = await http.get(Uri.parse('http://localhost:8000/api/societe/profile/$companyId'));
      if (profileResponse.statusCode == 200) {
        final companyData = json.decode(profileResponse.body) as Map<String, dynamic>;
        print("Company Data : $companyData");
        setState(() {
          companyNames[companyId] = companyData['name'] as String ?? 'Unknown';
          companyLogos[companyId] = 'http://localhost:8000/api/societe/logo/$companyId'; // URL to the logo
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
      setState(() {
        profileName = '$firstName $lastName';
      });
    }
  }

  void _navigateToJobDetails(Job job) {
    Get.to(() => const FullPageJob(), arguments: job); // Pass the job details to FullPageJob
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: scaleWidth(24, context),
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
                        GestureDetector(
                          onTap: () {
                            Get.defaultDialog(
                              title: 'Déconnexion',
                              middleText: 'Voulez-vous vraiment vous déconnecter ?',
                              textCancel: 'Non',
                              textConfirm: 'Oui',
                              confirmTextColor: ColorStyles.pureWhite,
                              onConfirm: () {
                                AuthFunctions.signOutUser(context);
                              },
                            );
                          },
                          child: Image.network(
                            'http://localhost:8000/api/profil/image/1', // URL to fetch the profile image
                            width: 50,
                            height: 50,
                            fit: BoxFit.fitHeight,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(Icons.error, color: Colors.red); // Handle errors and provide a fallback icon
                            },
                          ),
                        ),
                      ],
                    ),
                    VerticalSpace(value: 39, ctx: context),
                    const SearchJob(),
                    VerticalSpace(value: 40, ctx: context),
                    const FeaturedJobsTile(
                      mainText: StaticText.featuredJobs,
                      text: StaticText.seeAll,
                    ),
                  ],
                ),
              ),
              HorizontalSpace(value: 20, ctx: context),

              // JOBS CARD
              SizedBox(
                height: scaleHeight(160, context),
                child: loading  // Show skeleton loaders if jobs are not yet loaded
                    ? ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 3,  // Number of skeleton loaders to show
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(left: scaleWidth(24, context)),
                            child: const SkeletonLoader(),  // Display the skeleton loader
                          );
                        },
                      )
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: jobs.length,
                        itemBuilder: (context, index) {
                          final job = jobs[index];
                          return GestureDetector(
                            onTap: () => _navigateToJobDetails(job),  // Navigate to FullPageJob on tap
                            child: Padding(
                              padding: EdgeInsets.only(left: scaleWidth(24, context)),
                              child: DisplayCard(
                                companyName: companyNames[job.societe_id] ?? 'Unknown',  // Company name
                                role: job.title,
                                logo: companyLogos[job.societe_id] ?? Assets.googleSvg,  // Company logo
                                location: '${job.city}, ${job.country}',
                                color: ColorStyles.c5386E4,  // Customize as needed
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
