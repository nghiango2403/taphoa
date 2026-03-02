import 'dart:convert';

KhuyenMaiSuaModel khuyenMaiSuaModelFromJson(String str) => KhuyenMaiSuaModel.fromJson(json.decode(str));

String khuyenMaiSuaModelToJson(KhuyenMaiSuaModel data) => json.encode(data.toJson());

class KhuyenMaiSuaModel {
  int status;
  String message;

  KhuyenMaiSuaModel({
    required this.status,
    required this.message,
  });

  factory KhuyenMaiSuaModel.fromJson(Map<String, dynamic> json) => KhuyenMaiSuaModel(
    status: json["status"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
  };
}
