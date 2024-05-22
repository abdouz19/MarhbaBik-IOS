import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marhba_bik/components/material_button_auth.dart';
import 'package:marhba_bik/screens/traveling_agency/uploading_trip_phases/phase1.dart';
import 'package:marhba_bik/screens/traveling_agency/uploading_trip_phases/phase2.dart';
import 'package:marhba_bik/screens/traveling_agency/uploading_trip_phases/phase3.dart';
import 'package:marhba_bik/screens/traveling_agency/uploading_trip_phases/phase4.dart';
import 'package:marhba_bik/screens/traveling_agency/uploading_trip_phases/phase5.dart';
import 'package:marhba_bik/screens/traveling_agency/uploading_trip_phases/phase6.dart';

class UploadingTripProcess extends StatefulWidget {
  const UploadingTripProcess({super.key});

  @override
  State<UploadingTripProcess> createState() => _UploadingTripProcessState();
}

class _UploadingTripProcessState extends State<UploadingTripProcess> {
  int _currentStep = 0;
  List<XFile?> selectedImages = List<XFile?>.filled(3, null);
  DateTimeRange _dateTimeRange = DateTimeRange(start: DateTime.now(), end: DateTime.now());
  String? _selectedWilaya;
  List<String> _activities = [];
  int selectedCapacity = 0;
  String titleValue = '';
  String descriptionValue = '';
  String priceValue = '0';

  void presentDialog(String title, String content, String buttonText) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }

  void onImageSelected(int index, XFile? pickedImage) {
    setState(() {
      selectedImages[index] = pickedImage;
    });
  }

  bool validateSecondPhase() {
    if (_dateTimeRange.start == DateTime.now() || _dateTimeRange.end == DateTime.now() ||
        _selectedWilaya == null ||
        _activities.isEmpty ||
        selectedCapacity == 0) {
      return false;
    }
    return true;
  }

  bool validateThirdPhase() {
    if (titleValue.isEmpty || descriptionValue.isEmpty) {
      return false;
    }
    return true;
  }

  bool validateFifthPhase() {
    if (priceValue.isEmpty || int.tryParse(priceValue) == null) {
      return false;
    }
    return true;
  }

  Future<void> uploadDataToFirebase(BuildContext context) async {
  try {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 10),
            Text('Uploading data...'),
          ],
        ),
      ),
    );

    // Get current user data
    User? user = FirebaseAuth.instance.currentUser;
    String userId = user!.uid;
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get();

    // Upload images to Firebase Storage
    List<String> imageUrls = [];
    for (XFile? image in selectedImages) {
      if (image != null) {
        String imageName = DateTime.now().millisecondsSinceEpoch.toString();
        Reference ref = FirebaseStorage.instance
            .ref()
            .child('trip_images')
            .child('$userId')
            .child('$imageName.jpg');
        await ref.putFile(File(image.path));
        String imageUrl = await ref.getDownloadURL();
        imageUrls.add(imageUrl);
      }
    }
    Timestamp startDate = Timestamp.fromDate(_dateTimeRange.start);
    Timestamp endDate = Timestamp.fromDate(_dateTimeRange.end);

    // Upload data to Firestore without 'id' field
    DocumentReference docRef = await FirebaseFirestore.instance.collection('trips').add({
      'agencyId': userId,
      'agencyName': userSnapshot['agencyName'],
      'agencyProfilePicture': userSnapshot['profilePicture'],
      'images': imageUrls,
      'capacity': selectedCapacity,
      'title': titleValue,
      'description': descriptionValue,
      'price': priceValue,
      'wilaya': _selectedWilaya,
      'startDate': startDate,
      'endDate': endDate,
      'activities': _activities,
      'uploadedAt': FieldValue.serverTimestamp(),
    });

    // Retrieve the document ID
    String documentId = docRef.id;

    // Update the document with the 'id' field
    await docRef.update({'id': documentId});

    // Dismiss loading dialog
    Navigator.pop(context);

    // Show success message or navigate to next screen
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Success'),
        content: const Text('Your listing has been successfully published!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Dismiss success dialog
              Navigator.pop(context); // Dismiss bottom sheet
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  } catch (error) {
    print('Error uploading data: $error');
    // Dismiss loading dialog
    Navigator.pop(context);
    // Show error message
    presentDialog('Error', 'An error occurred while publishing your listing. Please try again later.', 'OK');
  }
}


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Create Your Listing'),
          leading: IconButton(
            icon: const Icon(Icons.close, size: 30),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Stepper(
          currentStep: _currentStep,
          onStepContinue: () {
            setState(() {
              if (_currentStep < 5) {
                if (_currentStep == 1) {
                  if (!validateSecondPhase()) {
                    presentDialog(
                      'Fill All Fields',
                      'Please fill all the fields before proceeding.',
                      'OK',
                    );
                    return;
                  } else {
                    print('Selected Place Type: $_dateTimeRange');
                    print('Selected Wilaya: $_selectedWilaya');
                    print('Address: $_activities');
                    print('Capacity: $selectedCapacity');
                  }
                }
                if (_currentStep == 2) {
                  if (!validateThirdPhase()) {
                    presentDialog(
                      'Fill All Fields',
                      'Please fill all the fields before proceeding.',
                      'OK',
                    );
                    return;
                  } else {
                    print('Title: $titleValue');
                    print('Description: $descriptionValue');
                  }
                }
                if (_currentStep == 3) {
                  bool allPhotosUploaded =
                      selectedImages.every((image) => image != null);
                  if (!allPhotosUploaded) {
                    presentDialog(
                      'Upload Photos',
                      'Please upload all three photos before proceeding.',
                      'OK',
                    );
                    return;
                  } else {
                    print('Images: $selectedImages');
                  }
                }
                if (_currentStep == 4) {
                  if (!validateFifthPhase()) {
                    presentDialog(
                      'Invalid Price',
                      'Please enter a valid price before proceeding.',
                      'OK',
                    );
                    return;
                  } else {
                    print('Price: $priceValue DZD/night');
                  }
                }
                _currentStep++;
              }
            });
          },
          onStepCancel: () {
            setState(() {
              if (_currentStep > 0) {
                _currentStep--;
              }
            });
          },
          controlsBuilder: (context, ControlsDetails details) {
            return Column(
              children: [
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    if (_currentStep > 0)
                      Expanded(
                        child: TextButton(
                          onPressed: details.onStepCancel,
                          child: Text(
                            'Back',
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    _currentStep == 0
                        ? const SizedBox(
                            width: 5,
                          )
                        : const Spacer(),
                    Expanded(
                      child: MaterialButtonAuth(
                        label: _currentStep == 0
                            ? 'Get Started'
                            : (_currentStep == 5 ? 'Publish' : 'Next'),
                        onPressed: _currentStep == 5
                            ? () {
                                uploadDataToFirebase(context);
                              }
                            : details.onStepContinue!,
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
          steps: [
            Step(
              title: const Text('Get Started'),
              content:
                  const SingleChildScrollView(child: UploadingTripFirstPhase()),
              isActive: _currentStep >= 0,
            ),
            Step(
              title: const Text('Property Details'),
              content: SingleChildScrollView(
                child: UploadingTripSecondPhase(
                  onTripDaysChanged: (value) {
                    setState(() {
                      _dateTimeRange = value;
                    });
                  },
                  onWilayaSelected: (value) {
                    setState(() {
                      _selectedWilaya = value;
                    });
                  },
                  onCapacityChanged: (value) {
                    setState(() {
                      selectedCapacity = value;
                    });
                  },
                  onTripActivitiesChanged: (value) {
                    setState(() {
                      _activities = value;
                    });
                  },
                ),
              ),
              isActive: _currentStep >= 1,
            ),
            Step(
              title: const Text('Describe Your Trip'),
              content: SingleChildScrollView(
                child: UploadingTripThirdPhase(
                  onTitleChanged: (value) {
                    setState(() {
                      titleValue = value;
                    });
                  },
                  onDescriptionChanged: (value) {
                    setState(() {
                      descriptionValue = value;
                    });
                  },
                ),
              ),
              isActive: _currentStep >= 2,
            ),
            Step(
              title: const Text('Showcase Your Trip'),
              content: UploadingTripFourthPhase(
                selectedImages: selectedImages,
                onImageSelected: onImageSelected,
              ),
              isActive: _currentStep >= 3,
            ),
            Step(
              title: const Text('Set Your Price'),
              content: SingleChildScrollView(
                child: UploadingTripFifthPhase(
                  onPriceChanged: (value) {
                    setState(() {
                      priceValue = value;
                    });
                  },
                ),
              ),
              isActive: _currentStep >= 4,
            ),
            Step(
              title: const Text('Review & Confirmation'),
              content: SingleChildScrollView(
                  child: UploadingTripFinalPhase(
                dates: _dateTimeRange,
                wilaya: _selectedWilaya ?? '',
                activities: _activities,
                capacity: selectedCapacity,
                title: titleValue,
                description: descriptionValue,
                images: selectedImages,
                price: priceValue,
              )),
              isActive: _currentStep >= 5,
            ),
          ],
        ),
      ),
    );
  }
}
