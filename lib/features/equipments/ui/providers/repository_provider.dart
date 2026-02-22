import 'dart:typed_data';
import 'package:admin/network/base_repository.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../../../../core/loading/global_loader_widget.dart';
import '../../../../core/notification/notification_service.dart';
import '../../../../core/notification/top_notification.dart';
import '../../../../network/model_response.dart';
import '../../data/api_service.dart';
import '../../domain/models/brand_model.dart';
import '../../domain/models/category_model.dart';
import '../../domain/models/equipment_model.dart';

class EquipmentProvider extends ChangeNotifier with BaseRepository {
  void init() {
    try {
      getAllEquipments();
      getAllBrands();
    } catch (r) {}
  }

  final ApiService api;
  final GlobalLoadingProvider loader;
  final NotificationProvider notify;
  String? imagePath;
  EquipmentProvider({
    required this.api,
    required this.loader,
    required this.notify,
  });

  List<EquipmentModel> equipments = [];
  List<BrandModel> brands = [];
  List<CategoryModel> category = [];
  BrandModel? selectedBrand;
  CategoryModel? selectedCategory;
  Future<void> getAllEquipments(
      {int? brandId,
      int? categoryId,
      String? search,
      int? page = 1,
      int? pageSize = 20}) async {
    loader.setLoading(true);
    final response = await safeApiCall<List<EquipmentModel>>(
        () => api.getEquipments(
            brandId: brandId,
            categoryId: categoryId,
            search: search,
            page: page,
            pageSize: pageSize), (json) {
      final items =
          (json as List).map((i) => EquipmentModel.fromJson(i)).toList();
      return items;
    });
    if (response is Success) {
      equipments = (response as Success).value.data!;
    } else {
      notify.show("Server xatosi: ${response}", type: NotificationType.error);
    }

    loader.setLoading(false);
    notifyListeners();
  }

  Future<void> getAllBrands() async {
    loader.setLoading(true);
    final response =
        await safeApiCall<List<BrandModel>>(() => api.getBrand(), (json) {
      final items = (json as List).map((i) => BrandModel.fromJson(i)).toList();
      return items;
    });
    if (response is Success) {
      brands = (response as Success).value.data!;
    } else {
      notify.show("Server xatosi: ${response}", type: NotificationType.error);
    }

    loader.setLoading(false);
    notifyListeners();
  }

  Future<void> getCategories(int id) async {
    loader.setLoading(true);
    final response = await safeApiCall<List<CategoryModel>>(
        () => api.getByBrandIdCategories(id), (json) {
      final items =
          (json as List).map((i) => CategoryModel.fromJson(i)).toList();
      return items;
    });
    if (response is Success) {
      category = (response as Success).value.data!;
    } else {
      notify.show("Server xatosi: ${response}", type: NotificationType.error);
    }
    loader.setLoading(false);
    notifyListeners();
  }

  Uint8List? pickedFileBytes;
  String? pickedFileName;
  Future<bool> addBrand(String brandName, String description,
      [String? imagePath = null]) async {
    try {
      loader.setLoading(true);
      final response = await safeApiCall(
          () => api.createBrand(brandName, description, imagePath),
              (data) => data.toString());
      if (response is Success) {
        notify.show("Muvaffaqiyatli yuklandi!", type: NotificationType.success,duration: Duration(seconds: 1));
        imagePath = (response as Success).value.data!;
        loader.setLoading(false);
        return true;
      } else {

        notify.show("Server rad etdi: ${response}",
            type: NotificationType.error,duration: Duration(seconds: 1));
        loader.setLoading(false);
        return false;
      }
    } catch (e) {
      notify.show("Xatolik yuz berdi: ${e}",
          type: NotificationType.error,duration: Duration(seconds: 1));
      loader.setLoading(false);
      return false;
    }
  }

  Future<void> pickEquipmentImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );

    if (result != null) {
      PlatformFile file = result.files.first;
      pickedFileBytes = file.bytes; // Web-da fayl mana shu bytes ichida bo'ladi
      pickedFileName = file.name;
      notifyListeners(); // UI-ni yangilash
      uploadEquipmentImage(pickedFileBytes!, pickedFileName!);
    } else {

    }
  }

  Future<void> uploadEquipmentImage(
      Uint8List fileBytes, String fileName) async {
    loader.setLoading(true);
    try {
      final multipartFile = http.MultipartFile.fromBytes(
        'file', // Swagger-dagi nom bilan bir xil bo'lishi shart!
        fileBytes,
        filename: fileName,
      );

      final response = await safeApiCall<String>(
          () => api.uploadFile(multipartFile), (data) => data.toString());

      if (response is Success) {
        notify.show("Muvaffaqiyatli yuklandi!", type: NotificationType.success);
        imagePath = (response as Success).value.data!;
      } else {
        // 400 xato bo'lsa, serverdan kelgan xabarni ko'ramiz
        notify.show("Server rad etdi: ${response}",
            type: NotificationType.error);
      }
    } catch (e) {
      // "Failed to fetch" xatosi shu yerda ushlanadi
      notify.show("Aloqa xatosi: CORS yoki Tarmoq muammosi",
          type: NotificationType.error);
    } finally {
      loader.setLoading(false);
    }
  }
}
