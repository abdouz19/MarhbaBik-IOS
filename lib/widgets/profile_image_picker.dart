import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marhba_bik/components/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfileImagePicker extends StatelessWidget {
  final ImagePickerDialog imagePickerDialog;
  final File? imageFile;
  final Function(XFile?) onImageSelected;
  final VoidCallback onDelete;
  final String? initialImageUrl;

  const ProfileImagePicker({
    super.key,
    required this.imagePickerDialog,
    required this.imageFile,
    required this.onImageSelected,
    required this.onDelete,
    this.initialImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return imagePickerDialog;
                },
              );
            },
            child: Container(
              width: 200,
              height: 100,
              alignment: Alignment.center,
              child: imageFile != null
                  ? ClipOval(
                      child: Image.file(
                        imageFile!,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    )
                  : (initialImageUrl != null && initialImageUrl!.isNotEmpty
                      ? ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: initialImageUrl!,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Image.asset(
                          'assets/images/picture.jpg',
                          width: 100,
                          height: 100,
                        )),

            ),
          ),
          if (imageFile != null)
            Positioned(
              left: 10,
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red,
                ),
                child: IconButton(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete, color: Colors.white),
                  iconSize: 30,
                ),
              ),
            ),
          if (imageFile != null)
            Positioned(
              right: 10,
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green,
                ),
                child: IconButton(
                  onPressed: () async {
                    // Reset the _imageFile to null
                    onImageSelected(null);
                    await Future.delayed(const Duration(milliseconds: 100));
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return imagePickerDialog;
                      },
                    );
                  },
                  icon: const Icon(Icons.edit, color: Colors.white),
                  iconSize: 30,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
