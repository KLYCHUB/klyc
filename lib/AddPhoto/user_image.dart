// ignore_for_file: depend_on_referenced_packages, unnecessary_string_interpolations

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:firebase_storage/firebase_storage.dart' as storage;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class UserImage extends StatefulWidget {
  final Function(String imageUrl) onFileChanged;

  const UserImage({Key? key, required this.onFileChanged}) : super(key: key);

  @override
  State<UserImage> createState() => _UserImageState();
}

class _UserImageState extends State<UserImage> {
  final ImagePicker _picker = ImagePicker();
  String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (imageUrl == null)
          const Icon(
            Icons.image,
            size: 60,
            color: Colors.black,
          ),
        if (imageUrl != null)
          InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () => _selectPhoto(),
            child: SizedBox(
              width: 80,
              height: 80,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: Image.network(imageUrl!),
              ),
            ),
          ),
        InkWell(
          onTap: () => _selectPhoto(),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              imageUrl != null ? 'Change Photo' : 'Select Photo',
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        )
      ],
    );
  }

  Future<void> _selectPhoto() async {
    await showModalBottomSheet(
      context: context,
      builder: (context) => BottomSheet(
        builder: (context) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera),
              title: const Text('Camera'),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.filter),
              title: const Text('Pick a file'),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
        onClosing: () {},
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile =
        await _picker.pickImage(source: source, imageQuality: 50);
    if (pickedFile == null) return;

    var imageCropper = ImageCropper();
    final croppedFile = await imageCropper.cropImage(
      sourcePath: pickedFile.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
    );
    if (croppedFile == null) return;

    final compressedFile = await compressImage(croppedFile.path, 35);

    await _uploadFile(compressedFile!.path);
  }

  Future<XFile?> compressImage(String path, int quality) async {
    final newPath = p.join(
      (await getTemporaryDirectory()).path,
      '${DateTime.now()}.${p.extension(path)}',
    );

    final result = await FlutterImageCompress.compressAndGetFile(
      path,
      newPath,
      quality: quality,
    );

    return result;
  }

  Future<void> _uploadFile(String path) async {
    final ref = storage.FirebaseStorage.instance
        .ref()
        .child('images')
        .child('${DateTime.now().toIso8601String() + p.basename(path)}');
    final result = await ref.putFile(File(path));
    final fileUrl = await result.ref.getDownloadURL();
    setState(() {
      imageUrl = fileUrl;
    });
    widget.onFileChanged(fileUrl);
  }
}
