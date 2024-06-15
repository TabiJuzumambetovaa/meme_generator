import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share/share.dart';

class MemeGeneratorScreen extends StatefulWidget {
  const MemeGeneratorScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MemeGeneratorScreenState createState() => _MemeGeneratorScreenState();
}

class _MemeGeneratorScreenState extends State<MemeGeneratorScreen> {
  String imageUrl = '';
  String userText = '';

  Future<void> _pickImageFromGallery() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        imageUrl = pickedFile.path;
      });
    }
  }

  void _shareImage() {
    if (imageUrl.isNotEmpty) {
      Share.shareFiles([imageUrl], text: 'Поделиться мемом!');
    } else {
      // Показать предупреждение, если изображение отсутствует
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Нет изображения'),
            content: const Text('Сначала выберите или загрузите изображение.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final decoration = BoxDecoration(
      border: Border.all(
        color: Colors.white,
        width: 2,
      ),
    );

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: ColoredBox(
          color: Colors.black,
          child: DecoratedBox(
            decoration: decoration,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 50,
                vertical: 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    width: double.infinity,
                    height: 400,
                    child: DecoratedBox(
                      decoration: decoration,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: imageUrl.isNotEmpty
                            ? (imageUrl.startsWith('http') || imageUrl.startsWith('https')
                                ? Image.network(
                                    imageUrl,
                                    fit: BoxFit.cover,
                                  )
                                : Image.file(
                                    File(imageUrl),
                                    fit: BoxFit.cover,
                                  ))
                            : Container(), // Отобразить изображение только если есть URL или файл
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _pickImageFromGallery,
                    child: const Text('Выбрать из галереи'),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    onChanged: (text) {
                      setState(() {
                        imageUrl = text;
                      });
                    },
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Impact',
                      fontSize: 20,
                      color: Colors.white,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Введите URL изображения или выберите из галереи',
                      hintStyle: TextStyle(
                        fontFamily: 'Impact',
                        fontSize: 20,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    onChanged: (text) {
                      setState(() {
                        userText = text;
                      });
                    },
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Impact',
                      fontSize: 20,
                      color: Colors.white,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Введите ваш текст',
                      hintStyle: TextStyle(
                        fontFamily: 'Impact',
                        fontSize: 20,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _shareImage,
                    child: const Text('Поделиться'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
