// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages

import 'dart:typed_data';
import 'package:brain_fusion/brain_fusion.dart';
import 'package:flutter/material.dart';
import 'package:klyc/components/custom_button.dart';
import 'package:klyc/components/my_textfield.dart';
import 'package:shimmer/shimmer.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

enum AIStyleOption {
  noStyle,
  anime,
  moreDetails,
  cyberPunk,
  kandinskyPainter,
  aivazovskyPainter,
  malevichPainter,
  picassoPainter,
  goncharovaPainter,
  classicism,
  renaissance,
  oilPainting,
  pencilDrawing,
  digitalPainting,
  medievalStyle,
  render3D,
  cartoon,
  studioPhoto,
  portraitPhoto,
  khokhlomaPainter,
  christmas,
}

enum ResolutionOption {
  r1x1,
  r16x9,
  r9x16,
  r3x2,
  r2x3,
}

class PhotoAI extends StatefulWidget {
  const PhotoAI({Key? key}) : super(key: key);

  @override
  State<PhotoAI> createState() => _PhotoAIState();
}

class _PhotoAIState extends State<PhotoAI> {
  final AI ai = AI();
  final TextEditingController textEditingController =
      TextEditingController(text: "HAYALİNİ YAZ");
  AIStyleOption selectedStyle = AIStyleOption.anime;
  ResolutionOption selectedResolution = ResolutionOption.r1x1;
  bool isGenerating = false;

  Uint8List? generatedImage;

  Future<void> generate(
      String query, AIStyleOption style, Resolution resolution) async {
    setState(() {
      isGenerating = true;
    });

    if (mounted) {
      Uint8List image =
          await ai.runAI(query, AIStyle.values[style.index], resolution);
      setState(() {
        generatedImage = image;
        isGenerating = false;
      });
    }
  }

  Future<void> saveImageToDevice(Uint8List imageBytes) async {
    final result = await ImageGallerySaver.saveImage(imageBytes);
    if (result['isSuccess']) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Resim Galeriye Kaydedildi')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Hata! Resim Kaydedilmedi.')),
      );
    }
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.black87,
        centerTitle: true,
        title: const Text('RESİM OLUŞTUR'),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: isPortrait
                  ? MediaQuery.of(context).size.width
                  : MediaQuery.of(context).size.height * 0.7,
              width: MediaQuery.of(context).size.width,
              child: isGenerating
                  ? Shimmer.fromColors(
                      baseColor: Colors.black,
                      highlightColor: Colors.white,
                      child: Container(
                        color: Colors.black87,
                        width: MediaQuery.of(context).size.width,
                        height: isPortrait
                            ? MediaQuery.of(context).size.width
                            : MediaQuery.of(context).size.height * 0.7,
                      ),
                    )
                  : generatedImage != null
                      ? Image.memory(generatedImage!)
                      : Container(),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: DropdownButtonFormField<AIStyleOption>(
                      value: selectedStyle,
                      onChanged: (newValue) {
                        setState(() {
                          selectedStyle = newValue!;
                        });
                      },
                      items: AIStyleOption.values.map((style) {
                        return DropdownMenuItem<AIStyleOption>(
                          value: style,
                          child: Text(style.toString().split('.')[1]),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade400),
                          ),
                          fillColor: Colors.grey.shade200,
                          filled: true,
                          hintStyle: TextStyle(color: Colors.grey[500])),
                      isDense: true, // Makes the dropdown compact
                    ),
                  ),
                  const SizedBox(height: 8), // Added small spacing
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: DropdownButtonFormField<ResolutionOption>(
                      value: selectedResolution,
                      onChanged: (newValue) {
                        setState(() {
                          selectedResolution = newValue!;
                        });
                      },
                      items: ResolutionOption.values.map((resolution) {
                        return DropdownMenuItem<ResolutionOption>(
                          value: resolution,
                          child: Text(resolution.toString().split('.')[1]),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade400),
                          ),
                          fillColor: Colors.grey.shade200,
                          filled: true,
                          hintStyle: TextStyle(color: Colors.grey[500])),
                      isDense: true, // Makes the dropdown compact
                    ),
                  ),
                  const SizedBox(height: 8), // Added small spacing
                  MyTextField(
                    controller: textEditingController,
                    hintText: "Metin Girin...",
                    obscureText: false,
                  ),
                  const SizedBox(height: 16),
                  CustomButton(
                    buttonTetxt: "OLUŞTUR",
                    onPressed: () async {
                      await generate(
                        textEditingController.text,
                        selectedStyle,
                        Resolution.values[selectedResolution.index],
                      );
                    },
                  ),
                  if (generatedImage != null) ...[
                    const SizedBox(height: 8), // Added small spacing
                    CustomButton(
                      buttonTetxt: "GALERİYE KAYDET",
                      onPressed: () async {
                        await saveImageToDevice(generatedImage!);
                      },
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
