import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:jobfinder/formsForFirst/education.dart'; // Importing the education form
import 'package:jobfinder/welcome.dart'; // Importing the welcome screen

class UserInfoPage extends StatefulWidget {
  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}
class _UserInfoPageState extends State<UserInfoPage> {
  final user = FirebaseAuth.instance.currentUser; // Current user

  // Form key and controllers for input fields
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _cityController = TextEditingController();
  final _countryController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance; // Firebase Auth instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Firestore instance
// Current user object
  Map<String, dynamic> _userInfo = {}; // User information

  @override
  void initState() {
    super.initState();
    _getUserData(); // Get user data when the widget initializes
  }

  // Function to retrieve user data from Firestore
  Future<void> _getUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      setState(() {
      });
      final userData = await _firestore.collection('users').doc(user.uid).get();
      if (userData.exists) {
        final userDataMap = userData.data() as Map<String, dynamic>;

        final userInfo = await _firestore.collection('users').doc(user.uid).get();
        setState(() {
          _userInfo = userInfo.data() as Map<String, dynamic>;
        });
        setState(() {
          _userInfo = userDataMap;
        });
      }
    }
  }

  // Function to check if a string is numeric
  bool _isNumeric(String value) {
    return double.tryParse(value) != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: Text(
          'User Information'.tr, // Translate 'User Information' text
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 6, 60, 74),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app, color: Colors.white),
            onPressed: () async {
              await _signOut(); // Sign out action
            },
          ),
        ],
      ),
      backgroundColor: Color.fromARGB(255, 134, 160, 166),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          margin: EdgeInsets.all(16.0),
          color: Colors.grey[200],
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Displaying user email
                Text(
                  'Email:  ${user!.email.toString()} ',
                  style: TextStyle(fontSize: 17),
                ),
                SizedBox(height: 16.0),
                // Input field for full name
                _buildTextFormField(
                  controller: _nameController,
                  labelText: 'Full Name'.tr,
                  icon: Icons.person,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your full name'.tr;
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                // Input field for phone number
                _buildTextFormField(
                  controller: _phoneController,
                  labelText: "Phone".tr,
                  maxLength: 10,
                  hinText: _userInfo['phoneNumber'] ?? 'N/A', // Hint text
                  icon: Icons.phone,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your phone number'.tr;
                    } else if (value.length != 10) {
                      return 'Phone number must be 10 digits'.tr;
                    } else if (!_isNumeric(value)) {
                      return 'Phone number must contain only digits'.tr;
                    }
                    return null;
                  },
                ),
                // Address input fields
                SizedBox(height: 16.0),
                Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Address'.tr, // Translate 'Address' text
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16.0),
                      // Input field for pincode
                      _buildTextFormField(
                        maxLength: 6,
                        controller: _pincodeController,
                        labelText: 'Pincode'.tr, // Translate 'Pincode' text
                        icon: Icons.location_on,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter the pincode'.tr;
                          } else if (value.length != 6) {
                            return 'Pincode must be 6 digits'.tr;
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.0),
                      // Input field for city
                      _buildTextFormField(
                        controller: _cityController,
                        labelText: 'City'.tr, // Translate 'City' text
                        icon: Icons.location_city,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter the city'.tr;
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.0),
                      // Input field for country
                      _buildTextFormField(
                        controller: _countryController,
                        labelText: 'Country'.tr, // Translate 'Country' text
                        icon: Icons.location_on,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter the country'.tr;
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                // Button to save user information
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16.0), backgroundColor: Color.fromARGB(255, 6, 60, 74),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _saveUserDataToFirestore(); // Save user data action
                    }
                  },
                  child: Text(
                    'save'.tr, // Translate 'save' button text
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Function to build text form fields with common properties
  TextFormField _buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    required TextInputType keyboardType,
    required String? Function(String?) validator,
    int? maxLength, // Added maxLength parameter
    String? hinText,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      enabled: true,
      decoration: InputDecoration(
        hintText: hinText,
        labelText: labelText,
        icon: Icon(
          icon,
          color: Color.fromARGB(255, 6, 60, 74),
        ),
        border: OutlineInputBorder(),
      ),
      validator: validator,
      maxLength: maxLength, // Added maxLength property
    );
  }

  // Function to sign out the user
  Future<void> _signOut() async {
    try {
      await _auth.signOut();
      Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return const Welcome();
        },
      ));
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  // Function to save user data to Firestore
  Future<void> _saveUserDataToFirestore() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final userData = {
        'name': _nameController.text,
        'email': user?.email.toString(),
        'phone': _phoneController.text,
        'address': {
          'pincode': _pincodeController.text,
          'city': _cityController.text,
          'country': _countryController.text,
        },
      };
      final docId = currentUser.uid;
      final userRef = FirebaseFirestore.instance.collection('userdata').doc(docId);
      await userRef.set(userData);
      _showSuccessMessage();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddEducationPage(), // Navigate to AddEducationPage after saving data
        ),
      );
    }
  }

  // Function to show a success message
  void _showSuccessMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('User information saved successfully.'.tr), // Translate success message
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    // Dispose controllers to avoid memory leaks
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _pincodeController.dispose();
    _cityController.dispose();
    _countryController.dispose();
    super.dispose();
  }
}
