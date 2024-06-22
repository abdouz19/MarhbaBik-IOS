import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class UploadingTripFifthPhase extends StatefulWidget {
  final Function(String) onPriceChanged;

  const UploadingTripFifthPhase({
    super.key,
    required this.onPriceChanged,
  });

  @override
  State<UploadingTripFifthPhase> createState() =>
      _UploadingTripFifthPhaseState();
}

class _UploadingTripFifthPhaseState extends State<UploadingTripFifthPhase> {
  final TextEditingController _priceController = TextEditingController(text: '0');

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'À présent, on passe au prix !',
            style: GoogleFonts.poppins(
              fontSize: 21,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Modifiable à tout moment !',
            style: GoogleFonts.lato(
              fontSize: 17,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 250,
            child: Center(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 85,
                    child: TextFormField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 5,
                      style: GoogleFonts.lato(
                        fontSize: 28,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        counterText: '', // Hide the counter
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      onChanged: (value) {
                        widget.onPriceChanged(value);
                      },
                    ),
                  ),
                  Text(
                    ' DZD/person',
                    style: GoogleFonts.lato(
                      fontSize: 33,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
