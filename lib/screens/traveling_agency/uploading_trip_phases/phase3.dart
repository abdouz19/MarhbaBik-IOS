import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marhba_bik/components/custom_textfield_outlined.dart';

class UploadingTripThirdPhase extends StatefulWidget {
  final Function(String) onTitleChanged;
  final Function(String) onDescriptionChanged;

  const UploadingTripThirdPhase({
    super.key,
    required this.onTitleChanged,
    required this.onDescriptionChanged,
  });

  @override
  State<UploadingTripThirdPhase> createState() =>
      _UploadingTripThirdPhaseState();
}

class _UploadingTripThirdPhaseState extends State<UploadingTripThirdPhase> {
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
              'Now, let’s give your trip a title & description',
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Write a title for your trip',
              style: GoogleFonts.lato(
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            CustomTextFieldContainer(
              controller: titleController,
              height: 50,
              hintText: 'Wonderful trip today',
              onChanged: (value) {
                setState(() {
                  titleValue = value;
                });
                widget.onTitleChanged(value);
              },
            ),
            const SizedBox(height: 20),
            Text(
              'Write a small description',
              style: GoogleFonts.lato(
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            CustomTextFieldContainer(
              controller: descriptionController,
              height: 200,
              hintText: 'A lovely trip ak chayef',
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
