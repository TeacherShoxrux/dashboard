import 'package:admin/core/notification/top_notification.dart';
import 'package:admin/network/base_repository.dart';
import 'package:flutter/widgets.dart';

import '../../../core/loading/global_loader_widget.dart';
import '../../../core/notification/notification_service.dart';
import '../../equipments/data/api_service.dart';
import '../../equipments/domain/models/equipment_model.dart';

class RentNotifierProvider extends ChangeNotifier with BaseRepository{
  void init() {
    try {
    } catch (r) {}
  }
  final ApiService api;
  final GlobalLoadingProvider loader;
  final NotificationProvider notify;
  RentNotifierProvider({required this.api, required this.loader, required this.notify});


  final List<EquipmentModel> _equipmentSelectedList = [];
  DateTime? startDate;
  DateTime? endDate;
  int totalDays=0;

  double get pricePerDay =>equipmentSelectedList.isEmpty?0:equipmentSelectedList.map((e) => e.pricePerDay*e.quantity).reduce((value, element) => value + element);
  double get totalPrice =>pricePerDay*totalDays;
  update(){
    notifyListeners();
  }

  List<EquipmentModel> get equipmentSelectedList => _equipmentSelectedList;
  void addEquipment(EquipmentModel equipment){
   if(_equipmentSelectedList.where((e)=>e.id == equipment.id).isEmpty){
     _equipmentSelectedList.add(equipment..quantity=1);
     notifyListeners();
     notify.show("Qo'shildi",type: NotificationType.success);
     return;
   }
   notify.show("Allaqachon qo'shilgan",type: NotificationType.info);
  }
  void removeEquipment(EquipmentModel equipment) {
    var result=_equipmentSelectedList.where((e)=>e.id == equipment.id);
    if(result.isNotEmpty){
      _equipmentSelectedList.remove(result.first);
      notifyListeners();
      notify.show("O'chilrildi",type: NotificationType.success);
      return;
    }
    notify.show("Topilmadi",type: NotificationType.info);
  }


}