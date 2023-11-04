import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:my_schedule/utils/common/uuid.dart';

Future<String> getS3UrlPublic(String key) async {
  try {
    final result = await Amplify.Storage.getUrl(
            key: key,
            options: const StorageGetUrlOptions(
                accessLevel: StorageAccessLevel.guest))
        .result;
    return result.url.toString();
  } on StorageException catch (e) {
    safePrint('Could not get s3 url: ${e.message}');
    rethrow;
  }
}

Future<String> uploadImage(String typeName) async {
  // Select a file from the device
  final result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    withData: false,
    // Ensure to get file stream for better performance
    withReadStream: true,
    allowedExtensions: ['jpg', 'png', 'gif'],
  );

  if (result == null) {
    safePrint('No file selected');
    return '';
  }

  // Upload file with its filename as the key
  final platformFile = result.files.single;
  try {
    final key = '${typeName}_${platformFile.name}_${getUUid()}';
    final result = await Amplify.Storage.uploadFile(
      localFile: AWSFile.fromStream(
        platformFile.readStream!,
        size: platformFile.size,
      ),
      key: key,
      onProgress: (progress) {
        safePrint('Fraction completed: ${progress.fractionCompleted}');
      },
    ).result;
    return key;
  } on StorageException catch (e) {
    safePrint('Error uploading file: $e');
    EasyLoading.showError('背景更新失败', duration: const Duration(seconds: 2));
    rethrow;
  }
}

Future<void> removeFile({required String key}) async {
  try {
    final result = await Amplify.Storage.remove(
      key: key,
      options: const StorageRemoveOptions(
        accessLevel: StorageAccessLevel.guest,
      ),
    ).result;
    safePrint('Removed file: ${result.removedItem.key}');
  } on StorageException catch (e) {
    safePrint('Error deleting file: ${e.message}');
    rethrow;
  }
}
