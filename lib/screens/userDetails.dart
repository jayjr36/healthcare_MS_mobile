// views/user_details_view.dart

import 'package:flutter/material.dart';
import 'package:healthcare_management_system/models/patient.dart';
import 'package:healthcare_management_system/providers/dioProvider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDetails extends StatefulWidget {
  @override
  _UserDetailsState createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  final DioProvider _patientController = DioProvider();
  String? token;
  loadpreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
    });
  }

  @override
  void initState() {
    super.initState();
    loadpreferences();
  }

  final _formKey = GlobalKey<FormState>();
  Patient _patient = Patient(
    firstName: "",
    lastName: "",
    email: "",
    contactNumber: "",
    dateOfBirth: "",
    gender: "",
    bloodGroup: "",
    maritalStatus: "",
    height: "",
    weight: "",
  );

  bool _isEditing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: <Widget>[
          _isEditing
              ? IconButton(
                  icon: Icon(Icons.save),
                  onPressed: () {
                    saveProfile();
                    setState(() {
                      _isEditing = false;
                    });
                  },
                )
              : IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    setState(() {
                      _isEditing = true;
                    });
                  },
                ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  enabled: _isEditing,
                  initialValue: _patient.firstName,
                  onChanged: (val) => setState(() => _patient.firstName = val),
                  decoration: InputDecoration(
                    labelText: 'First Name',
                    hintText: 'Enter first name',
                  ),
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  enabled: _isEditing,
                  initialValue: _patient.lastName,
                  onChanged: (val) => setState(() => _patient.lastName = val),
                  decoration: InputDecoration(
                    labelText: 'LastName',
                    hintText: 'Enter last name',
                  ),
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  enabled: _isEditing,
                  initialValue: _patient.email,
                  onChanged: (val) => setState(() => _patient.email = val),
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter Email',
                  ),
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  enabled: _isEditing,
                  initialValue: _patient.contactNumber,
                  onChanged: (val) =>
                      setState(() => _patient.contactNumber = val),
                  decoration: InputDecoration(
                    labelText: 'Phone',
                    hintText: 'Phone',
                  ),
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  enabled: _isEditing,
                  initialValue: _patient.dateOfBirth,
                  onChanged: (val) =>
                      setState(() => _patient.dateOfBirth = val),
                  decoration: InputDecoration(
                    labelText: 'Date of birth',
                    hintText: 'Date of Birth',
                  ),
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  enabled: _isEditing,
                  initialValue: _patient.gender,
                  onChanged: (val) => setState(() => _patient.gender = val),
                  decoration: InputDecoration(
                    labelText: 'Gender',
                    hintText: 'Gender',
                  ),
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  enabled: _isEditing,
                  initialValue: _patient.bloodGroup,
                  onChanged: (val) => setState(() => _patient.bloodGroup = val),
                  decoration: InputDecoration(
                    labelText: 'Blood Group',
                    hintText: 'Blood Group',
                  ),
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  enabled: _isEditing,
                  initialValue: _patient.maritalStatus,
                  onChanged: (val) =>
                      setState(() => _patient.maritalStatus = val),
                  decoration: InputDecoration(
                    labelText: 'Marital Status',
                    hintText: 'Marital Status',
                  ),
                ),

                if (_isEditing)
                  ElevatedButton(
                    onPressed: saveProfile,
                    child: Text("Save"),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> saveProfile() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await _patientController.savePatientDetails(_patient, token!);
    }
  }
}
