import 'package:admin/network/base_repository.dart';
import 'package:flutter/cupertino.dart';

import '../../../core/loading/global_loader_widget.dart';
import '../../../core/notification/notification_service.dart';
import '../../../core/notification/top_notification.dart';
import '../../../network/model_response.dart';
import '../../equipments/data/api_service.dart';
import '../models/customer_create_model.dart';
import '../models/customer_model.dart';

class CustomerNotifierProvider extends ChangeNotifier with BaseRepository {
  void init() {
    try {
      getAllCustomers();
    } catch (r) {}
  }

  final ApiService api;
  final GlobalLoadingProvider loader;
  final NotificationProvider notify;
  List<CustomerModel> customers = [];
  CustomerNotifierProvider(
      {required this.api, required this.loader, required this.notify});
  Future<void> getAllCustomers(
      {String? search, int page = 1, int size = 20}) async {
    loader.setLoading(true);
    final response = await safeApiCall<List<CustomerModel>>(
        () => api.getAllCustomers(search: search, page: page, size: size),
        (json) {
      final items =
          (json as List).map((i) => CustomerModel.fromJson(i)).toList();
      return items;
    });
    if (response.isSuccess) {
      customers = response.data!;
    } else {
      notify.show("Server xatosi: ${response}", type: NotificationType.error);
    }
    loader.setLoading(false);
    notifyListeners();
  }

  Future<bool?> addCustomer(CustomerCreateModel body) async {
    try {
      loader.setLoading(true);
      final response =
          await safeApiCall(() => api.createCustomer(body.toJson()), (json) =>json);
      if (response.isSuccess) {
        return true;
      } else {
        if(response is Error)
        notify.show("Xatolik yuzaga keldi: ${response.message}", type: NotificationType.error);
      }
    } catch (e) {
      loader.setLoading(false);
    }
    if(loader.isLoading)loader.setLoading(false);
    return Future.value(false);
  }
}
