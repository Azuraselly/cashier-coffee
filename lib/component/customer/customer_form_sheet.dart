import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kasir/utils/constants.dart';

class CustomerFormSheet extends StatefulWidget {
  final Map<String, dynamic>? customer;
  final Future<void> Function(String name, String phone, String address) onSave;

  const CustomerFormSheet({super.key, this.customer, required this.onSave});

  @override
  State<CustomerFormSheet> createState() => _CustomerFormSheetState();
}

class _CustomerFormSheetState extends State<CustomerFormSheet> {
  late final _nameCtrl = TextEditingController(text: widget.customer?['name'] ?? '');
  late final _phoneCtrl = TextEditingController(text: widget.customer?['phone'] ?? '');
  late final _addressCtrl = TextEditingController(text: widget.customer?['address'] ?? '');
  bool _isSaving = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.customer != null;

    return DraggableScrollableSheet(
      initialChildSize: 0.62,
      minChildSize: 0.4,
      maxChildSize: 0.92,
      builder: (_, controller) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: EdgeInsets.only(
          left: 22,
          right: 22,
          top: 18,
          bottom: MediaQuery.of(context).viewInsets.bottom + 22,
        ),
        child: ListView(controller: controller, children: [
          Center(child: Container(width: 70, height: 6, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(20)))),
          const SizedBox(height: 16),
          Row(children: [
            CircleAvatar(radius: 26, backgroundColor: AppColors.selly.withOpacity(0.18), child: Icon(isEdit ? Icons.edit_rounded : Icons.person_add, color: AppColors.azura)),
            const SizedBox(width: 12),
            Expanded(child: Text(isEdit ? 'Edit Pelanggan' : 'Tambah Pelanggan', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w700))),
            IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close_rounded)),
          ]),
          const SizedBox(height: 18),
          _buildField(_nameCtrl, 'Nama Lengkap *', Icons.person),
          const SizedBox(height: 12),
          _buildField(_phoneCtrl, 'Nomor Telepon', Icons.phone, keyboardType: TextInputType.phone),
          const SizedBox(height: 12),
          _buildField(_addressCtrl, 'Alamat lengkap', Icons.location_on, maxLines: 4),
          const SizedBox(height: 24),
          Row(children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(side: BorderSide(color: AppColors.azura), padding: const EdgeInsets.symmetric(vertical: 20), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                child: Text('Batal', style: GoogleFonts.poppins(color: AppColors.azura, fontWeight: FontWeight.w600, fontSize: 16)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: _isSaving
                    ? null
                    : () async {
                        if (_nameCtrl.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nama wajib diisi')));
                          return;
                        }
                        setState(() => _isSaving = true);
                        await widget.onSave(_nameCtrl.text, _phoneCtrl.text, _addressCtrl.text);
                        if (mounted) Navigator.pop(context);
                      },
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.azura, padding: const EdgeInsets.symmetric(vertical: 20), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                child: _isSaving ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : Text(isEdit ? 'Simpan' : 'Tambah', style: GoogleFonts.poppins(fontWeight: FontWeight.w700, color: Colors.white, fontSize: 16)),
              ),
            ),
          ]),
        ]),
      ),
    );
  }

  Widget _buildField(TextEditingController ctrl, String hint, IconData icon, {TextInputType? keyboardType, int maxLines = 1}) {
    return TextField(
      controller: ctrl,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: AppColors.azura),
        filled: true,
        fillColor: AppColors.inputFill,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: AppColors.border)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: AppColors.azura, width: 2)),
      ),
    );
  }
}