import 'dart:convert';

NhanVienSuaModel nhanVienSuaModelFromJson(String str) =>
    NhanVienSuaModel.fromJson(json.decode(str));

String nhanVienSuaModelToJson(NhanVienSuaModel data) =>
    json.encode(data.toJson());

class NhanVienSuaModel {
  int status;
  String message;

  NhanVienSuaModel({required this.status, required this.message});

  factory NhanVienSuaModel.fromJson(Map<String, dynamic> json) =>
      NhanVienSuaModel(status: json["status"], message: json["message"]);

  Map<String, dynamic> toJson() => {"status": status, "message": message};
}
