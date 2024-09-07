import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:job_search_app/constants/assets_location.dart';
import 'package:job_search_app/constants/named_routes.dart';
import 'package:job_search_app/features/auth/data/controllers/auth_functions.dart';
import 'package:job_search_app/features/auth/data/controllers/validation.dart';
import 'package:job_search_app/features/auth/presentation/widgets/login_button.dart';
import 'package:job_search_app/features/auth/presentation/widgets/text_fields.dart';
import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreenRecruter extends StatefulWidget {
  @override
  _ProfileScreenRecruterState createState() => _ProfileScreenRecruterState();
}

class _ProfileScreenRecruterState extends State<ProfileScreenRecruter> {
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController faxController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController websiteController = TextEditingController();

  String? logoUrl;
  File? selectedLogo;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('companyId');

    try {
      final response = await http.get(Uri.parse('http://localhost:8000/api/societe/profile/$id'));
      final data = jsonDecode(response.body);

      setState(() {
        addressController.text = data['address'] as String? ?? '';
        phoneNumberController.text = data['phoneNumber'] as String? ?? '';
        faxController.text = data['fax'] as String? ?? '';
        cityController.text = data['city'] as String? ?? '';
        countryController.text = data['country'] as String? ?? '';
        websiteController.text = data['website'] as String? ?? '';
        logoUrl = data['logo'] as String? ?? '';
      });
    } catch (error) {
      print('Error fetching profile: $error');
    }
  }

  Future<void> saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('companyId');

    try {
      var request = http.MultipartRequest('POST', Uri.parse('http://localhost:8000/api/societe/profile/$id'));
      request.fields['address'] = addressController.text;
      request.fields['phoneNumber'] = phoneNumberController.text;
      request.fields['fax'] = faxController.text;
      request.fields['city'] = cityController.text;
      request.fields['country'] = countryController.text;
      request.fields['website'] = websiteController.text;

      if (selectedLogo != null) {
        request.files.add(await http.MultipartFile.fromPath('logo', selectedLogo!.path));
      }

      final response = await request.send();

      if (response.statusCode == 200) {
        print('Profile updated successfully');
        showSuccessModal(context);
      } else {
        print('Failed to update profile');
      }
    } catch (error) {
      print('Error updating profile: $error');
    }
  }

  Future<void> handleLogoUpload() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        selectedLogo = File(pickedFile.path);
        logoUrl = pickedFile.path;
      });
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
                "Profil mis à jour !",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          content: Text(
            "Vos informations de profil\nont été mises à jour avec succès.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacementNamed('/home'); // Changed to main screen route
                },
                child: Text("Fermer"),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color.fromARGB(255, 43, 57, 82),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
 bottomNavigationBar: BottomNavigationBar(
          elevation: 0,
          enableFeedback: true,
          backgroundColor: Colors.white,
          selectedItemColor: Color.fromARGB(255, 43, 57, 82),
          unselectedItemColor: Colors.grey,
          currentIndex: 2,
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
              Get.toNamed(NamedRoutes.profileScreenRecruter);
            }
          },
        ),      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Votre profil pro'),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(24, 0, 24, 0),
        child: ListView(
          children: [
            SizedBox(height: 20),
            Text(
              'Mettre à jour votre profil',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 20),

            Row(
              children: [
                selectedLogo == null
                    ? Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.image, size: 50, color: Colors.grey),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          selectedLogo!,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: handleLogoUpload,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text('Choisir une image', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
            SizedBox(height: 30),

            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    hintText: 'Siège social',
                    textIcon: Assets.city,
                    isPassword: false,
                    textType: TextInputType.text,
                    controller: addressController,
                    isErrorfull: false,
                    inputType: InputType.text,
                    formKey: _formKey,
                  ),
                  SizedBox(height: 16),
                  CustomTextField(
                    hintText: 'Numéro de téléphone',
                    textIcon: Assets.telephone,
                    isPassword: false,
                    textType: TextInputType.phone,
                    controller: phoneNumberController,
                    isErrorfull: false,
                    inputType: InputType.phone,
                    formKey: _formKey,
                  ),
                  SizedBox(height: 16),
                  CustomTextField(
                    hintText: 'Numéro de fax',
                    textIcon: Assets.fax,
                    isPassword: false,
                    textType: TextInputType.phone,
                    controller: faxController,
                    isErrorfull: false,
                    inputType: InputType.fax,
                    formKey: _formKey,
                  ),
                  SizedBox(height: 16),
                  CustomTextField(
                    hintText: 'Ville',
                    textIcon: Assets.city,
                    isPassword: false,
                    textType: TextInputType.text,
                    controller: cityController,
                    isErrorfull: false,
                    inputType: InputType.text,
                    formKey: _formKey,
                  ),
                  SizedBox(height: 16),
                  CustomTextField(
                    hintText: 'Pays',
                    textIcon: Assets.country,
                    isPassword: false,
                    textType: TextInputType.text,
                    controller: countryController,
                    isErrorfull: false,
                    inputType: InputType.text,
                    formKey: _formKey,
                  ),
                  SizedBox(height: 16),
                  CustomTextField(
                    hintText: 'Site web',
                    textIcon: Assets.website,
                    isPassword: false,
                    textType: TextInputType.url,
                    controller: websiteController,
                    isErrorfull: false,
                    inputType: InputType.website,
                    formKey: _formKey,
                  ),
                  SizedBox(height: 30),
                  LoginButton(
                    loginText: 'Enregistrer',
                    onTapButton: saveProfile,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
