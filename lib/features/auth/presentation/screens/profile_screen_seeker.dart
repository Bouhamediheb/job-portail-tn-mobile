import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:portail_tn/features/auth/presentation/widgets/login_button.dart';

class ProfileScreenSeeker extends StatefulWidget {
  @override
  _ProfileScreenSeekerState createState() => _ProfileScreenSeekerState();
}

class _ProfileScreenSeekerState extends State<ProfileScreenSeeker> {
  final _formKey = GlobalKey<FormState>();

  // Variables
  String phoneNumber = '';
  String personalWebsite = '';
  String bio = '';
  String languages = '';
  String gender = 'Homme';
  List<Map<String, String>> academicEntries = [];
  List<Map<String, String>> professionalEntries = [];
  List<String> selectedSkills = [];
  String skillInput = '';
  String country = '';
  String city = '';
  String address = '';

  // Profile picture and CV upload
  XFile? profilePicture;
  File? cvFile;

  // Image picker
  final ImagePicker _picker = ImagePicker();

  void _pickProfilePicture() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      profilePicture = pickedFile;
    });
  }

  void _uploadCV() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result != null) {
      setState(() {
        cvFile = File(result.files.single.path!);
      });
    }
  }

  void _addAcademicEntry() {
    setState(() {
      academicEntries.add({
        'institute': '',
        'degree': '',
        'graduation_year': '',
      });
    });
  }

  void _removeAcademicEntry(int index) {
    setState(() {
      academicEntries.removeAt(index);
    });
  }

  void _addProfessionalEntry() {
    setState(() {
      professionalEntries.add({
        'companyName': '',
        'jobTitle': '',
        'startDate': '',
        'endDate': '',
      });
    });
  }

  void _removeProfessionalEntry(int index) {
    setState(() {
      professionalEntries.removeAt(index);
    });
  }

  void _addSkill() {
    if (skillInput.isNotEmpty && !selectedSkills.contains(skillInput)) {
      setState(() {
        selectedSkills.add(skillInput);
        skillInput = '';
      });
    }
  }

  void _removeSkill(String skill) {
    setState(() {
      selectedSkills.remove(skill);
    });
  }

   Future<void> saveProfile() async {
  if (_formKey.currentState!.validate()) {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getInt('userId')?.toString(); // Ensure userId is correctly fetched as a string
      String? token = prefs.getString('token');

      if (userId == null || token == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('User not logged in.'),
        ));
        return;
      }

      var profileRequest = http.MultipartRequest('POST', Uri.parse('http://localhost:8000/api/profil'));

      profileRequest.fields['bio'] = bio ?? '';
      profileRequest.fields['gender'] = gender ?? ''; // Ensure gender is included
      profileRequest.fields['city'] = city ?? '';
      profileRequest.fields['country'] = country ?? '';
      profileRequest.fields['phoneNumber'] = phoneNumber ?? '';
      profileRequest.fields['website'] = personalWebsite ?? ''; // Ensure website is included
      profileRequest.fields['address'] = address ?? '';
      profileRequest.fields['skills'] = jsonEncode(selectedSkills);
      profileRequest.fields['languages'] = jsonEncode(languages ?? []); // Ensure languages is correctly encoded
      profileRequest.fields['user_id'] = userId;

      if (profilePicture != null) {
        profileRequest.files.add(await http.MultipartFile.fromPath('profilePicture', profilePicture!.path));
      }
      if (cvFile != null) {
        profileRequest.files.add(await http.MultipartFile.fromPath('cv', cvFile!.path));
      }

      var profileResponse = await profileRequest.send();

      if (profileResponse.statusCode != 200) {
        String responseBody = await profileResponse.stream.bytesToString();
        print('Profile update failed: $responseBody'); // Log the error message
        throw Exception('Failed to update profile: $responseBody');
      }

      // Update academic entries
      for (var entry in academicEntries) {
        final academicResponse = await http.post(
          Uri.parse('http://localhost:8000/api/experience/academic'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'institute': entry['institute'] ?? '',
            'degree': entry['degree'] ?? '',
            'graduation_year': entry['graduation_year']?.toString() ?? '', // Ensure conversion
            'profil_id': userId,
          }),
        );

        if (academicResponse.statusCode != 200) {
          String responseBody = await academicResponse.body;
          print('Academic update failed: $responseBody'); // Log the error message
          throw Exception('Failed to update academic experience: $responseBody');
        }
      }

      // Update professional entries
      for (var entry in professionalEntries) {
        final professionalResponse = await http.post(
          Uri.parse('http://localhost:8000/api/experience/professional'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'companyName': entry['companyName'] ?? '',
            'jobTitle': entry['jobTitle'] ?? '',
            'startDate': entry['startDate'] ?? '',
            'endDate': entry['endDate'] ?? '',
            'profil_id': userId,
          }),
        );

        if (professionalResponse.statusCode != 200) {
          String responseBody = await professionalResponse.body;
          print('Professional update failed: $responseBody'); // Log the error message
          throw Exception('Failed to update professional experience: $responseBody');
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Profile, academic, and professional experiences updated successfully.'),
      ));

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('An error occurred: $e'),
      ));
    }
  }
}





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Mon profil'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Mettez à jour votre profil numérique',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 20),
Text(
                  'Photo de profil',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
              GestureDetector(
                onTap: _pickProfilePicture,
                child: CircleAvatar(
                  backgroundColor: Colors.grey[200],
                  radius: 50,
                  backgroundImage: profilePicture != null
                      ? FileImage(File(profilePicture!.path))
                          as ImageProvider<Object>
                      : AssetImage(
                          'assets/dashboard/imgs/page/profile/img-profile.png'),
                ),
              ),
              SizedBox(height: 20),
              _buildSectionLabel('Coordonnées & Informations'),
              _buildTextField(
                label: 'Numéro de contact',
                onChanged: (value) => phoneNumber = value,
              ),
              _buildTextField(
                label: 'Pays',
                onChanged: (value) => country = value,
              ),
              _buildTextField(
                label: 'Ville',
                onChanged: (value) => city = value,
              ),
              _buildTextField(
                label: 'Adresse Complète',
                onChanged: (value) => address = value,
              ),
              _buildTextField(
                label: 'Site personnel',
                onChanged: (value) => personalWebsite = value,
              ),
              _buildTextField(
                label: 'Bio',
                maxLines: 5,
                onChanged: (value) => bio = value,
              ),
              _buildDropdownField(
                label: 'Genre',
                value: gender,
                items: ['Homme', 'Femme'],
                onChanged: (value) {
                  setState(() {
                    gender = value!;
                  });
                },
              ),
              SizedBox(height: 40),
              _buildSectionLabel('Parcours Académique '),
              ...academicEntries.asMap().entries.map((entry) {
                int index = entry.key;
                return Column(
                  children: [
                    _buildTextField(
                      label: 'Institut',
                      onChanged: (value) {
                        academicEntries[index]['institute'] = value;
                      },
                    ),
                    _buildTextField(
                      label: 'Diplôme',
                      onChanged: (value) {
                        academicEntries[index]['degree'] = value;
                      },
                    ),
                    _buildTextField(
                      label: 'Année de graduation',
                      onChanged: (value) {
                        academicEntries[index]['graduation_year'] = value;
                      },
                    ),
                    _buildCenteredButton(
                      label: 'Supprimer',
                      onPressed: () => _removeAcademicEntry(index),
                    ),
                    SizedBox(height: 10),
                  ],
                );
              }).toList(),
              _buildCenteredButton(
                label: 'Ajouter une entrée',
                onPressed: _addAcademicEntry,
              ),
              SizedBox(height: 20),
              _buildSectionLabel('Expérience Professionnelle'),
              ...professionalEntries.asMap().entries.map((entry) {
                int index = entry.key;
                return Column(
                  children: [
                    _buildTextField(
                      label: 'Entreprise',
                      onChanged: (value) {
                        professionalEntries[index]['companyName'] = value;
                      },
                    ),
                    _buildTextField(
                      label: 'Titre du poste',
                      onChanged: (value) {
                        professionalEntries[index]['jobTitle'] = value;
                      },
                    ),
                    _buildTextField(
                      label: 'Année de début',
                      onChanged: (value) {
                        professionalEntries[index]['startDate'] = value;
                      },
                    ),
                    _buildTextField(
                      label: 'Année de fin',
                      onChanged: (value) {
                        professionalEntries[index]['endDate'] = value;
                      },
                    ),
                    _buildCenteredButton(
                      label: 'Supprimer',
                      onPressed: () => _removeProfessionalEntry(index),
                    ),
                    SizedBox(height: 10),
                  ],
                );
              }).toList(),
              _buildCenteredButton(
                label: 'Ajouter une entrée',
                onPressed: _addProfessionalEntry,
              ),
              SizedBox(height: 20),
              _buildSectionLabel('Compétences'),
              _buildTextField(
                label: 'Ajouter une compétence...',
                onChanged: (value) => skillInput = value,
                onSubmitted: (_) => _addSkill(),
              ),
              SizedBox(height: 10),
              Wrap(
                spacing: 8.0,
                children: selectedSkills
                    .map((skill) => Chip(
                          label: Text(skill),
                          onDeleted: () => _removeSkill(skill),
                        ))
                    .toList(),
              ),
              _buildTextField(
                label: 'Langues',
                onChanged: (value) => languages = value,
              ),
              
             
              SizedBox(height: 20),
              _buildSectionLabel('Documents'),
              _buildCVUploadSection(),
              SizedBox(height: 20),
              LoginButton(
                    loginText: 'Enregistrer',
                    onTapButton: saveProfile,
                  ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        label,
                         style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),

      ),
    );
  }

  Widget _buildTextField({
    required String label,
    int maxLines = 1,
    required ValueChanged<String> onChanged,
    void Function(String)? onSubmitted,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 5),
          TextFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            maxLines: maxLines,
            onChanged: onChanged,
            onFieldSubmitted: onSubmitted,
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 5),
          DropdownButtonFormField<String>(
            value: value,
            items: items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList(),
            onChanged: onChanged,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCenteredButton({
    required String label,
    required VoidCallback onPressed,
  }) {
    return Center(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        child: Text(label,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500,color: 
             const Color(
                  0xFF356899,
                ),
          ),
        ),
      ),
    );
  }

  Widget _buildCVUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Télécharger votre CV',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 10),
        ElevatedButton.icon(
          onPressed: _uploadCV,
          icon: Icon(Icons.upload_file,
          color: 
             const Color(
                  0xFF356899,
                ),
          ),
          label: Text('Choisir un fichier',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500,color: 
             const Color(
                  0xFF356899,
                ),
          ),),
        ),
        SizedBox(height: 10),
        if (cvFile != null)
          Text(
            'Fichier sélectionné : ${cvFile!.path.split('/').last}',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
      ],
    );
  }
}
