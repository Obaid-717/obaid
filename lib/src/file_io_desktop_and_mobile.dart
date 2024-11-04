import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart'; // Import for file saving

// Check platform-specific conditions
bool get isMacOS => Platform.isMacOS;
bool get isWindows => Platform.isWindows;

/// Loads the font data from ByteData into the font loader
Future<void> loadFont(String family, ByteData? byteData) async {
  if (byteData == null) return;

  final fontLoader = FontLoader(family);
  fontLoader.addFont(Future.value(byteData));
  await fontLoader.load();
}

/// Loads the font from the device's file system if it exists
Future<ByteData?> loadFontFromDeviceFileSystem(String familyWithVariant) async {
  final directory = await getApplicationDocumentsDirectory();
  final path =
      '${directory.path}/fonts/$familyWithVariant.otf'; // Adjust path as necessary

  // Check if the file exists
  final file = File(path);
  if (await file.exists()) {
    final bytes = await file.readAsBytes();
    return ByteData.view(Uint8List.fromList(bytes).buffer);
  }
  return null;
}

/// Saves the font to the device's file system for future loads
Future<void> saveFontToDeviceFileSystem(
    String fontName, Uint8List bytes) async {
  final directory = await getApplicationDocumentsDirectory();
  final path = '${directory.path}/fonts/$fontName.otf';
  final file = File(path);

  // Write the bytes to the file
  await file.create(recursive: true);
  await file.writeAsBytes(bytes);
}

/// Finds the asset path for the given font descriptor
/// You may need to adjust this logic based on the google_fonts version you're using
Future<String?> findFontAssetPath(dynamic descriptor) async {
  final String assetPath =
      'assets/fonts/${descriptor.familyWithVariant.toApiFilenamePrefix()}.otf';

  try {
    await rootBundle.load(assetPath);
    return assetPath;
  } catch (e) {
    return null;
  }
}
