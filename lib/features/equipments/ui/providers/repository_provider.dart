// 1. Service provider (Chopper service)
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../network/api_client.dart';
import '../../data/equipment_repository.dart';
import '../../data/equipment_service.dart';

final equipmentServiceProvider = Provider<EquipmentService>((ref) {
  final client = ref.watch(apiClientProvider); // Avvalgi ChopperClient
  return client.getService<EquipmentService>();
});

final equipmentRepositoryProvider = Provider<EquipmentRepository>((ref) {
  final service = ref.watch(equipmentServiceProvider);
  return EquipmentRepository(service);
});
