import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ImagePickerService {
  final ImagePicker _picker = ImagePicker();

  Future<File?> pickImageFromCamera() async {
    try {
      // Request camera permission
      final cameraStatus = await Permission.camera.request();

      if (cameraStatus.isDenied) {
        throw Exception('Camera permission denied');
      }

      if (cameraStatus.isPermanentlyDenied) {
        await openAppSettings();
        throw Exception('Camera permission permanently denied. Please enable from settings.');
      }

      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image == null) return null;

      return File(image.path);
    } catch (e) {
      rethrow;
    }
  }

  Future<File?> pickImageFromGallery() async {
    try {
      // Request photo permission
      PermissionStatus status;

      if (Platform.isIOS) {
        status = await Permission.photos.request();
      } else {
        status = await Permission.storage.request();
      }

      if (status.isDenied) {
        throw Exception('Gallery permission denied');
      }

      if (status.isPermanentlyDenied) {
        await openAppSettings();
        throw Exception('Gallery permission permanently denied. Please enable from settings.');
      }

      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image == null) return null;

      return File(image.path);
    } catch (e) {
      rethrow;
    }
  }

  Future<File?> pickImageFromFiles() async {
    try {
      // Request storage permission
      final status = await Permission.storage.request();

      if (status.isDenied) {
        throw Exception('Storage permission denied');
      }

      if (status.isPermanentlyDenied) {
        await openAppSettings();
        throw Exception('Storage permission permanently denied. Please enable from settings.');
      }

      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image == null) return null;

      return File(image.path);
    } catch (e) {
      rethrow;
    }
  }
}