import 'package:flutter/material.dart';
import 'package:job_search_app/features/auth/presentation/widgets/login_button.dart';

class JobFormScreen extends StatefulWidget {
  @override
  _JobFormScreenState createState() => _JobFormScreenState();
}

class _JobFormScreenState extends State<JobFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _yearsOfExperienceController = TextEditingController();
  final TextEditingController _minSalaryController = TextEditingController();
  final TextEditingController _maxSalaryController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _internshipDurationController = TextEditingController();
  final TextEditingController _internshipMotivationController = TextEditingController();

  List<String> domains = [
    "Informatique",
    "Finance",
    "Mecanique",
    "Marketing",
    "Ressources Humaines",
    "Architecture",
    "Design",
    "Autre"
  ];
  String selectedDomain = "Informatique";
  String selectedEmploymentType = "0";
  String selectedWorkplace = "0";
  bool isFeatured = false;
  List<String> skills = []; // Populate this list as needed
  List<String> selectedSkills = [];
  List<String> filteredSkills = [];
  String formType = 'job'; // Default type
  String skillInput = '';

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      // Handle form submission
    }
  }

  void _filterSkills(String query) {
    setState(() {
      filteredSkills = skills
          .where((skill) => skill.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _addSkill() {
    if (skillInput.isNotEmpty && !selectedSkills.contains(skillInput)) {
      setState(() {
        selectedSkills.add(skillInput);
        skillInput = '';
        
        skillInput = '';
      });
    }
  }

  void _removeSkill(String skill) {
    setState(() {
      selectedSkills.remove(skill);
    });
  }

  Widget _buildTextField({
    required String label,
    required void Function(String) onChanged,
    required VoidCallback onSubmitted,
    TextEditingController? controller,
    TextInputType? keyboardType,
    String? initialValue,
    int? maxLines,
    bool? obscureText,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText ?? false,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      onChanged: onChanged,
      onSubmitted: (_) => onSubmitted(),
      maxLines: maxLines,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Poster une annonce'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Form Type Dropdown
              DropdownButtonFormField<String>(
                value: formType,
                items: [
                  DropdownMenuItem(value: 'job', child: Text('Job')),
                  DropdownMenuItem(value: 'internship', child: Text('Internship')),
                ],
                onChanged: (value) {
                  setState(() {
                    formType = value!;
                    _filterSkills(skillInput);
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Form Type *',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),

              // Title
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Please enter a title' : null,
              ),
              SizedBox(height: 16.0),

              // Description
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description *',
                  border: OutlineInputBorder(),
                ),
                maxLines: 8,
                validator: (value) => value!.isEmpty ? 'Please enter a description' : null,
              ),
              SizedBox(height: 16.0),

              // Domain Dropdown
              DropdownButtonFormField<String>(
                value: selectedDomain,
                items: domains.map((domain) => DropdownMenuItem(
                  value: domain,
                  child: Text(domain),
                )).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedDomain = value!;
                    _filterSkills(skillInput);
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Domain *',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),

              // Employment Type Dropdown
              DropdownButtonFormField<String>(
                value: selectedEmploymentType,
                items: [
                  DropdownMenuItem(value: "0", child: Text('Demi-Temps')),
                  DropdownMenuItem(value: "1", child: Text('Plein-Temps')),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedEmploymentType = value!;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Employment Type *',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),

              // Workplace Type Dropdown
              DropdownButtonFormField<String>(
                value: selectedWorkplace,
                items: [
                  DropdownMenuItem(value: "0", child: Text('Teletravail')),
                  DropdownMenuItem(value: "1", child: Text('Bureau')),
                  DropdownMenuItem(value: "2", child: Text('Hybride')),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedWorkplace = value!;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Workplace Type *',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),

              // Conditional Fields based on Form Type
              if (formType == 'job') ...[
                TextFormField(
                  controller: _yearsOfExperienceController,
                  decoration: InputDecoration(
                    labelText: 'Année expérience *',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? 'Please enter years of experience' : null,
                ),
                SizedBox(height: 16.0),

                TextFormField(
                  controller: _minSalaryController,
                  decoration: InputDecoration(
                    labelText: 'Min Salary *',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? 'Please enter the minimum salary' : null,
                ),
                SizedBox(height: 16.0),

                TextFormField(
                  controller: _maxSalaryController,
                  decoration: InputDecoration(
                    labelText: 'Max Salary *',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? 'Please enter the maximum salary' : null,
                ),
                SizedBox(height: 16.0),
              ] else if (formType == 'internship') ...[
                TextFormField(
                  controller: _internshipDurationController,
                  decoration: InputDecoration(
                    labelText: 'Internship Duration *',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value!.isEmpty ? 'Please enter the duration' : null,
                ),
                SizedBox(height: 16.0),

                TextFormField(
                  controller: _internshipMotivationController,
                  decoration: InputDecoration(
                    labelText: 'Motivation for Internship *',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.text,
                  maxLines: 4,
                  validator: (value) => value!.isEmpty ? 'Please enter your motivation' : null,
                ),
                SizedBox(height: 16.0),
              ],

              // Address
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: 'Address *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Please enter the address' : null,
              ),
              SizedBox(height: 16.0),

              // City
              TextFormField(
                controller: _cityController,
                decoration: InputDecoration(
                  labelText: 'City *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Please enter the city' : null,
              ),
              SizedBox(height: 16.0),

              // Country
              TextFormField(
                controller: _countryController,
                decoration: InputDecoration(
                  labelText: 'Country *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Please enter the country' : null,
              ),
              SizedBox(height: 16.0),

              // Skills Input
              _buildTextField(
                label: 'Add Skill',
                onChanged: (value) => skillInput = value,
                onSubmitted: _addSkill,
                controller: null, // No controller needed here
                keyboardType: TextInputType.text,
              ),
              SizedBox(height: 16.0),

              // Display Selected Skills
              Wrap(
                spacing: 8.0,
                children: selectedSkills.map((skill) => Chip(
                  label: Text(skill),
                  onDeleted: () => _removeSkill(skill),
                )).toList(),
              ),
              SizedBox(height: 16.0),

              // Submit Button
              LoginButton(
                    loginText: "Publier l'annonce",
                    onTapButton: _submitForm,
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
