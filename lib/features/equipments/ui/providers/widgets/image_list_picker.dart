import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';

import '../../../../../network/api_constants.dart';
import '../repository_provider.dart';

class ImageListPicker extends StatefulWidget {
  const ImageListPicker({super.key});

  @override
  State<ImageListPicker> createState() => _ImageListPickerState();
}

class _ImageListPickerState extends State<ImageListPicker> {
  @override
  Widget build(BuildContext context) {
    final equipmentProvider = Provider.of<EquipmentProvider>(context);
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: equipmentProvider.imageList.length + 1,
        itemBuilder: (context, index) {
          if (index == equipmentProvider.imageList.length) {
            return GestureDetector(
              onTap: () async {
                var res = await equipmentProvider.pickEquipmentImage(FileType.image);
                if (res != null) {
                  print(res);
                  equipmentProvider.imageList.add(res);
                  print(equipmentProvider.imageList);
                  setState(() {});
                }
              },
              child: Container(
                width: 100,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!, width: 1.5),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_photo_alternate_rounded,
                        color: Colors.grey, size: 30),
                    SizedBox(height: 4),
                    Text("Qo'shish",
                        style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ),
            );
          }
          return _buildImageCard(
              ApiConstants.baseUrl + equipmentProvider.imageList[index],
              onTapRemove: () {
            equipmentProvider.imageList.removeAt(index);
            setState(() {

            });
          });
        },
      ),
    );
  }

  Widget _buildImageCard(String img, {GestureTapCallback? onTapRemove}) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 10),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              img,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          // O'chirish tugmasi
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: onTapRemove,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildAddButton() {
  //   return;
  // }
}
