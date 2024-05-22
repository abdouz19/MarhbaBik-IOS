import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marhba_bik/components/dropdown_form_field.dart';
import 'package:marhba_bik/components/image_picker.dart';
import 'package:marhba_bik/components/material_button_auth.dart';
import 'package:marhba_bik/widgets/profile_image_picker.dart';
import 'package:marhba_bik/components/textfield.dart';

class TravelingAgencyEditProfile extends StatefulWidget {
  const TravelingAgencyEditProfile({super.key});

  @override
  State<TravelingAgencyEditProfile> createState() =>
      _TravelingAgencyEditProfileState();
}

class _TravelingAgencyEditProfileState
    extends State<TravelingAgencyEditProfile> {
  TextEditingController agencyName = TextEditingController();
  TextEditingController commercialRegisterNumber = TextEditingController();
  TextEditingController wilaya = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey<FormState>();

  String _agencyName = '';
  String _profilePicture = '';
  String _wilaya = '';
  String _commercialRegisterNumber = '';
  String _phoneNumber = '';
  late ImagePickerDialog _imagePickerDialog;
  File? _imageFile;

  bool _loading = true;
  bool _updating = false;

  @override
  void initState() {
    super.initState();
    fetchUserData();
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

  Future<void> fetchUserData() async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (userSnapshot.exists) {
        setState(() {
          _agencyName = userSnapshot['agencyName'];
          _profilePicture = userSnapshot['profilePicture'];
          _wilaya = userSnapshot['wilaya'];
          _commercialRegisterNumber = userSnapshot['commercialRegisterNumber'];
          _phoneNumber = userSnapshot['phoneNumber'];

          agencyName.text = _agencyName;
          commercialRegisterNumber.text = _commercialRegisterNumber;
          wilaya.text = _wilaya;
          phoneNumber.text = _phoneNumber;

          _loading = false;
        });
      }
    } catch (error) {
      print('Error fetching user data: $error');
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> updateUserProfile() async {
    setState(() {
      _updating = true;
    });

    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;

      String? downloadURL;

      // Check if the image file is not null and if it has changed
      if (_imageFile != null && _imageFile != File(_profilePicture)) {
        Reference storageReference = FirebaseStorage.instance.ref().child(
            'ProfilePictures/${DateTime.now().millisecondsSinceEpoch}.jpg');

        TaskSnapshot uploadTask = await storageReference.putFile(_imageFile!);

        downloadURL = await uploadTask.ref.getDownloadURL();
      }

      // Only update the profile picture if it has changed, else keep the existing one
      String profilePictureUrl = downloadURL ?? _profilePicture;

      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'agencyName': agencyName.text,
        'commercialRegisterNumber': commercialRegisterNumber.text,
        'wilaya': _wilaya,
        'phoneNumber': phoneNumber.text,
        'profilePicture': profilePictureUrl,
      });

      // Optionally, you can update the local state variables after the update is successful
      setState(() {
        _agencyName = agencyName.text;
        _profilePicture = profilePictureUrl;
        _commercialRegisterNumber = commercialRegisterNumber.text;
        _phoneNumber = phoneNumber.text;
        _updating = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (error) {
      print('Error updating user profile: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'An error occurred while updating profile. Please try again later.'),
          duration: Duration(seconds: 2),
        ),
      );
      setState(() {
        _updating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : Center(
              child: SingleChildScrollView(
                  child: Container(
                    width: double.infinity,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                      border: Border.all(
                        color: Colors.transparent,
                      ),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Form(
                        key: formState,
                        child: Column(
                          children: [
                            ProfileImagePicker(
                              imagePickerDialog: _imagePickerDialog,
                              imageFile: _imageFile,
                              initialImageUrl: _profilePicture,
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
                              height: 30,
                            ),
                            CustomizedTextFormField(
                              initialText: _agencyName,
                              label: 'Agency name',
                              hintText: 'Enter your agency name',
                              textEditingController: agencyName,
                              validator: (v) {
                                if (v == "") {
                                  return "Oops! Don't leave this field empty!";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            CustomizedTextFormField(
                              initialText: _commercialRegisterNumber,
                              label: 'Commercial Register No.',
                              hintText: 'Enter your commercial register number',
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
                              height: 20,
                            ),
                            WilayaDropdown(
                              initialText: _wilaya,
                              controller: wilaya,
                              hintText: 'Select your wilaya',
                              labelText: 'Wilaya',
                              validator: (v) {
                                if (v == "") {
                                  return "Oops! Don't leave this field empty!";
                                }
                                return null;
                              },
                              onWilayaSelected: (wilaya) {
                                setState(() {
                                  _wilaya = wilaya!;
                                });
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            CustomizedTextFormField(
                              initialText: _phoneNumber,
                              label: 'Phone number',
                              hintText: 'Enter your phone number',
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
                              height: 30,
                            ),
                            _updating
                                ? const CircularProgressIndicator()
                                : MaterialButtonAuth(
                                    label: 'Update',
                                    onPressed: () {
                                      if (formState.currentState!.validate()) {
                                        updateUserProfile();
                                      }
                                    },
                                  )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ),
      ),
    );
  }
}
