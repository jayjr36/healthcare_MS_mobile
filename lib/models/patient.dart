// models/patient.dart

class Patient {
  String firstName;
  String lastName;
  String email;
  String contactNumber;
  String dateOfBirth;
  String gender;
  String bloodGroup;
  String maritalStatus;
  String height;
  String weight;

  Patient({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.contactNumber,
    required this.dateOfBirth,
    required this.gender,
    required this.bloodGroup,
    required this.maritalStatus,
    required this.height,
    required this.weight,
  });
}
