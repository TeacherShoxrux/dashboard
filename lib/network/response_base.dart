// lib/core/api/api_response_wrapper.dart
class BaseResponse<T> {
  final bool isSuccess;
  final T? data;
  final String message;
  final int statusCode;

  // Pagination maydonlarini ixtiyoriy (optional) qilamiz
  final int? pageNumber;
  final int? pageSize;
  final int? totalPages;
  final int? totalRecords;

  BaseResponse({
    required this.isSuccess,
    this.data,
    required this.message,
    required this.statusCode,
    this.pageNumber,
    this.pageSize,
    this.totalPages,
    this.totalRecords,
  });

  factory BaseResponse.fromJson(Map<String, dynamic> json, T Function(dynamic) fromJsonT) {
    return BaseResponse(
      isSuccess: json['isSuccess'] ?? false,
      data: json['data'] != null ? fromJsonT(json['data']) : null,
      message: json['message'] ?? "",
      statusCode: json['statusCode'] ?? 0,
      // Agar kelsa o'qiydi, kelmasa null bo'ladi
      pageNumber: json['pageNumber'],
      pageSize: json['pageSize'],
      totalPages: json['totalPages'],
      totalRecords: json['totalRecords'],
    );
  }
}