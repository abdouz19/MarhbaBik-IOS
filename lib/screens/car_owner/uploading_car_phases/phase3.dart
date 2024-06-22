import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marhba_bik/components/custom_textfield_outlined.dart';

class UploadingCarThirdPhase extends StatefulWidget {
  final Function(String) onTitleChanged;
  final Function(String) onDescriptionChanged;

  const UploadingCarThirdPhase({
    super.key,
    required this.onTitleChanged,
    required this.onDescriptionChanged,
  });

  @override
  State<UploadingCarThirdPhase> createState() =>
      _UploadingCarThirdPhaseState();
}

class _UploadingCarThirdPhaseState extends State<UploadingCarThirdPhase> {
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
                color:const Color(0xff001939),
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
              hintText: 'Exemple : Berline élégante, modèle 2023',
              onChanged: (value) {
                setState(() {
                  titleValue = value;
                });
                widget.onTitleChanged(value);
              },
            ),
            const SizedBox(height: 20),
            Text(
              'Écrivez une petite description',
              style: GoogleFonts.lato(
                color:const Color(0xff001939),
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            CustomTextFieldContainer(
              controller: descriptionController,
              height: 200,
              hintText: 'Confortable et économique, cette voiture dispose d''un moteur puissant et est idéale pour les longs trajets en famillef',
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
