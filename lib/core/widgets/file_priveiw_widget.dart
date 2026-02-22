import 'dart:ui';

import 'package:flutter/material.dart';

class FilePreviewCard extends StatelessWidget {
  final String? url;      // Serverdagi link
  final String? localPath; // Qurilmadagi yo'l
  final String fileName;
  final VoidCallback onRemove;

  const FilePreviewCard({
    super.key,
    this.url,
    this.localPath,
    required this.fileName,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final extension = fileName.split('.').last.toLowerCase();
    final isImage = ['jpg', 'jpeg', 'png', 'webp'].contains(extension);

    return Container(
      width: 110,
      height: 110,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))
        ],
      ),
      child: Stack(
        children: [
          // 1. ASOSIY KONTENT (Rasm yoki Fayl Ikonkasi)
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: isImage ? _buildImagePreview() : _buildFilePlaceholder(extension),
            ),
          ),

          // 2. O'CHIRISH TUGMASI (X)
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: onRemove,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                child: const Icon(Icons.close, size: 14, color: Colors.white),
              ),
            ),
          ),

          // 3. NOMINI KO'RSATISH (Fayllar uchun)
          if (!isImage)
            Positioned(
              bottom: 8,
              left: 4,
              right: 4,
              child: Text(
                fileName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
              ),
            ),
        ],
      ),
    );
  }
  Widget _buildImagePreview() {
    if (localPath != null) {
      return Image.network(localPath!, fit: BoxFit.cover);
    }
    return Image.network(
      url!,
      fit: BoxFit.cover,
      errorBuilder: (context, e, s) => _buildFilePlaceholder("Error"),
    );
  }
  IconData _getFileIcon(String extension) {
    switch (extension.toLowerCase()) {
      case 'pdf': return Icons.picture_as_pdf;
      case 'doc':
      case 'docx': return Icons.description;
      case 'xls':
      case 'xlsx': return Icons.table_chart;
      default: return Icons.insert_drive_file;
    }
  }

  Color _getFileColor(String extension) {
    switch (extension.toLowerCase()) {
      case 'pdf': return Colors.red.shade700;
      case 'doc':
      case 'docx': return Colors.blue.shade700;
      case 'xls':
      case 'xlsx': return Colors.green.shade700;
      default: return Colors.orange.shade700;
    }
  }
  // Fayl placeholder logikasi
  Widget _buildFilePlaceholder(String ext) {
    return Container(
      color: _getFileColor(ext).withOpacity(0.1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(_getFileIcon(ext), color: _getFileColor(ext), size: 36),
          const SizedBox(height: 4),
          Text(ext.toUpperCase(), style: TextStyle(color: _getFileColor(ext), fontWeight: FontWeight.bold, fontSize: 10)),
        ],
      ),
    );
  }
}