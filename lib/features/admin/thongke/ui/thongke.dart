import 'package:flutter/material.dart';

class ThongKe extends StatefulWidget {
  const ThongKe({super.key});

  @override
  State<ThongKe> createState() => _ThongKeState();
}

class _ThongKeState extends State<ThongKe> {
  String _selectedType = 'Thống kê nhập hàng';
  final List<String> _types = [
    'Thống kê nhập hàng',
    'Thống kê bán hàng',
    'Thống kê tồn kho',
    'Thống kê doanh thu',
  ];

  int _selectedMonth = DateTime.now().month;
  int _selectedYear = DateTime.now().year;
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 7));
  DateTime _endDate = DateTime.now();

  final List<Map<String, dynamic>> _mockNhapHang = [
    {"ten": "Kem", "soLuong": 5, "tongTien": "100.000 đ", "ngay": "20/02/2026"},
    {
      "ten": "Phấn",
      "soLuong": 10,
      "tongTien": "180.000 đ",
      "ngay": "19/02/2026",
    },
  ];

  final List<Map<String, dynamic>> _mockBanHang = [
    {"ten": "Muối", "soLuong": 2, "doanhThu": "4.000 đ", "khach": "Khách lẻ"},
    {
      "ten": "Kẹo",
      "soLuong": 5,
      "doanhThu": "25.000 đ",
      "khach": "Nguyễn Văn A",
    },
  ];

  final List<Map<String, dynamic>> _mockTonKho = [
    {"ten": "Kẹo", "soLuong": 1003, "donVi": "Viên"},
    {"ten": "Áo Thun", "soLuong": 5, "donVi": "Cái"},
    {"ten": "Kem", "soLuong": 0, "donVi": "Que"},
  ];

  final List<Map<String, dynamic>> _mockDoanhThu = [
    {
      "ngay": "20/02/2026",
      "dt": "1.500.000 đ",
      "tienHang": "1.000.000 đ",
      "km": "50.000 đ",
      "loiNhuan": "450.000 đ",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        title: const Text(
          "Báo cáo & Thống kê",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: Column(
        children: [
          _buildFilterSection(),
          Expanded(child: _buildMainContent()),
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    bool isDoanhThu = _selectedType == 'Thống kê doanh thu';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        children: [
          DropdownButtonFormField<String>(
            value: _selectedType,
            decoration: InputDecoration(
              labelText: "Loại báo cáo",
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            items: _types
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (val) => setState(() => _selectedType = val!),
          ),
          const SizedBox(height: 16),

          isDoanhThu ? _buildDoanhThuFilter() : _buildMonthYearFilter(),

          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: () => _handleFilter(),
              icon: const Icon(Icons.analytics_outlined, color: Colors.white),
              label: const Text(
                "XEM BÁO CÁO",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigoAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthYearFilter() {
    return Row(
      children: [
        Expanded(
          child: _buildDropdownLabel(
            "Tháng",
            DropdownButton<int>(
              value: _selectedMonth,
              isExpanded: true,
              underline: const SizedBox(),
              items: List.generate(
                12,
                (i) => DropdownMenuItem(value: i + 1, child: Text("${i + 1}")),
              ),
              onChanged: (val) => setState(() => _selectedMonth = val!),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildDropdownLabel(
            "Năm",
            DropdownButton<int>(
              value: _selectedYear,
              isExpanded: true,
              underline: const SizedBox(),
              items: List.generate(
                5,
                (i) => DropdownMenuItem(
                  value: 2024 + i,
                  child: Text("${2024 + i}"),
                ),
              ),
              onChanged: (val) => setState(() => _selectedYear = val!),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDoanhThuFilter() {
    return Row(
      children: [
        Expanded(
          child: _buildDateTile(
            "Từ ngày",
            _startDate,
            (date) => setState(() => _startDate = date),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildDateTile(
            "Đến ngày",
            _endDate,
            (date) => setState(() => _endDate = date),
          ),
        ),
      ],
    );
  }

  Widget _buildMainContent() {
    if (_selectedType == 'Thống kê nhập hàng')
      return _buildList(_mockNhapHang, _buildNhapHangItem);
    if (_selectedType == 'Thống kê bán hàng')
      return _buildList(_mockBanHang, _buildBanHangItem);
    if (_selectedType == 'Thống kê tồn kho')
      return _buildList(_mockTonKho, _buildTonKhoItem);
    return _buildList(_mockDoanhThu, _buildDoanhThuItem);
  }

  Widget _buildList(List data, Widget Function(dynamic) itemBuilder) {
    if (data.isEmpty)
      return const Center(child: Text("Không có dữ liệu trong khoảng này"));
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: data.length,
      itemBuilder: (context, index) => itemBuilder(data[index]),
    );
  }

  Widget _buildNhapHangItem(dynamic item) => _cardWrapper(
    child: Column(
      children: [
        _rowInfo("Tên hàng hóa", item['ten'], isBold: true),
        const Divider(),
        _rowInfo("Số lượng", "${item['soLuong']}"),
        _rowInfo("Tổng tiền chi", item['tongTien'], color: Colors.red),
        _rowInfo("Ngày nhập", item['ngay']),
      ],
    ),
  );

  Widget _buildBanHangItem(dynamic item) => _cardWrapper(
    child: Column(
      children: [
        _rowInfo("Sản phẩm", item['ten'], isBold: true),
        const Divider(),
        _rowInfo("Số lượng", "${item['soLuong']}"),
        _rowInfo("Doanh thu", item['doanhThu'], color: Colors.green),
        _rowInfo("Khách hàng", item['khach']),
      ],
    ),
  );

  Widget _buildTonKhoItem(dynamic item) {
    int sl = item['soLuong'];
    return _cardWrapper(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item['ten'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                "Đơn vị: ${item['donVi']}",
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
          Text(
            "$sl",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: sl == 0
                  ? Colors.red
                  : (sl < 10 ? Colors.orange : Colors.blue),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoanhThuItem(dynamic item) => _cardWrapper(
    color: Colors.blue.shade50,
    child: Column(
      children: [
        Text(
          "Báo cáo ngày ${item['ngay']}",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        const Divider(),
        _rowInfo("Doanh thu", item['dt']),
        _rowInfo("Tiền vốn", item['tienHang']),
        _rowInfo("Khuyến mãi", "- ${item['km']}", color: Colors.orange),
        const Divider(),
        _rowInfo(
          "LỢI NHUẬN",
          item['loiNhuan'],
          color: Colors.green,
          isBold: true,
        ),
      ],
    ),
  );

  Widget _cardWrapper({required Widget child, Color? color}) => Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: color ?? Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
      ],
    ),
    child: child,
  );

  Widget _rowInfo(
    String label,
    String value, {
    bool isBold = false,
    Color? color,
  }) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.black54)),
        Text(
          value,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: color,
          ),
        ),
      ],
    ),
  );

  Widget _buildDropdownLabel(String label, Widget dropdown) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: dropdown,
      ),
    ],
  );

  Widget _buildDateTile(
    String label,
    DateTime date,
    Function(DateTime) onSelected,
  ) => InkWell(
    onTap: () async {
      DateTime? p = await showDatePicker(
        context: context,
        initialDate: date,
        firstDate: DateTime(2024),
        lastDate: DateTime(2027),
      );
      if (p != null) onSelected(p);
    },
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${date.day}/${date.month}/${date.year}",
                style: const TextStyle(fontSize: 13),
              ),
              const Icon(Icons.calendar_month, size: 16, color: Colors.blue),
            ],
          ),
        ),
      ],
    ),
  );

  void _handleFilter() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Đang tải dữ liệu lọc cho $_selectedType...")),
    );
  }
}
