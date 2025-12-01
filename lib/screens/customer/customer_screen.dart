// lib/screens/customer/customer_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:kasir/component/customer/customer_card.dart';
import 'package:kasir/component/customer/customer_form_sheet.dart';
import 'package:kasir/component/customer/empty_state.dart';
import 'package:kasir/component/customer/stat_card.dart';
import 'package:kasir/component/sidebar_drawer.dart';
import 'package:kasir/services/customer_service.dart';
import 'package:kasir/utils/constants.dart';

class CustomerManagementScreen extends StatefulWidget {
  const CustomerManagementScreen({super.key});

  @override
  State<CustomerManagementScreen> createState() => _CustomerManagementScreenState();
}

class _CustomerManagementScreenState extends State<CustomerManagementScreen>
    with SingleTickerProviderStateMixin {
  final _service = CustomerService();
  final _searchCtrl = TextEditingController();
  List<Map<String, dynamic>> _customers = [];
  bool _isLoading = true;
  bool _showOnlyWithPhone = false;
  String _sortMode = 'Terbaru';

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late final AnimationController _pulseCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1300),
    lowerBound: 0.0,
    upperBound: 0.06,
  )..repeat(reverse: true);

  @override
  void initState() {
    super.initState();
    _fetch();
    _searchCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  Future<void> _fetch() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      final data = await _service.fetchAll();
      if (!mounted) return;
      setState(() => _customers = data);
    } catch (e) {
      if (mounted) _showErrorToast('Gagal memuat data: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // NOTIFIKASI CANTIK
  void _showSuccessToast(String title, String message) {
    showToastWidget(
      Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.green.shade400, Colors.green.shade600]),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.green.withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 8))],
        ),
        child: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 16, color: Colors.white)),
                  Text(message, style: GoogleFonts.poppins(fontSize: 13, color: Colors.white70)),
                ],
              ),
            ),
          ],
        ),
      ),
      context: context,
      position: StyledToastPosition.top,
      animation: StyledToastAnimation.scale,
      duration: const Duration(seconds: 4),
    );
  }

  void _showEditToast(String name) {
    showToastWidget(
      Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [AppColors.azura, AppColors.azura.withOpacity(0.9)]),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: AppColors.azura.withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 8))],
        ),
        child: Row(
          children: [
            const Icon(Icons.edit_rounded, color: Colors.white, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Berhasil Diperbarui!', style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 16, color: Colors.white)),
                  Text('Data "$name" telah diupdate', style: GoogleFonts.poppins(fontSize: 13, color: Colors.white70)),
                ],
              ),
            ),
          ],
        ),
      ),
      context: context,
      position: StyledToastPosition.top,
      duration: const Duration(seconds: 3),
    );
  }

  void _showErrorToast(String message) {
    showToastWidget(
      Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        decoration: BoxDecoration(
          color: Colors.red.shade600,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.red.withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 8))],
        ),
        child: Row(
          children: [
            const Icon(Icons.error_rounded, color: Colors.white, size: 32),
            const SizedBox(width: 16),
            Expanded(child: Text(message, style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14))),
          ],
        ),
      ),
      context: context,
      position: StyledToastPosition.top,
      duration: const Duration(seconds: 5),
    );
  }

  void _showForm([Map<String, dynamic>? customer]) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CustomerFormSheet(
        customer: customer,
        onSave: (name, phone, address) async {
          try {
            if (customer == null) {
              await _service.add(name: name, phone: phone, address: address);
              _showSuccessToast('Pelanggan Ditambahkan', '"$name" berhasil disimpan');
            } else {
              await _service.update(id: customer['id_pelanggan'] as int, name: name, phone: phone, address: address);
              _showEditToast(name);
            }
            if (mounted) Navigator.pop(context);
            await _fetch();
          } catch (e) {
            _showErrorToast('Gagal menyimpan: $e');
          }
        },
      ),
    );
  }

  Future<bool?> _showDeleteConfirmation(String name) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 700),
                curve: Curves.elasticOut,
                builder: (_, value, __) => Transform.scale(
                  scale: value,
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red.shade50,
                      border: Border.all(color: Colors.red.shade300, width: 5),
                    ),
                    child: const Icon(Icons.delete_forever_rounded, color: Colors.redAccent, size: 48),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text('Hapus Pelanggan?', style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              Text('Yakin ingin menghapus', style: GoogleFonts.poppins(fontSize: 15, color: Colors.black54)),
              Text('“$name”', style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.w600, color: AppColors.azura)),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text('Batal', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black54)),
                      
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                      child: Text('Hapus ', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmAndDelete(int id, String name) async {
    final confirm = await _showDeleteConfirmation(name);
    if (confirm == true) {
      try {
        await _service.delete(id);
        await _fetch();
        if (mounted) {
          showToastWidget(
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              decoration: BoxDecoration(color: Colors.red.shade600, borderRadius: BorderRadius.circular(20)),
              child: Row(
                children: [
                  const Icon(Icons.delete_rounded, color: Colors.white, size: 32),
                  const SizedBox(width: 16),
                  Text('"$name" dihapus permanen', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            context: context,
            position: StyledToastPosition.top,
            duration: const Duration(seconds: 4),
          );
        }
      } catch (e) {
        if (mounted) _showErrorToast('Gagal menghapus: $e');
      }
    }
  }

  List<Map<String, dynamic>> get _filtered {
    var list = _customers.where((c) {
      final q = _searchCtrl.text.toLowerCase();
      final name = (c['name'] ?? '').toString().toLowerCase();
      if (_showOnlyWithPhone) {
        return name.contains(q) && (c['phone']?.toString().isNotEmpty ?? false);
      }
      return name.contains(q);
    }).toList();

    if (_sortMode == 'A-Z') {
      list.sort((a, b) => (a['name'] ?? '').compareTo(b['name'] ?? ''));
    }
    return list;
  }

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 11) return 'Selamat pagi';
    if (h < 15) return 'Selamat siang';
    if (h < 18) return 'Selamat sore';
    return 'Selamat malam';
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    final recent = _customers.isNotEmpty ? _customers.first['name'] ?? '-' : '-';

    return Scaffold(
      key: _scaffoldKey,
      drawer: const SidebarDrawer(),
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(200),
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 36, 20, 18),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [AppColors.selly.withOpacity(0.95), AppColors.azura.withOpacity(0.95)]),
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(18)),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 18, offset: const Offset(0, 6))],
          ),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.menu_rounded, color: Colors.white, size: 32),
                      onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                    ),
                    const SizedBox(width: 8),
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.white.withOpacity(0.18),
                      child: Text(
                        _greeting().isNotEmpty ? _greeting()[0].toUpperCase() : 'K',
                        style: GoogleFonts.poppins(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_greeting(), style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13)),
                          Text('Manajemen Pelanggan', style: GoogleFonts.poppins(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                    IconButton(onPressed: _fetch, icon: const Icon(Icons.refresh_rounded, color: Colors.white, size: 28)),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(child: StatCard(title: 'Total Pelanggan', value: '${_customers.length}', icon: Icons.people, color: AppColors.selly)),
                    const SizedBox(width: 12),
                    Expanded(child: StatCard(title: 'Terbaru', value: recent, icon: Icons.person, color: AppColors.selly)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: ScaleTransition(
        scale: Tween(begin: 1.0, end: 1.06).animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut)),
        child: Container(
          width: 240,
          height: 62,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [AppColors.azura, AppColors.azura.withOpacity(0.9)]),
            borderRadius: BorderRadius.circular(32),
            boxShadow: [BoxShadow(color: AppColors.azura.withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 10))],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(32),
              onTap: () => _showForm(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.person_add_alt_1, color: Colors.white, size: 28),
                  const SizedBox(width: 12),
                  Text('Tambah Pelanggan', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: RefreshIndicator(
        onRefresh: _fetch,
        color: AppColors.azura,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 14, 18, 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchCtrl,
                      decoration: InputDecoration(
                        hintText: 'Cari pelanggan...',
                        hintStyle: GoogleFonts.poppins(color: Colors.grey.shade600),
                        prefixIcon: const Icon(Icons.search, color: Colors.black54),
                        filled: true,
                        fillColor: AppColors.card,
                        contentPadding: const EdgeInsets.symmetric(vertical: 14),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide(color: AppColors.azura, width: 2)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  InkWell(
                    onTap: () => setState(() => _showOnlyWithPhone = !_showOnlyWithPhone),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _showOnlyWithPhone ? AppColors.azura : AppColors.card,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8, offset: const Offset(0, 4))],
                      ),
                      child: Icon(Icons.phone_iphone_rounded, color: _showOnlyWithPhone ? Colors.white : AppColors.azura, size: 26),
                    ),
                  ),
                  const SizedBox(width: 10),
                  PopupMenuButton<String>(
                    onSelected: (v) => setState(() => _sortMode = v),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    itemBuilder: (_) => [
                      PopupMenuItem(value: 'Terbaru', child: Row(children: [const Icon(Icons.access_time), const SizedBox(width: 12), Text('Terbaru', style: GoogleFonts.poppins())])),
                      PopupMenuItem(value: 'A-Z', child: Row(children: [const Icon(Icons.sort_by_alpha), const SizedBox(width: 12), Text('A-Z', style: GoogleFonts.poppins())])),
                    ],
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8, offset: const Offset(0, 4))],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(_sortMode, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                          const SizedBox(width: 6),
                          const Icon(Icons.keyboard_arrow_down_rounded),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filtered.isEmpty
                      ? EmptyCustomerState(onAddPressed: () => _showForm())
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          itemCount: filtered.length,
                          itemBuilder: (_, i) {
                            final c = filtered[i];
                            return CustomerCard(
                              customer: c,
                              onEdit: () => _showForm(c),
                              onDelete: () => _confirmAndDelete(c['id_pelanggan'] as int, c['name']?.toString() ?? 'Pelanggan'),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}