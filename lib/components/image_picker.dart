import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ImagePickerDialog extends StatelessWidget {
  final Function(XFile?) onImageSelected;

  const ImagePickerDialog({super.key, required this.onImageSelected});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Sélectionner une image de profil'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.photo),
              title: const Text('Sélectionner depuis la galerie'),
              onTap: () async {
                Navigator.pop(context); // Close dialog

                // Request gallery permission
                var status = await Permission.storage.request();
                if (status.isGranted) {
                  final pickedImage = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);
                  onImageSelected(pickedImage); // Pass XFile to callback
                } else {
                  // Handle permission denied
                  print('Gallery permission denied');
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Prendre une photo'),
              onTap: () async {
                Navigator.pop(context); // Close dialog

                // Request camera permission
                var status = await Permission.camera.request();
                if (status.isGranted) {
                  final pickedImage =
                      await ImagePicker().pickImage(source: ImageSource.camera);
                  onImageSelected(pickedImage); // Pass XFile to callback
                } else {
                  print('Camera permission denied');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
