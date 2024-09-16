import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:roomie_finder/main.dart';
import 'package:roomie_finder/views/Home/RFHomeScreen.dart';

class QuestionnaireScreen extends StatefulWidget {
  const QuestionnaireScreen({super.key});

  @override
  State<QuestionnaireScreen> createState() => _QuestionnaireScreenState();
}

class _QuestionnaireScreenState extends State<QuestionnaireScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // Personal Information
  String? age;
  String? gender;
  String? nationality;
  String? languagesSpoken;
  String? jobTitle;
  String? workSchedule;

  // Living Preferences
  String? preferredLocation;
  bool? smoking;
  bool? alcoholConsumption;
  bool? pets;
  double cleanlinessLevel = 3;
  String? roomTemperature;

  // Personality Traits
  double introvertExtrovert = 3;
  String? nightOwlOrEarlyBird;
  String? socialInteraction;
  String? conflictResolution;
  String? communicationStyle;

  // Roommate Preferences
  String? roommateGender;
  String? roommateNationality;
  String? roommateOccupation;
  double roommateCleanliness = 3;
  bool? sharingFoodUtilities;
  String? roommateAgeRange;
  double noiseTolerance = 3;

  // Lifestyle
  String? weekendActivities;
  String? exerciseRoutine;
  String? dietaryPreferences;
  String? workFromHomeFrequency;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Questionnaire'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Stack(
            children: [
              ListView(
                children: [
                  buildSectionTitle('Personal Information'),
                  buildDropdownField('Age', age, (value) => setState(() => age = value), List.generate(100, (index) => '${index + 1}')),
                  buildDropdownField('Gender', gender, (value) => setState(() => gender = value), ['Male', 'Female', 'Other']),
                  buildDropdownField('Nationality', nationality, (value) => setState(() => nationality = value), ['American', 'Canadian', 'Other']),
                  buildDropdownField('Languages Spoken', languagesSpoken, (value) => setState(() => languagesSpoken = value), ['English', 'Spanish', 'Other']),
                  buildDropdownField('Job Title/Occupation', jobTitle, (value) => setState(() => jobTitle = value), ['Engineer', 'Doctor', 'Other']),
                  buildDropdownField('Work Schedule', workSchedule, (value) => setState(() => workSchedule = value), ['Full-time', 'Part-time', 'Freelance']),
                  
                  buildSectionTitle('Living Preferences'),
                  buildDropdownField('Preferred Area/Location', preferredLocation, (value) => setState(() => preferredLocation = value), ['Urban', 'Suburban', 'Rural']),
                  buildSwitchField('Smoking', smoking, (value) => setState(() => smoking = value)),
                  buildSwitchField('Alcohol Consumption', alcoholConsumption, (value) => setState(() => alcoholConsumption = value)),
                  buildSwitchField('Pets', pets, (value) => setState(() => pets = value)),
                  buildSliderField('Cleanliness Level', cleanlinessLevel, (value) => setState(() => cleanlinessLevel = value)),
                  buildDropdownField('Ideal Room Temperature', roomTemperature, (value) => setState(() => roomTemperature = value), ['Cold', 'Warm', 'Hot']),
                  
                  buildSectionTitle('Personality Traits'),
                  buildSliderField('Introvert or Extrovert', introvertExtrovert, (value) => setState(() => introvertExtrovert = value)),
                  buildDropdownField('Night Owl or Early Bird', nightOwlOrEarlyBird, (value) => setState(() => nightOwlOrEarlyBird = value), ['Night Owl', 'Early Bird']),
                  buildDropdownField('Social Interaction', socialInteraction, (value) => setState(() => socialInteraction = value), ['Enjoys company', 'Prefers solitude']),
                  
                  buildSectionTitle('Roommate Preferences'),
                  buildDropdownField('Preferred Roommate Gender', roommateGender, (value) => setState(() => roommateGender = value), ['Male', 'Female', 'No preference']),
                  buildDropdownField('Preferred Roommate Nationality', roommateNationality, (value) => setState(() => roommateNationality = value), ['American', 'Canadian', 'Other']),
                  buildDropdownField('Preferred Roommate Occupation', roommateOccupation, (value) => setState(() => roommateOccupation = value), ['Engineer', 'Doctor', 'Other']),
                  buildSliderField('Roommate Cleanliness Expectation', roommateCleanliness, (value) => setState(() => roommateCleanliness = value)),
                  buildSwitchField('Open to Sharing Food/Utilities', sharingFoodUtilities, (value) => setState(() => sharingFoodUtilities = value)),
                  buildDropdownField('Ideal Roommate Age Range', roommateAgeRange, (value) => setState(() => roommateAgeRange = value), ['18-25', '26-35', '36-45', '46+']),
                  buildSliderField('Noise Tolerance', noiseTolerance, (value) => setState(() => noiseTolerance = value)),
                  
                  buildSectionTitle('Lifestyle'),
                  buildDropdownField('Weekend Activities', weekendActivities, (value) => setState(() => weekendActivities = value), ['Outdoor', 'Indoor', 'Mixed']),
                  buildDropdownField('Exercise Routine', exerciseRoutine, (value) => setState(() => exerciseRoutine = value), ['Daily', 'Weekly', 'Never']),
                  buildDropdownField('Dietary Preferences', dietaryPreferences, (value) => setState(() => dietaryPreferences = value), ['Vegetarian', 'Vegan', 'Non-Vegetarian']),
                  buildDropdownField('Work-from-Home Frequency', workFromHomeFrequency, (value) => setState(() => workFromHomeFrequency = value), ['Always', 'Sometimes', 'Never']),
                  
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _submitForm,
                    child: _isLoading ? const CircularProgressIndicator() : const Text('Submit'),
                  ),
                ],
              ),
              if (_isLoading)
                const Center(
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        await FirebaseFirestore.instance
            .collection('questionnaires')
            .doc(userModel!.id)
            .set({
          'age': age,
          'gender': gender,
          'nationality': nationality,
          'languagesSpoken': languagesSpoken,
          'jobTitle': jobTitle,
          'workSchedule': workSchedule,
          'preferredLocation': preferredLocation,
          'smoking': smoking,
          'alcoholConsumption': alcoholConsumption,
          'pets': pets,
          'cleanlinessLevel': cleanlinessLevel,
          'roomTemperature': roomTemperature,
          'introvertExtrovert': introvertExtrovert,
          'nightOwlOrEarlyBird': nightOwlOrEarlyBird,
          'socialInteraction': socialInteraction,
          'conflictResolution': conflictResolution,
          'communicationStyle': communicationStyle,
          'roommateGender': roommateGender,
          'roommateNationality': roommateNationality,
          'roommateOccupation': roommateOccupation,
          'roommateCleanliness': roommateCleanliness,
          'sharingFoodUtilities': sharingFoodUtilities,
          'roommateAgeRange': roommateAgeRange,
          'noiseTolerance': noiseTolerance,
          'weekendActivities': weekendActivities,
          'exerciseRoutine': exerciseRoutine,
          'dietaryPreferences': dietaryPreferences,
          'workFromHomeFrequency': workFromHomeFrequency,
        });

        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Form submitted')));
        const RFHomeScreen().launch(context, isNewTask: true);
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget buildDropdownField(String label, String? value, ValueChanged<String?> onChanged, List<String> items) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        ),
        value: value,
        onChanged: onChanged,
        validator: (value) => value == null ? 'Please select $label' : null,
        items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
      ),
    );
  }

  Widget buildSwitchField(String label, bool? value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      title: Text(label),
      value: value ?? false,
      onChanged: onChanged,
      subtitle: value == null ? Text('Please select $label') : null,
    );
  }

  Widget buildSliderField(String label, double value, ValueChanged<double> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        Slider(
          value: value,
          min: 1,
          max: 5,
          divisions: 4,
          label: value.round().toString(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
