import 'dart:typed_data';

import 'package:admin/network/base_repository.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http show MultipartFile;

import '../../../network/model_response.dart';
import '../../equipments/data/api_service.dart';

class FileUploaderNotifier  extends ChangeNotifier with BaseRepository{
  final ApiService api;

  bool isLoading=false;
  FileUploaderNotifier({required this.api});
  Future<PlatformFile?> pickEquipmentImage(FileType type) async {
    Uint8List? pickedFileBytes;
    String? pickedFileName;
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: type,
      withData: true,
    );
    if (result != null) {
      PlatformFile file = result.files.first;
      pickedFileBytes = file.bytes;
      pickedFileName = file.name;
      return file;
    }
    return null;
  }

  Future<String?> uploadEquipmentImage(Uint8List fileBytes, String fileName) async {
    try {
      final multipartFile = http.MultipartFile.fromBytes(
        'file',
        fileBytes,
        filename: fileName,
      );
      final response = await safeApiCall<String>(() => api.uploadFile(multipartFile), (data) => data.toString());
      if (response is Success) {
        return (response as Success).value.data!;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

}