import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marhba_bik/api/firestore_service.dart';
import 'package:marhba_bik/components/custom_checkbox.dart';
import 'package:marhba_bik/components/dropdown_form_field.dart';
import 'package:marhba_bik/components/image_picker.dart';
import 'package:marhba_bik/components/material_button_auth.dart';
import 'package:marhba_bik/components/textfield.dart';
import 'package:marhba_bik/widgets/profile_image_picker.dart';

class CarOwnerInfoFormScreen extends StatefulWidget {
  const CarOwnerInfoFormScreen({Key? key}) : super(key: key);

  @override
  _CarOwnerInfoFormScreenState createState() => _CarOwnerInfoFormScreenState();
}

class _CarOwnerInfoFormScreenState extends State<CarOwnerInfoFormScreen> {
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController wilaya = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  late ImagePickerDialog _imagePickerDialog;
  File? _imageFile;
  String? _selectedWilaya;
  bool _checkboxChecked = false;

  // Placeholder image URL
  final String placeholderImageUrl =
      'https://firebasestorage.googleapis.com/v0/b/marhbabik-pfe.appspot.com/o/ProfilePictures%2Fplaceholder.png?alt=media&token=bdd7ceb3-55fc-49d7-83d9-07362b18813d';

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
            title: const Text('Erreur'),
            content: Text('Erreur lors de la sélection de l\'image: $error'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
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
    TextEditingController firstName,
    TextEditingController lastName,
    String? selectedWilaya,
    TextEditingController phoneNumber,
    File? imageFile,
    bool checkboxChecked,
  ) async {
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

        String? downloadURL = placeholderImageUrl; // Default to placeholder URL

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
          'firstName': firstName.text,
          'lastName': lastName.text,
          'wilaya': selectedWilaya,
          'phoneNumber': phoneNumber.text,
          'profilePicture': downloadURL,
          'personalDataProvided': true,
        });

        // Check if the user has paid their subscription fees
        final isSubscriptionPaid =
            await FirestoreService().checkSubscriptionPayment(userId);

        // Redirect based on subscription payment status
        if (isSubscriptionPaid) {
          Navigator.pushReplacementNamed(context, '/car_owner_home');
        } else {
          Navigator.pushReplacementNamed(context, '/subscription_screen');
        }
      } catch (e) {
        // Close the circular progress indicator dialog
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Erreur'),
            content: const Text(
                'Une erreur s\'est produite lors de l\'inscription. Veuillez réessayer plus tard.'),
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
          content: Text('Veuillez remplir tous les champs obligatoires.'),
          duration: Duration(seconds: 2),
        ),
      );
      // Close the circular progress indicator dialog
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    firstName.dispose();
    lastName.dispose();
    wilaya.dispose();
    phoneNumber.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                      'Pour continuer en tant que propriétaire de voiture, veuillez remplir ces informations',
                      textAlign: TextAlign.center,
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
                      label: 'Prénom',
                      hintText: 'Ex: Mohamed Abderraouf',
                      textEditingController: firstName,
                      validator: (v) {
                        if (v == "") {
                          return "Oups ! Ce champ ne peut pas être vide.";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomizedTextFormField(
                      label: 'Nom',
                      hintText: 'Ex: Zouaid',
                      textEditingController: lastName,
                      validator: (v) {
                        if (v == "") {
                          return "Oups ! Ce champ ne peut pas être vide.";
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
                          return "Oups ! Ce champ ne peut pas être vide.";
                        }
                        return null;
                      },
                      onWilayaSelected: (wilaya) {
                        // Pass the callback function
                        setState(() {
                          _selectedWilaya = wilaya;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomizedTextFormField(
                      label: 'Numéro de téléphone',
                      hintText: 'Ex: 0562202210',
                      textEditingController: phoneNumber,
                      keyboardType: TextInputType.number,
                      validator: (v) {
                        if (v == "") {
                          return "Oups ! Ce champ ne peut pas être vide.";
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
                              content:
                                  Text('Veuillez sélectionner une wilaya.'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        } else if (!_checkboxChecked) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Veuillez cocher la case.'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        } else {
                          signUp(
                            context,
                            formState,
                            firstName,
                            lastName,
                            _selectedWilaya,
                            phoneNumber,
                            _imageFile,
                            _checkboxChecked,
                          );
                        }
                      },
                      label: 'Mettre à jour',
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
