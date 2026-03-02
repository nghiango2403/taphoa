import 'dart:convert';

NhanVienLayChiTietModel nhanVienLayChiTietModelFromJson(String str) =>
    NhanVienLayChiTietModel.fromJson(json.decode(str));

String nhanVienLayChiTietModelToJson(NhanVienLayChiTietModel data) =>
    json.encode(data.toJson());

class NhanVienLayChiTietModel {
  int status;
  String message;
  Data data;

  NhanVienLayChiTietModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory NhanVienLayChiTietModel.fromJson(Map<String, dynamic> json) =>
      NhanVienLayChiTietModel(
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
  String id;
  String tenDangNhap;
  MaNhanSu maNhanSu;
  MaChucVu maChucVu;
  bool kichHoat;

  Data({
    required this.id,
    required this.tenDangNhap,
    required this.maNhanSu,
    required this.maChucVu,
    required this.kichHoat,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["_id"],
    tenDangNhap: json["TenDangNhap"],
    maNhanSu: MaNhanSu.fromJson(json["MaNhanSu"]),
    maChucVu: MaChucVu.fromJson(json["MaChucVu"]),
    kichHoat: json["KichHoat"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "TenDangNhap": tenDangNhap,
    "MaNhanSu": maNhanSu.toJson(),
    "MaChucVu": maChucVu.toJson(),
    "KichHoat": kichHoat,
  };
}

class MaChucVu {
  String id;
  String tenChucVu;
  int v;

  MaChucVu({required this.id, required this.tenChucVu, required this.v});

  factory MaChucVu.fromJson(Map<String, dynamic> json) =>
      MaChucVu(id: json["_id"], tenChucVu: json["TenChucVu"], v: json["__v"]);

  Map<String, dynamic> toJson() => {
    "_id": id,
    "TenChucVu": tenChucVu,
    "__v": v,
  };
}

class MaNhanSu {
  String id;
  String hoTen;
  String sdt;
  String email;
  DateTime ngaySinh;
  String diaChi;
  String gioiTinh;
  int v;

  MaNhanSu({
    required this.id,
    required this.hoTen,
    required this.sdt,
    required this.email,
    required this.ngaySinh,
    required this.diaChi,
    required this.gioiTinh,
    required this.v,
  });

  factory MaNhanSu.fromJson(Map<String, dynamic> json) => MaNhanSu(
    id: json["_id"],
    hoTen: json["HoTen"],
    sdt: json["SDT"],
    email: json["Email"],
    ngaySinh: DateTime.parse(json["NgaySinh"]),
    diaChi: json["DiaChi"],
    gioiTinh: json["GioiTinh"],
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "HoTen": hoTen,
    "SDT": sdt,
    "Email": email,
    "NgaySinh": ngaySinh.toIso8601String(),
    "DiaChi": diaChi,
    "GioiTinh": gioiTinh,
    "__v": v,
  };
}
