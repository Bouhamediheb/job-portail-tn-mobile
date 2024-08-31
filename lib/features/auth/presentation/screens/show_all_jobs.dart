import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:job_search_app/constants/assets_location.dart';
import 'package:job_search_app/constants/dimensions.dart';
import 'package:job_search_app/constants/named_routes.dart';
import 'package:job_search_app/constants/strings.dart';
import 'package:job_search_app/controllers/controller.dart';
import 'package:job_search_app/features/auth/data/controllers/validation.dart';
import 'package:job_search_app/features/auth/presentation/widgets/text_fields.dart';
import 'package:job_search_app/features/auth/presentation/screens/full_page_job.dart';
import 'package:job_search_app/features/widgets/custom_progress_indicator.dart';
import 'package:job_search_app/features/widgets/vetical_space.dart';
import 'package:job_search_app/modals/data/Job.dart';
import 'package:job_search_app/themes/color_styles.dart';
import 'package:job_search_app/themes/font_styles.dart' show FontStyles;
import 'package:intl/intl.dart';



class JobDetailsCard extends StatefulWidget {
  const JobDetailsCard({super.key});

  @override
  State<JobDetailsCard> createState() => _JobDetailsCardState();
}

class _JobDetailsCardState extends State<JobDetailsCard> {
  bool isJob = true;
  bool isInternship = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<Job> jobs = [];
  List<Job> internships = [];
  Map<int, String> companyNames = {};
  Map<int, String> companyLogos = {};
  bool loading = true;
  String selectedType = 'job'; // Default to show jobs

  // Filter states
  String? locationFilter;
  int? experienceLevelFilter;
  String? postedDateFilter;

  @override
  void initState() {
    super.initState();
    fetchJobs();
  }

  Future<void> fetchJobs() async {
    setState(() {
      loading = true;
    });

    final uri = Uri.http('localhost:8000', '/api/offre');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> jobList = json.decode(response.body) as List<dynamic>;
      List<Job> fetchedJobs = jobList
          .map((data) => Job.fromJson(data as Map<String, dynamic>))
          .toList();

      setState(() {
        // Apply filters locally
        jobs = fetchedJobs.where((job) {
          final matchesLocation = locationFilter == null ||
              locationFilter!.isEmpty ||
              job.city.contains(locationFilter!, true as int);
          final matchesExperience = experienceLevelFilter == null ||
              experienceLevelFilter! <= 0 ||
              job.yearsOfExperience == experienceLevelFilter;
          final matchesPostedDate = postedDateFilter == null ||
              postedDateFilter!.isEmpty ||
              _matchesPostedDate(job.createdAt, postedDateFilter!);
          final matchesType = job.type == selectedType;

          return matchesLocation &&
              matchesExperience &&
              matchesPostedDate &&
              matchesType;
        }).toList();

        loading = false;
        _fetchCompanyData();
      });
    } else {
      throw Exception('Failed to load jobs');
    }
  }

  bool _matchesPostedDate(String jobPostedDate, String selectedDateFilter) {
    final DateTime jobDate = DateTime.parse(jobPostedDate);
    final DateTime now = DateTime.now();

    switch (selectedDateFilter) {
      case 'Past 24 hours':
        return now.difference(jobDate).inHours <= 24;
      case 'Past week':
        return now.difference(jobDate).inDays <= 7;
      case 'Past month':
        return now.difference(jobDate).inDays <= 30;
      default:
        return true;
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
        setState(() {
          companyNames[companyId] = companyData['name'] as String? ?? 'Unknown';
          companyLogos[companyId] =
              'http://localhost:8000/api/societe/logo/$companyId';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Controller tabSwitchController = Get.put(Controller());
    return SafeArea(
      minimum: const EdgeInsets.all(16),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Offres d\'emploi et stages',
            style: TextStyle(
              color: ColorStyles.darkTitleColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: ColorStyles.pureWhite,
        ),
        body: loading
            ? const CustomProgressIndicator()
            : Column(
                children: [
                  Container(
                    height: scaleHeight(
                      47,
                      context,
                    ),
                    decoration: BoxDecoration(
                      color: ColorStyles.forgotMailPassColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: scaleWidth(
                          7,
                          context,
                        ),
                        vertical: scaleHeight(
                          6,
                          context,
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: scaleHeight(
                                43,
                                context,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  scaleRadius(
                                    16,
                                    context,
                                  ),
                                ),
                                color: isJob
                                    ? Colors.white
                                    : ColorStyles.forgotMailPassColor,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  // Change state of buttons here
                                  setState(() {
                                    isInternship = false;
                                    isJob = true;
                                  });
                                },
                                child: const Center(
                                  child: Text(
                                    "Offres d'emplois",
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: scaleHeight(
                                43,
                                context,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  scaleRadius(16, context),
                                ),
                                color: isInternship
                                    ? Colors.white
                                    : ColorStyles.forgotMailPassColor,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  // Change state of buttons here
                                  setState(() {
                                    isInternship = true;
                                    isJob = false;
                                  });
                                },
                                child: const Center(
                                  child: Text(
                                    'Offres de stages',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  VerticalSpace(
                    value: 16,
                    ctx: context,
                  ),
                  if (isJob)
                    Expanded(
                      child: jobs.isEmpty
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Text(
                                  'Pas d\'offres d\'emploi disponibles \n ou ne correspondent pas \n à vos critères de filtre.',
                                  style: TextStyle(
                                    color:
                                        const Color.fromARGB(255, 43, 57, 82),
                                    fontSize: 18,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          : ListView.builder(
                              itemCount: jobs.length,
                              itemBuilder: (context, index) {
                                final job = jobs[index];
                                final companyName =
                                    companyNames[job.societe_id] ?? 'Unknown';
                                final companyLogo =
                                    companyLogos[job.societe_id];

                                return Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 15),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        offset: Offset(0, 2),
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                  child: ListTile(
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 12),
                                    leading: companyLogo != null
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: Image.network(
                                              companyLogo,
                                              width: 50,
                                              height: 50,
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        : Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade200,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: const Icon(
                                              Icons.business,
                                              color: Colors.grey,
                                            ),
                                          ),
                                    title: Text(
                                      job.title,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    subtitle: Text(
                                      '$companyName\n${job.city}\n${job.yearsOfExperience} years experience',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade600,
                                        height: 1.5,
                                      ),
                                    ),
                                    isThreeLine: true,
                                    onTap: () {
                                      _navigateToJobDetails(job);
                                    },
                                  ),
                                );
                              },
                            ),
                    )
                  else if (isInternship)
                    Expanded(
                      child: internships.isEmpty
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Text(
                                  'Pas d\'offres de stage disponibles \n ou ne correspondent pas \n à vos critères de filtre.',
                                  style: TextStyle(
                                    color:
                                        const Color.fromARGB(255, 43, 57, 82),
                                    fontSize: 18,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          : ListView.builder(
                              itemCount: internships.length,
                              itemBuilder: (context, index) {
                                final internship = internships[index];
                                final companyName =
                                    companyNames[internship.societe_id] ??
                                        'Unknown';
                                final companyLogo =
                                    companyLogos[internship.societe_id];

                                return Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 15),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        offset: Offset(0, 2),
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                  child: ListTile(
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 12),
                                    leading: companyLogo != null
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: Image.network(
                                              companyLogo,
                                              width: 50,
                                              height: 50,
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        : Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade200,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: const Icon(
                                              Icons.business,
                                              color: Colors.grey,
                                            ),
                                          ),
                                    title: Text(
                                      internship.title,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    subtitle: Text(
                                      '$companyName\n${internship.city}\n${internship.yearsOfExperience} years experience',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade600,
                                        height: 1.5,
                                      ),
                                    ),
                                    isThreeLine: true,
                                    onTap: () {
                                      // Handle internship tap, maybe navigate to internship details page
                                    },
                                  ),
                                );
                              },
                            ),
                    )
                ],
              ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color.fromARGB(255, 227, 234, 252),
          onPressed: () {
            _showFilterDialog(context);
          },
          child: const Icon(Icons.filter_list),
        ),
      ),
    );
  }



void _showFilterDialog(BuildContext context) {
  final _locationController = TextEditingController();
  int _experienceLevel = experienceLevelFilter ?? 0;
  String _selectedPostedDate = postedDateFilter ?? 'Anytime';

  Get.dialog(
    StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text(
            'Filtrer les annonces',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          content: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                Text(
                  "Niveau d'expérience",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8),
                DropdownButton<int>(
                  value: _experienceLevel,
                  onChanged: (value) {
                    setState(() {
                      _experienceLevel = value ?? 0;
                    });
                  },
                  items: [
                    DropdownMenuItem<int>(
                        value: 0, child: Text('Pas de préférence')),
                    DropdownMenuItem<int>(value: 1, child: Text('1+ an')),
                    DropdownMenuItem<int>(value: 2, child: Text('2+ ans')),
                    DropdownMenuItem<int>(value: 3, child: Text('3+ ans')),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  "Date",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8),
                DropdownButton<String>(
                  value: _selectedPostedDate,
                  onChanged: (value) {
                    setState(() {
                      _selectedPostedDate = value ?? 'Anytime';
                    });
                  },
                  items: [
                    DropdownMenuItem<String>(
                        value: 'Anytime', child: Text('Tout le temps')),
                    DropdownMenuItem<String>(
                        value: 'Past 24 hours',
                        child: Text('Dernières 24 heures')),
                    DropdownMenuItem<String>(
                        value: 'Past week', child: Text('Dernière semaine')),
                    DropdownMenuItem<String>(
                        value: 'Past month', child: Text('Dernier mois')),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Annuler'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.grey, // Text color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    locationFilter = _locationController.text.isNotEmpty
                        ? _locationController.text
                        : null;
                    experienceLevelFilter =
                        _experienceLevel > 0 ? _experienceLevel : null;
                    postedDateFilter = _selectedPostedDate != 'Anytime'
                        ? _selectedPostedDate
                        : null;
                  });
                  fetchJobs(); // Apply filters and fetch jobs
                  Navigator.of(context).pop();
                },
                child: const Text('Appliquer'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: const Color.fromARGB(255, 43, 57, 82),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    ),
    barrierDismissible: true,
  );
}



  void _navigateToJobDetails(Job job) {
    Get.to(() => const FullPageJob(),
        arguments: job); // Pass the job details to FullPageJob
  }
}
