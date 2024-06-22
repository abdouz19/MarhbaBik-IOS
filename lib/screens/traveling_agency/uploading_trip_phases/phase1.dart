import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marhba_bik/components/customized_step.dart';

class UploadingTripFirstPhase extends StatelessWidget {
  const UploadingTripFirstPhase({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Commencez facilement votre aventure sur MarhbaBik',
            style: GoogleFonts.poppins(
              fontSize: 21,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 30),
          const CustomizedStep(
            number: '1',
            title: 'Parlez-nous de votre voyage',
description: 'Partagez quelques informations de base, comme l\'endroit où il se déroule et le nombre d\'invités pouvant y séjourner'
          ),
          Container(
            width: double.infinity,
            height: 1, // Adjust height as needed
            color: Colors.black.withOpacity(0.1), // Color of the divider
            margin: const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
          ),
          const CustomizedStep(
            number: '2',
            title: 'Faites-le sortir du lot',
            description: 'Ajoutez au moins 5 photos, un titre et une description attrayante',
          ),
          Container(
            width: double.infinity,
            height: 1, // Adjust height as needed
            color: Colors.black.withOpacity(0.1), // Color of the divider
            margin: const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
          ),
          const CustomizedStep(
            number: '3',
            title: 'Publiez et gagnez !',
            description:
                'Définissez un prix de départ et publiez votre annonce',
          ),
          const SizedBox(height: 35,),
        ],
      ),
    );
  }
}
