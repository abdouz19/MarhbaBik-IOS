import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marhba_bik/components/image_container.dart';
import 'package:marhba_bik/components/image_picker.dart';

class UploadingTripFourthPhase extends StatefulWidget {
  final List<XFile?> selectedImages;
  final Function(int, XFile?) onImageSelected;

  const UploadingTripFourthPhase({
    super.key,
    required this.selectedImages,
    required this.onImageSelected,
  });

  @override
  State<UploadingTripFourthPhase> createState() =>
      _UploadingTripFourthPhaseState();
}

class _UploadingTripFourthPhaseState extends State<UploadingTripFourthPhase> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'We are almost there, give your trip a look!',
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Bring your trip to life with 3 captivating images',
            style: GoogleFonts.lato(
              fontSize: 17,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          MaterialButton(
            onPressed: () async {
              // Open image picker dialog
              showDialog(
                context: context,
                builder: (context) => ImagePickerDialog(
                  onImageSelected: (pickedImage) {
                    setState(() {
                      final index = widget.selectedImages
                          .indexWhere((element) => element == null);
                      if (index != -1) {
                        widget.onImageSelected(index, pickedImage);
                      }
                    });
                  },
                ),
              );
            },
            color: Colors.blue[800],
            child: Text(
              'Upload',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
          ),
          const SizedBox(height: 10),
          ImageContainerWithDelete(
            imageFile: widget.selectedImages[0] != null
                ? File(widget.selectedImages[0]!.path)
                : null,
            onDelete: () {
              setState(() {
                widget.onImageSelected(0, null);
              });
            },
            onTap: () {
              if (widget.selectedImages[0] == null) {
                showDialog(
                  context: context,
                  builder: (context) => ImagePickerDialog(
                    onImageSelected: (pickedImage) {
                      setState(() {
                        widget.onImageSelected(0, pickedImage);
                      });
                    },
                  ),
                );
              }
            },
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    // Open image picker dialog if the slot is empty
                    if (widget.selectedImages[1] == null) {
                      showDialog(
                        context: context,
                        builder: (context) => ImagePickerDialog(
                          onImageSelected: (pickedImage) {
                            setState(() {
                              widget.onImageSelected(1, pickedImage);
                            });
                          },
                        ),
                      );
                    }
                  },
                  child: ImageContainerWithDelete(
                    imageFile: widget.selectedImages[1] != null
                        ? File(widget.selectedImages[1]!.path)
                        : null,
                    onDelete: () {
                      setState(() {
                        widget.onImageSelected(1, null);
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    // Open image picker dialog if the slot is empty
                    if (widget.selectedImages[2] == null) {
                      showDialog(
                        context: context,
                        builder: (context) => ImagePickerDialog(
                          onImageSelected: (pickedImage) {
                            setState(() {
                              widget.onImageSelected(2, pickedImage);
                            });
                          },
                        ),
                      );
                    }
                  },
                  child: ImageContainerWithDelete(
                    imageFile: widget.selectedImages[2] != null
                        ? File(widget.selectedImages[2]!.path)
                        : null,
                    onDelete: () {
                      setState(() {
                        widget.onImageSelected(2, null);
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
