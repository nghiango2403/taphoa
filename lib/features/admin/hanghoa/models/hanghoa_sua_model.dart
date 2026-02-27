// To parse this JSON data, do
//
//     final hangHoaSuaModel = hangHoaSuaModelFromJson(jsonString);

import 'dart:convert';

HangHoaSuaModel hangHoaSuaModelFromJson(String str) => HangHoaSuaModel.fromJson(json.decode(str));

String hangHoaSuaModelToJson(HangHoaSuaModel data) => json.encode(data.toJson());

class HangHoaSuaModel {
  int status;
  String message;

  HangHoaSuaModel({
    required this.status,
    required this.message,
  });

  factory HangHoaSuaModel.fromJson(Map<String, dynamic> json) => HangHoaSuaModel(
    status: json["status"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
  };
}
