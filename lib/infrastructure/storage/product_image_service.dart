import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductImageService {
  ProductImageService({ImagePicker? picker})
    : _picker = picker ?? ImagePicker();

  final ImagePicker _picker;

  Future<XFile?> chooseFromCamera() => _picker.pickImage(
    source: ImageSource.camera,
    maxWidth: 1600,
    imageQuality: 85,
  );

  Future<XFile?> chooseFromGallery() => _picker.pickImage(
    source: ImageSource.gallery,
    maxWidth: 1600,
    imageQuality: 85,
  );

  Future<String> upload({
    required SupabaseClient client,
    required String householdId,
    required String productId,
    required String objectName,
    required Uint8List bytes,
    required String contentType,
  }) {
    final path = '$householdId/products/$productId/$objectName';
    return client.storage
        .from('product-images')
        .uploadBinary(
          path,
          bytes,
          fileOptions: FileOptions(contentType: contentType, upsert: true),
        )
        .then((_) => path);
  }

  Future<void> remove({required SupabaseClient client, required String path}) {
    return client.storage.from('product-images').remove([path]).then((_) {});
  }
}
