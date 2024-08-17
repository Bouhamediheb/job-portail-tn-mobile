import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:job_search_app/constants/dimensions.dart';
import 'package:job_search_app/constants/named_routes.dart';
import 'package:job_search_app/controllers/data_controller.dart';
import 'package:job_search_app/features/auth/presentation/screens/full_page_job.dart';
import 'package:job_search_app/modals/data/Job.dart';
import 'package:job_search_app/themes/color_styles.dart';
import 'package:job_search_app/themes/font_styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookMarkedJobsScreen extends StatefulWidget {
  BookMarkedJobsScreen({super.key});

  @override
  _BookMarkedJobsScreenState createState() => _BookMarkedJobsScreenState();
}

class _BookMarkedJobsScreenState extends State<BookMarkedJobsScreen> {
  final Map<int, String> companyNames = {};
  final Map<int, String> companyLogos = {};
  final List<Job> jobs = [];

  @override
  void initState() {
    super.initState();
    _fetchBookmarkedJobs();
  }

  Future<void> _fetchBookmarkedJobs() async {
    final prefs = await SharedPreferences.getInstance();
    final bookmarkedJobIds = prefs.getStringList('saved_jobs') ?? [];
    print("bookmarked $bookmarkedJobIds");

    for (var id in bookmarkedJobIds) {
      final response = await http.get(Uri.parse('http://localhost:8000/api/offre/$id'));

      if (response.statusCode == 200) {
        final jobData = json.decode(response.body) as Map<String, dynamic>;
        final job = Job.fromJson(jobData);

        setState(() {
          jobs.add(job);
          print("Added job: $job");
        });

        // Fetch company data
        await _fetchCompanyData(job.societe_id);
      } else {
        throw Exception('Failed to load job with ID $id');
      }
    }
  }

  Future<void> _fetchCompanyData(int? companyId) async {
    if (companyId == null) return;

    final profileResponse = await http.get(Uri.parse('http://localhost:8000/api/societe/profile/$companyId'));

    if (profileResponse.statusCode == 200) {
      final companyData = json.decode(profileResponse.body) as Map<String, dynamic>;
      setState(() {
        companyNames[companyId] = companyData['name'] as String ?? 'Unknown';
        companyLogos[companyId] = 'http://localhost:8000/api/societe/logo/$companyId'; // URL to the logo
      });
    }
  }

  Future<void> _removeJobFromBookmarks(Job job) async {
    final prefs = await SharedPreferences.getInstance();
    final bookmarkedJobIds = prefs.getStringList('saved_jobs') ?? [];

    bookmarkedJobIds.remove(job.id.toString());
    await prefs.setStringList('saved_jobs', bookmarkedJobIds);

    setState(() {
      jobs.remove(job);
    });
  }

  Future<bool?> _showConfirmationDialog(Job job) async {
    return showDialog<bool?>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to remove this job from your bookmarks?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop(true);
                _removeJobFromBookmarks(job);
              },
            ),
          ],
        );
      },
    );
  }

  void _navigateToJobDetails(Job job) {
    Get.to(() => FullPageJob(), arguments: job); // Pass the job details to FullPageJob
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Vos annonces épinglés',
          style: TextStyle(
            color: ColorStyles.darkTitleColor,
            fontSize: 19,
            fontWeight: FontWeight.w800,
          ),
        ),
        backgroundColor: ColorStyles.pureWhite,
      ),
      body: jobs.isEmpty
          ? const  Center(
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Text(
                                  'Vous n\'avez pas encore\n épinglé d\'annonces.',
                                  style: TextStyle(
                                    color:
                                        const Color.fromARGB(255, 43, 57, 82),
                                    fontSize: 18,
                                  ),
                                  textAlign: TextAlign.center,                                ),
                              ),
                            )
          : ListView.builder(
              itemCount: jobs.length,
              itemBuilder: (context, index) {
                final job = jobs[index];
                final companyName = companyNames[job.societe_id] ?? 'Unknown';
                final companyLogo = companyLogos[job.societe_id] ?? 'https://via.placeholder.com/150'; // Placeholder image URL

                return Dismissible(
                  key: ValueKey(job.id),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (direction) async {
                    // Show confirmation dialog
                    return await _showConfirmationDialog(job);
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(horizontal: scaleWidth(20, context)),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  child: GestureDetector(
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
                          borderRadius: BorderRadius.circular(scaleRadius(8, context)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(scaleWidth(30, context)),
                              ),
                              child: Image.network(
                                companyLogo,
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
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
