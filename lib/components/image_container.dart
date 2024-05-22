import 'dart:io';

import 'package:flutter/material.dart';

class ImageContainerWithDelete extends StatelessWidget {
  final File? imageFile;
  final void Function()? onDelete;
  final void Function()? onTap;
  final double height;

  const ImageContainerWithDelete({
    super.key,
    this.imageFile,
    this.onDelete,
    this.onTap,
    this.height = 150,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          border: Border.all(
            width: 1.5,
            color: const Color.fromARGB(255, 148, 147, 147),
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: imageFile != null
            ? Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.file(
                      imageFile!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                  Positioned(
                    top: 5,
                    right: 5,
                    child: GestureDetector(
                      onTap: onDelete,
                      child: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              )
            : const Center(
                child: Icon(
                  Icons.image,
                  size: 50,
                  color: Color.fromARGB(255, 148, 147, 147),
                ),
              ),
      ),
    );
  }
}
