import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marhba_bik/components/material_button_auth.dart';
import 'package:marhba_bik/screens/car_owner/uploading_car_phases/phase1.dart';
import 'package:marhba_bik/screens/car_owner/uploading_car_phases/phase2.dart';
import 'package:marhba_bik/screens/car_owner/uploading_car_phases/phase3.dart';
import 'package:marhba_bik/screens/car_owner/uploading_car_phases/phase4.dart';
import 'package:marhba_bik/screens/car_owner/uploading_car_phases/phase5.dart';
import 'package:marhba_bik/screens/car_owner/uploading_car_phases/phase6.dart';

class UploadingCarProcess extends StatefulWidget {
  const UploadingCarProcess({super.key});

  @override
  State<UploadingCarProcess> createState() => _UploadingCarProcessState();
}

class _UploadingCarProcessState extends State<UploadingCarProcess> {
  int _currentStep = 0;
  List<XFile?> selectedImages = List<XFile?>.filled(3, null);
  String _carBrandValue = '';
  String? _selectedWilaya;
  String _carModelValue = '';
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
    if (_carBrandValue.isEmpty ||
        _selectedWilaya == null ||
        _carModelValue.isEmpty ||
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
            Text('Téléchargement en cours...'),
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
            .child('car_images')
            .child('$userId')
            .child('$imageName.jpg');
        await ref.putFile(File(image.path));
        String imageUrl = await ref.getDownloadURL();
        imageUrls.add(imageUrl);
      }
    }
    

    // Upload data to Firestore without 'id' field
    DocumentReference docRef = await FirebaseFirestore.instance.collection('cars').add({
        'ownerId': userId,
        'ownerFirstName': userSnapshot['firstName'],
        'ownerLastName': userSnapshot['lastName'],
        'ownerProfilePicture': userSnapshot['profilePicture'],
        'images': imageUrls,
        'capacity': selectedCapacity,
        'title': titleValue,
        'description': descriptionValue,
        'price': priceValue,
        'wilaya': _selectedWilaya,
        'brand': _carBrandValue,
        'model': _carModelValue,
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
        title: const Text('Opération réussie !'),
        content: const Text('C\'est publié ! Votre logement est prêt à accueillir des voyageurs.'),
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
    presentDialog('Erreur','Une erreur est survenue lors de la publication de votre annonce. Veuillez réessayer plus tard.', 'OK');
  }
}


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Rédigez votre annonce', style: GoogleFonts.lato(
            color: const Color(0xff001939),
          ),),
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
                      'N\'oubliez pas de remplir tous les champs !',
                      'Remplis tous les champs avant de passer à la suite !',
                      'OK',
                    );
                    return;
                  } else {
                    print('Selected Place Type: $_carBrandValue');
                    print('Selected Wilaya: $_selectedWilaya');
                    print('Address: $_carModelValue');
                    print('Capacity: $selectedCapacity');
                  }
                }
                if (_currentStep == 2) {
                  if (!validateThirdPhase()) {
                    presentDialog(
                      'N\'oubliez pas de remplir tous les champs !',
                      'Remplis tous les champs avant de passer à la suite !',
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
                      'Télécharger des photos',
                      'Veuillez télécharger les trois photos avant de continuer.',
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
                      'Prix invalide',
                      'Veuillez entrer un prix valide avant de continuer.',
                      'OK',
                    );
                    return;
                  } else {
                    print('Prix: $priceValue DZD/jour');
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
                            'Retour',
                            style: GoogleFonts.poppins(
                              color:const Color(0xff001939),
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
                            ? 'C\'est parti !'
                            : (_currentStep == 5 ? 'Publier' : 'Suivant'),
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
              title: Text('C\'est parti !', style: GoogleFonts.lato(
                color: const Color(0xff001939),
              ),),
              content:
                  const SingleChildScrollView(child: UploadingCarFirstPhase()),
              isActive: _currentStep >= 0,
            ),
            Step(
              title: Text('Détails de la propriété', style: GoogleFonts.lato(
                color: const Color(0xff001939),
              ),),
              content: SingleChildScrollView(
                child: UploadingCarSecondPhase(
                  onCarBrandChanged: (value) {
                    setState(() {
                      _carBrandValue = value;
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
                  onCarModelChanged: (value) {
                    setState(() {
                      _carModelValue = value;
                    });
                  },
                ),
              ),
              isActive: _currentStep >= 1,
            ),
            Step(
              title: Text('Présentez votre voiture', style: GoogleFonts.lato(
                color:const Color(0xff001939),
              ),),
              content: SingleChildScrollView(
                child: UploadingCarThirdPhase(
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
              title:  Text('Donnez vie à votre voiture',style: GoogleFonts.lato(
                color:const Color(0xff001939),
              ),),
              content: UploadingCarFourthPhase(
                selectedImages: selectedImages,
                onImageSelected: onImageSelected,
              ),
              isActive: _currentStep >= 3,
            ),
            Step(
              title:  Text('Choisissez votre prix !',style: GoogleFonts.lato(
                color:const Color(0xff001939),
              ),),
              content: SingleChildScrollView(
                child: UploadingCarFifthPhase(
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
              title:  Text('Vérifiez et confirmez',style: GoogleFonts.lato(
                color:const Color(0xff001939),
              ),),
              content: SingleChildScrollView(
                  child: UploadingCarFinalPhase(
                brand: _carBrandValue,
                wilaya: _selectedWilaya ?? '',
                model: _carModelValue,
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
