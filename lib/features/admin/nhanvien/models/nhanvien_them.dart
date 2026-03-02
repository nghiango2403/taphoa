import 'dart:convert';

NhanVienThemModel nhanVienThemModelFromJson(String str) => NhanVienThemModel.fromJson(json.decode(str));

String nhanVienThemModelToJson(NhanVienThemModel data) => json.encode(data.toJson());

class NhanVienThemModel {
  int status;
  String message;
  Data data;

  NhanVienThemModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory NhanVienThemModel.fromJson(Map<String, dynamic> json) => NhanVienThemModel(
    status: json["status"],
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data.toJson(),
  };
}

class Data {
  Taikhoan taikhoan;

  Data({
    required this.taikhoan,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    taikhoan: Taikhoan.fromJson(json["taikhoan"]),
  );

  Map<String, dynamic> toJson() => {
    "taikhoan": taikhoan.toJson(),
  };
}

class Taikhoan {
  String tenDangNhap;
  String matKhau;
  String maNhanSu;
  String maChucVu;
  bool kichHoat;
  String id;
  int v;

  Taikhoan({
    required this.tenDangNhap,
    required this.matKhau,
    required this.maNhanSu,
    required this.maChucVu,
    required this.kichHoat,
    required this.id,
    required this.v,
  });

  factory Taikhoan.fromJson(Map<String, dynamic> json) => Taikhoan(
    tenDangNhap: json["TenDangNhap"],
    matKhau: json["MatKhau"],
    maNhanSu: json["MaNhanSu"],
    maChucVu: json["MaChucVu"],
    kichHoat: json["KichHoat"],
    id: json["_id"],
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "TenDangNhap": tenDangNhap,
    "MatKhau": matKhau,
    "MaNhanSu": maNhanSu,
    "MaChucVu": maChucVu,
    "KichHoat": kichHoat,
    "_id": id,
    "__v": v,
  };
}
