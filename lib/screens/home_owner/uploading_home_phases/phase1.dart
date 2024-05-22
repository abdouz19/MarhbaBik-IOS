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
            'It’s easy to get started on MarhbaBik',
            style: GoogleFonts.poppins(
              color:const Color(0xff001939),
              fontSize: 23,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 30),
          const CustomizedStep(
            number: '1',
            title: 'Tell us about your place',
            description:
                'Share some basic info, like where it is and how many guests can stay',
          ),
          Container(
            width: double.infinity,
            height: 1, // Adjust height as needed
            color: const Color(0xff001939).withOpacity(0.1), // Color of the divider
            margin: const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
          ),
          const CustomizedStep(
            number: '2',
            title: 'Make it stand out',
            description: 'Add 5 or more photos plus a title and description',
          ),
          Container(
            width: double.infinity,
            height: 1, // Adjust height as needed
            color: const Color(0xff001939).withOpacity(0.1), // Color of the divider
            margin: const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
          ),
          const CustomizedStep(
            number: '3',
            title: 'Finish up and publish',
            description: 'Set a starting price and publish your listing',
          ),
          const SizedBox(height: 35,),
        ],
      ),
    );
  }
}
