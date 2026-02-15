// lib/features/equipment/presentation/providers/equipment_notifier.dart

import 'dart:async';

import 'package:admin/features/equipments/domain/models/equipment_model.dart';
import 'package:admin/features/equipments/ui/providers/repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../network/model_response.dart';
import '../../../../network/response_base.dart';

class EquipmentNotifier extends AsyncNotifier<BaseResponse<List<EquipmentModel>>> {
  @override
  FutureOr<BaseResponse<List<EquipmentModel>>> build() async {
    final repository = ref.read(equipmentRepositoryProvider);
    final result = await repository.getEquipments();
    return switch (result) {
      Success(value: final data) => data,
      Error(exception: final e) => throw e,
    };
  }
}