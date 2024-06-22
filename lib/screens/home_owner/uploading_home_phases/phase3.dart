import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marhba_bik/components/custom_textfield_outlined.dart';

class UploadingHomeThirdPhase extends StatefulWidget {
  final Function(String) onTitleChanged;
  final Function(String) onDescriptionChanged;

  const UploadingHomeThirdPhase({
    super.key,
    required this.onTitleChanged,
    required this.onDescriptionChanged,
  });

  @override
  State<UploadingHomeThirdPhase> createState() =>
      _UploadingHomeThirdPhaseState();
}

class _UploadingHomeThirdPhaseState extends State<UploadingHomeThirdPhase> {
  String titleValue = '';
  String descriptionValue = '';
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  bool validateInputs() {
    if (titleValue.isEmpty || descriptionValue.isEmpty) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Maintenant, donnons un titre et une description',
              style: GoogleFonts.poppins(
                color: const Color(0xff001939),
                fontSize: 21,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Rédigez un titre pour votre annonce',
              style: GoogleFonts.lato(
                color: const Color(0xff001939),
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            CustomTextFieldContainer(
              controller: titleController,
              height: 50,
              hintText: 'Piscine privée pour se détendre',
              onChanged: (value) {
                setState(() {
                  titleValue = value;
                });
                widget.onTitleChanged(value);
              },
            ),
            const SizedBox(height: 20),
            Text(
              'Rédigez une courte description ',
              style: GoogleFonts.lato(
                color: const Color(0xff001939),
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            CustomTextFieldContainer(
              controller: descriptionController,
              height: 200,
              hintText: 'Une expérience unique pour des souvenirs mémorables',
              onChanged: (value) {
                setState(() {
                  descriptionValue = value;
                });
                widget.onDescriptionChanged(value);
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
