import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import '../../features/customers/provider/file_uploader_notifier.dart';

class FileUploader extends StatefulWidget {
  const FileUploader({super.key, required this.uploader,  this.type = FileType.image,  this.icon,  this.label});
  final Function(String filePath) uploader;
  final FileType type;
  final Widget? icon;
  final String? label;

  @override
  State<FileUploader> createState() => _FileUploaderState();
}
class _FileUploaderState extends State<FileUploader> {
  @override
  Widget build(BuildContext context) {
    final equipmentProvider =
        Provider.of<FileUploaderNotifier>(context, listen: false);
    final bool isLoading = equipmentProvider.isLoading;
    return InkWell(
      onTap: isLoading
          ? null
          : () async {
              var file =await equipmentProvider.pickEquipmentImage(widget.type);
              if (file != null && file.bytes != null) {
                setState(() {
                  equipmentProvider.isLoading = true;
                });
                var filePath = await equipmentProvider.uploadEquipmentImage(
                    file.bytes!, file.name);
                if (filePath != null) {
                  await Future.delayed(const Duration(seconds: 2));
                  widget.uploader.call(filePath);
                }
                setState(() {
                  equipmentProvider.isLoading = false;
                });
              }
            },
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 90,
        height: 90,
        decoration: BoxDecoration(
          color: isLoading ? Colors.blue.withOpacity(0.05) :
          Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isLoading ? Colors.blue : Colors.grey[300]!,
            width: 1.5,
            style: BorderStyle.solid,
          ),
          boxShadow: [
            if (!isLoading)
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: isLoading
              ? _buildLoadingState()
              : _buildUploadState(),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Column(
      key: const ValueKey(1),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          "Yuklanmoqda",
          style: TextStyle(
            color: Colors.blue[700],
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildUploadState() {
    return Column(
      key: const ValueKey(2),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
      widget.icon??
        const Icon(
          Icons.cloud_upload_outlined,
          color: Colors.green,
          size: 50,
        ),
        const SizedBox(height: 8),
        Text(widget.label??"Fayl yuklash",
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
