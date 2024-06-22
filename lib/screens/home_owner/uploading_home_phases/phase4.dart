import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marhba_bik/components/image_container.dart';
import 'package:marhba_bik/components/image_picker.dart';

class UploadingHomeFourthPhase extends StatefulWidget {
  final List<XFile?> selectedImages;
  final Function(int, XFile?) onImageSelected;

  const UploadingHomeFourthPhase({
    super.key,
    required this.selectedImages,
    required this.onImageSelected,
  });

  @override
  State<UploadingHomeFourthPhase> createState() =>
      _UploadingHomeFourthPhaseState();
}

class _UploadingHomeFourthPhaseState extends State<UploadingHomeFourthPhase> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'On y est presque ! Faites briller votre logement avec de belles photos',
            style: GoogleFonts.poppins(
              color:const Color(0xff001939),
              fontSize: 21,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Donnez vie à votre logement avec 3 photos captivantes',
            style: GoogleFonts.lato(
              color:const Color(0xff001939),
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
              'Sélectionner',
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
