import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:taphoa/features/admin/thongke/logic/thongke_logic.dart';

class ThongKe extends StatefulWidget {
  const ThongKe({super.key});

  @override
  State<ThongKe> createState() => _ThongKeState();
}

class _ThongKeState extends State<ThongKe> {
  final f = NumberFormat("#,###", "vi_VN");

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

  @override
  void initState() {
    super.initState();
    // Load dữ liệu mặc định khi vào trang
    WidgetsBinding.instance.addPostFrameCallback((_) => _handleFilter());
  }

  void _handleFilter() {
    final logic = context.read<ThongKeLogic>();
    if (_selectedType == 'Thống kê doanh thu') {
      String start = DateFormat('yyyy-MM-dd').format(_startDate);
      String end = DateFormat('yyyy-MM-dd').format(_endDate);
      logic.fetchThongKeDoanhThu(start, end);
    } else if (_selectedType == 'Thống kê nhập hàng') {
      logic.fetchThongKeNhapHang(_selectedMonth, _selectedYear);
    } else if (_selectedType == 'Thống kê bán hàng') {
      logic.fetchThongKeBanHang(_selectedMonth, _selectedYear);
    } else if (_selectedType == 'Thống kê tồn kho') {
      logic.fetchThongKeTonKho(_selectedMonth, _selectedYear);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        title: const Text(
          "Báo cáo & Thống kê",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: Column(
        children: [
          _buildFilterSection(),
          Expanded(
            child: Consumer<ThongKeLogic>(
              builder: (context, logic, child) {
                if (logic.isLoading)
                  return const Center(child: CircularProgressIndicator());
                if (logic.errorMessage != null)
                  return Center(
                    child: Text(
                      logic.errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  );

                return _buildMainContent(logic);
              },
            ),
          ),
        ],
      ),
    );
  }

  // --- Filter Section ---
  Widget _buildFilterSection() {
    bool isDoanhThu = _selectedType == 'Thống kê doanh thu';
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        children: [
          DropdownButtonFormField<String>(
            value: _selectedType,
            decoration: InputDecoration(
              labelText: "Loại báo cáo",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
            ),
            items: _types
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (val) => setState(() => _selectedType = val!),
          ),
          const SizedBox(height: 12),
          isDoanhThu ? _buildDoanhThuFilter() : _buildMonthYearFilter(),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 45,
            child: ElevatedButton(
              onPressed: _handleFilter,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "XEM BÁO CÁO",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Content Switcher ---
  Widget _buildMainContent(ThongKeLogic logic) {
    if (_selectedType == 'Thống kê nhập hàng')
      return _buildListView(logic.listNhapHang, _buildNhapHangItem);
    if (_selectedType == 'Thống kê bán hàng')
      return _buildListView(logic.listBanHang, _buildBanHangItem);
    if (_selectedType == 'Thống kê tồn kho')
      return _buildListView(logic.listTonKho, _buildTonKhoItem);
    return _buildListView(logic.listDoanhThu, _buildDoanhThuItem);
  }

  Widget _buildListView(List data, Widget Function(dynamic) itemBuilder) {
    if (data.isEmpty)
      return const Center(child: Text("Không có dữ liệu hiển thị"));
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: data.length,
      itemBuilder: (context, index) => itemBuilder(data[index]),
    );
  }

  // --- Item Renderers ---

  Widget _buildNhapHangItem(dynamic item) => _cardWrapper(
    child: Column(
      children: [
        _rowInfo("Hàng hóa", item.tenHangHoa, isBold: true),
        const Divider(),
        _rowInfo("Số lượng nhập", "${item.tongSoLuong}"),
        _rowInfo(
          "Tổng vốn chi",
          "${f.format(item.tongTien)}đ",
          color: Colors.red,
        ),
      ],
    ),
  );

  Widget _buildBanHangItem(dynamic item) => _cardWrapper(
    child: Column(
      children: [
        _rowInfo("Sản phẩm", item.tenHangHoa, isBold: true),
        const Divider(),
        _rowInfo("Số lượng bán", "${item.tongSoLuong}"),
        _rowInfo(
          "Doanh thu",
          "${f.format(item.tongTien)}đ",
          color: Colors.green,
        ),
      ],
    ),
  );

  Widget _buildTonKhoItem(dynamic item) => _cardWrapper(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.ten,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                "Giá niêm yết: ${f.format(item.gia)}đ",
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: item.soLuong == 0 ? Colors.red.shade50 : Colors.blue.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            "${item.soLuong}",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: item.soLuong == 0 ? Colors.red : Colors.blue,
            ),
          ),
        ),
      ],
    ),
  );

  Widget _buildDoanhThuItem(dynamic item) {
    int loiNhuan = item.tongDoanhThu - item.tongTienHang;
    return _cardWrapper(
      color: Colors.indigo.shade50,
      child: Column(
        children: [
          Text(
            "Ngày ${DateFormat('dd/MM/yyyy').format(item.id)}",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.indigo,
            ),
          ),
          const Divider(),
          _rowInfo("Doanh thu", "${f.format(item.tongDoanhThu)}đ"),
          _rowInfo("Tiền vốn", "${f.format(item.tongTienHang)}đ"),
          _rowInfo(
            "Khuyến mãi",
            "-${f.format(item.tongTienKhuyenMai)}đ",
            color: Colors.orange,
          ),
          const Divider(),
          _rowInfo(
            "LỢI NHUẬN",
            "${f.format(loiNhuan)}đ",
            color: Colors.green,
            isBold: true,
          ),
        ],
      ),
    );
  }

  // --- Helper Widgets ---
  Widget _cardWrapper({required Widget child, Color? color}) => Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: color ?? Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
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
        Text(
          label,
          style: const TextStyle(color: Colors.black54, fontSize: 13),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: color,
            fontSize: 14,
          ),
        ),
      ],
    ),
  );

  Widget _buildMonthYearFilter() {
    return Row(
      children: [
        Expanded(
          child: _buildDropdownWrapper(
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
          child: _buildDropdownWrapper(
            "Năm",
            DropdownButton<int>(
              value: _selectedYear,
              isExpanded: true,
              underline: const SizedBox(),
              items: List.generate(
                3,
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
            (d) => setState(() => _startDate = d),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildDateTile(
            "Đến ngày",
            _endDate,
            (d) => setState(() => _endDate = d),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownWrapper(String label, Widget child) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      Container(
        margin: const EdgeInsets.only(top: 4),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: child,
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
          margin: const EdgeInsets.only(top: 4),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat('dd/MM/yyyy').format(date),
                style: const TextStyle(fontSize: 13),
              ),
              const Icon(Icons.calendar_today, size: 14, color: Colors.indigo),
            ],
          ),
        ),
      ],
    ),
  );
}
