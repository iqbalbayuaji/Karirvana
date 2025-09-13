import 'dart:io';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:developer' as developer;

class CloudinaryService {
  static CloudinaryService? _instance;
  static CloudinaryService get instance => _instance ??= CloudinaryService._();
  
  CloudinaryService._();
  
  late CloudinaryPublic _cloudinary;
  
  void initialize() {
    final cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME'];
    final uploadPreset = dotenv.env['CLOUDINARY_UPLOAD_PRESET'];
    
    if (cloudName == null || uploadPreset == null) {
      throw Exception('Cloudinary configuration not found in .env file');
    }
    
    _cloudinary = CloudinaryPublic(cloudName, uploadPreset, cache: false);
  }
  
  Future<String?> uploadImage(File imageFile, {String? publicId}) async {
    try {
      final response = await _cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          imageFile.path,
          publicId: publicId,
          folder: 'karirvana/profile_pictures',
        ),
      );
      
      return response.secureUrl;
    } catch (e) {
      developer.log('Error uploading image to Cloudinary: $e', name: 'CloudinaryService');
      return null;
    }
  }
  
  // Note: cloudinary_public package doesn't support image deletion
  // Image deletion should be handled on the server-side for security reasons
  // For now, we'll just remove the reference from Firestore
  Future<bool> deleteImage(String publicId) async {
    developer.log('Image deletion not supported in client-side. Remove reference from database instead.', name: 'CloudinaryService');
    // In a production app, you would call your backend API to delete the image
    // For now, just return true to indicate the reference should be removed
    return true;
  }
  
  String getOptimizedUrl(String originalUrl, {
    int? width,
    int? height,
    String quality = 'auto',
    String format = 'auto',
  }) {
    if (!originalUrl.contains('cloudinary.com')) {
      return originalUrl;
    }
    
    final transformations = <String>[];
    
    if (width != null) transformations.add('w_$width');
    if (height != null) transformations.add('h_$height');
    transformations.add('q_$quality');
    transformations.add('f_$format');
    transformations.add('c_fill');
    
    final transformation = transformations.join(',');
    
    return originalUrl.replaceFirst(
      '/upload/',
      '/upload/$transformation/',
    );
  }
}
