import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marhba_bik/components/custom_checkbox.dart';
import 'package:marhba_bik/components/dropdown_form_field.dart';
import 'package:marhba_bik/components/image_picker.dart';
import 'package:marhba_bik/components/material_button_auth.dart';
import 'package:marhba_bik/widgets/profile_image_picker.dart';
import 'package:marhba_bik/components/textfield.dart';

class TravelingAgencyInfoFormScreen extends StatefulWidget {
  const TravelingAgencyInfoFormScreen({super.key});

  @override
  State<TravelingAgencyInfoFormScreen> createState() {
    return _TravelingAgencyInfoFormScreenState();
  }
}

class _TravelingAgencyInfoFormScreenState extends State<TravelingAgencyInfoFormScreen> {
  TextEditingController agencyName = TextEditingController();
  TextEditingController commercialRegisterNumber = TextEditingController();
  TextEditingController wilaya = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  late ImagePickerDialog _imagePickerDialog;
  File? _imageFile;
  String? _selectedWilaya;
  bool _checkboxChecked = false;

  @override
  void initState() {
    super.initState();
    _imagePickerDialog = ImagePickerDialog(
      onImageSelected: (pickedImage) {
        handleImage(pickedImage);
      },
    );
  }

  Future<void> handleImage(XFile? pickedImage) async {
    if (pickedImage != null) {
      try {
        setState(() {
          _imageFile = File(pickedImage.path);
        });
      } catch (error) {
        showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text('Error picking image: $error'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
      }
    }
  }

  Future<void> signUp(
  BuildContext context,
  GlobalKey<FormState> formState,
  TextEditingController agencyName,
  TextEditingController commercialRegisterNumber,
  String? selectedWilaya,
  TextEditingController phoneNumber,
  File? imageFile,
  bool checkboxChecked,
) async {
  // Show circular progress indicator
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    },
  );

  if (formState.currentState!.validate()) {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;

      String? downloadURL;
      if (imageFile != null) {
        Reference storageReference = FirebaseStorage.instance.ref().child(
            'ProfilePictures/${DateTime.now().millisecondsSinceEpoch}.jpg');

        TaskSnapshot uploadTask = await storageReference.putFile(imageFile);

        downloadURL = await uploadTask.ref.getDownloadURL();
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({
        'agencyName': agencyName.text,
        'commercialRegisterNumber': commercialRegisterNumber.text,
        'wilaya': selectedWilaya,
        'phoneNumber': phoneNumber.text,
        'profilePicture': downloadURL,
        'personalDataProvided': true,
      });

      Navigator.pushReplacementNamed(context, '/traveler_home');
    } catch (e) {
      // Close the circular progress indicator dialog
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text(
              'An error occurred while signing up. Please try again later.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  } else {
    // Form validation failed, show snack bar
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please fill in all required fields.'),
        duration: Duration(seconds: 2),
      ),
    );
    // Close the circular progress indicator dialog
    Navigator.pop(context);
  }
}


  @override
  void dispose() {
    agencyName.dispose();
    commercialRegisterNumber.dispose();
    wilaya.dispose();
    phoneNumber.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Form(
              key: formState,
              child: Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  children: [
                    Text(
                      textAlign: TextAlign.center,
                      'To continue as a Home Owner, please fill in this information',
                      style: GoogleFonts.poppins(
                        color: const Color(0xff3F75BB),
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ProfileImagePicker(
                      imagePickerDialog: _imagePickerDialog,
                      imageFile: _imageFile,
                      onImageSelected: (pickedImage) {
                        handleImage(pickedImage);
                      },
                      onDelete: () {
                        setState(() {
                          _imageFile = null;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomizedTextFormField(
                      label: 'Agency name',
                      hintText: 'Ex: MarhbaBik',
                      textEditingController: agencyName,
                      validator: (v) {
                        if (v == "") {
                          return "Oops! Don't leave this field empty!";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomizedTextFormField(
                      label: 'Commercial Register No.',
                      hintText: '**********',
                      textEditingController: commercialRegisterNumber,
                      keyboardType: TextInputType.number,
                      validator: (v) {
                        if (v == "") {
                          return "Oops! Don't leave this field empty!";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    WilayaDropdown(
                      controller: wilaya,
                      hintText: 'Ex: Bouira',
                      labelText: 'Wilaya',
                      validator: (v) {
                        if (v == "") {
                          return "Oops! Don't leave this field empty!";
                        }
                        return null;
                      },
                      onWilayaSelected: (wilaya) {
                        // Pass the callback function
                        setState(() {
                          _selectedWilaya =
                              wilaya;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomizedTextFormField(
                      label: 'Phone number',
                      hintText: 'Ex: 0562202210',
                      textEditingController: phoneNumber,
                      keyboardType: TextInputType.number,
                      validator: (v) {
                        if (v == "") {
                          return "Oops! Don't leave this field empty!";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomCheckbox(
                      isChecked: _checkboxChecked,
                      onChanged: (value) {
                        setState(() {
                          _checkboxChecked = value!;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    MaterialButtonAuth(
                      onPressed: () {
                        if (_selectedWilaya == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please select a wilaya.'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        } else if (!_checkboxChecked) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please check the checkbox.'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        } else {
                          signUp(
                            context,
                            formState,
                            agencyName,
                            commercialRegisterNumber,
                            _selectedWilaya,
                            phoneNumber,
                            _imageFile,
                            _checkboxChecked,
                          );
                        }
                      },
                      label: 'Complete My Signup',
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
