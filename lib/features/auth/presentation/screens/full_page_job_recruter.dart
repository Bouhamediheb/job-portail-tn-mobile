import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:job_search_app/constants/assets_location.dart';
import 'package:job_search_app/constants/dimensions.dart';
import 'package:job_search_app/controllers/controller.dart';
import 'package:job_search_app/features/widgets/vetical_space.dart';
import 'package:job_search_app/modals/data/Job.dart';
import 'package:job_search_app/themes/color_styles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class FullPageJobRecruter extends StatefulWidget {
  const FullPageJobRecruter({super.key});

  @override
  _FullPageJobRecruterState createState() => _FullPageJobRecruterState();
}

class _FullPageJobRecruterState extends State<FullPageJobRecruter> {
  Job? _job;
  Map<String, dynamic>? _companyInfo;
  String? _companyLogoUrl;


  @override
  void initState() {
    super.initState();
    _job = Get.arguments as Job?;
    if (_job != null) {
      _fetchCompanyInfo();
    }
  }

  

  Future<void> _fetchCompanyInfo() async {
    if (_job == null) return;
    final companyId = _job!.societe_id; // Assuming societe_id is available in Job model
    final profileUrl = Uri.parse('http://localhost:8000/api/societe/profile/$companyId');
    final logoUrl = Uri.parse('http://localhost:8000/api/societe/logo/$companyId');

    // Fetch company profile info
    final profileResponse = await http.get(profileUrl);

    if (profileResponse.statusCode == 200) {
      setState(() {
        _companyInfo = jsonDecode(profileResponse.body) as Map<String, dynamic>;
      });
    }

    // Fetch company logo
    setState(() {
      _companyLogoUrl = logoUrl.toString();
      print(_companyLogoUrl);
    });
  }

  Future<void> applyForJob(String jobId, BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');

    if (userJson == null) {
      showFailureModal(context, "User not found. Please log in.");
      return;
    }

    final userData = jsonDecode(userJson);
    final userId = userData['id']?.toString();

    if (userId == null) {
      showFailureModal(context, "User ID is missing. Please log in again.");
      return;
    }

    final int userIdInt = int.parse(userId);
    final int jobIdInt = int.parse(jobId);

    final url = Uri.parse('http://localhost:8000/api/postulation/$jobIdInt/$userIdInt');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'jobId': jobIdInt,
        'userId': userIdInt,
      }),
    );

    if (response.statusCode == 200) {
      showSuccessModal(context);
    } else {
      showFailureModal(context, "Failed to apply. Please try again.");
    }
  }

  void showSuccessModal(BuildContext context) {
     showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 60,
            ),
            SizedBox(height: 10),
            Text(
              "Candidature retenue !",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        content: Text(
          "Votre candidature a été envoyée \n avec succès vers la société.",
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Fermer"),
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
  );
}


  void showFailureModal(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Application Failed"),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_job == null) {
      return Scaffold(
        body: Center(child: Text('Job not found.')),
      );
    }

    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: screenHeight(context) * 0.5,
            child: Stack(
              children: [
                SvgPicture.asset(
                  Assets.detailsContainer,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.fitHeight,
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: ColorStyles.pureWhite,
                        ),
                        child: _companyLogoUrl != null
                            ? Image.network(
                                _companyLogoUrl!,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              )
                            : const CircularProgressIndicator(),
                      ),
                      VerticalSpace(
                        value: scaleHeight(12, context),
                        ctx: context,
                      ),
                      Text(
                        _job!.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          color: ColorStyles.pureWhite,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      VerticalSpace(
                        value: scaleHeight(10, context),
                        ctx: context,
                      ),
                      Text(
                        '${_job!.city}, ${_job!.country}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: ColorStyles.pureWhite,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      VerticalSpace(
                        value: scaleHeight(12, context),
                        ctx: context,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          GetX<Controller>(
            init: Controller(),
            builder: (tab) => Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: scaleHeight(15, context),
                  horizontal: scaleWidth(20, context),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              tab.switchTab = 0;
                            },
                            child: Text(
                              'Description',
                              style: TextStyle(
                                color: tab.tabController == 0
                                    ? Colors.black
                                    : Colors.grey,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              tab.switchTab = 1;
                            },
                            child: Text(
                              'Compétences',
                              style: TextStyle(
                                color: tab.tabController == 1
                                    ? Colors.black
                                    : Colors.grey,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              tab.switchTab = 2;
                            },
                            child: Text(
                              'Société',
                              style: TextStyle(
                                color: tab.tabController == 2
                                    ? Colors.black
                                    : Colors.grey,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: scaleHeight(290, context),
                        child: ListView(
                          children: [
                            if (tab.tabController == 0) ...{
                              Text(_job!.description),
                            } else if (tab.tabController == 1) ...{
                              Wrap(
                                spacing: 8.0, 
                                runSpacing: 4.0,
                                children: [
                                  for (var skill in jsonDecode(_job!.skills)
                                      as List<dynamic>) ...[
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        vertical: scaleHeight(6, context),
                                        horizontal: scaleWidth(12, context),
                                      ),
                                      decoration: BoxDecoration(
                                        color: ColorStyles.defaultMainColor,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        skill.toString(),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: scaleWidth(14, context),
                                        ),
                                      ),
                                    ),
                                  ]
                                ],
                              ),
                            } else if (tab.tabController == 2) ...{
                              if (_companyInfo == null) ...{
                                const Center(child: CircularProgressIndicator()),
                              } else ...{
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildCompanyInfoRow(Icons.location_on, _companyInfo!['address'] as String),
                                    _buildCompanyInfoRow(Icons.email, _companyInfo!['email'] as String),
                                    _buildCompanyInfoRow(Icons.language, _companyInfo!['website'] as String),
                                    _buildCompanyInfoRow(Icons.flag, _companyInfo!['country'] as String),
                                    _buildCompanyInfoRow(Icons.location_city, _companyInfo!['city'] as String),
                                  ],
                                ),
                              }
                            }
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
  onTap: () {
    // Modify the job action
  },
  child: Padding(
    padding: EdgeInsets.symmetric(
      horizontal: scaleWidth(12, context),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(scaleRadius(10, context)),
              color: ColorStyles.defaultMainColor,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: scaleHeight(12, context),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.edit,
                    color: ColorStyles.pureWhite,
                  ),
                  SizedBox(width: scaleWidth(8, context)),
                  Text(
                    "Modifier l'annonce",
                    style: TextStyle(
                      fontSize: scaleWidth(12, context),
                      fontWeight: FontWeight.w500,
                      color: ColorStyles.pureWhite,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(width: scaleWidth(12, context)), // Spacing between the two buttons
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(scaleRadius(10, context)),
              color: Colors.redAccent,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: scaleHeight(12, context),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.delete,
                    color: ColorStyles.pureWhite,
                  ),
                  SizedBox(width: scaleWidth(8, context)),
                  Text(
                    "Supprimer l'annonce",
                    style: TextStyle(
                      fontSize: scaleWidth(12, context),
                      fontWeight: FontWeight.w500,
                      color: ColorStyles.pureWhite,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 130,)
      ],
    ),
  ),
),

        ],
      ),
    );
  }

  Widget _buildCompanyInfoRow(IconData icon, String? info) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: scaleHeight(8, context)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.black),
          SizedBox(width: scaleWidth(8, context)),
          Expanded(
            child: Text(
              info ?? 'N/A',
              style: TextStyle(
                fontSize: scaleWidth(12, context,
              )),
            ),
          ),
        ],
      ),
    );
  }
}
