import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marhba_bik/components/customized_step.dart';

class UploadingHomeFirstPhase extends StatelessWidget {
  const UploadingHomeFirstPhase({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Commencez facilement votre aventure sur MarhbaBik.',
            style: GoogleFonts.poppins(
              color: const Color(0xff001939),
              fontSize: 21,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 30),
          const CustomizedStep(
            number: '1',
            title: 'Parlez-nous de votre logement',
            description:
                'Partagez quelques informations de base, comme son emplacement et le nombre de voyageurs qu\'il peut accueillir',
          ),
          Container(
            width: double.infinity,
            height: 1, // Adjust height as needed
            color: const Color(0xff001939)
                .withOpacity(0.1), // Color of the divider
            margin: const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
          ),
          const CustomizedStep(
            number: '2',
            title: 'Faites-le sortir du lot',
            description:
                'Ajoutez au moins 5 photos, un titre et une description attrayante',
          ),
          Container(
            width: double.infinity,
            height: 1, // Adjust height as needed
            color: const Color(0xff001939)
                .withOpacity(0.1), // Color of the divider
            margin: const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
          ),
          const CustomizedStep(
            number: '3',
            title: 'Publiez et gagnez !',
            description:
                'Définissez un prix de départ et publiez votre annonce',
          ),
          const SizedBox(
            height: 35,
          ),
        ],
      ),
    );
  }
}
