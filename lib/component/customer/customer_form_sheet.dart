import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kasir/utils/constants.dart';

class CustomerFormSheet extends StatefulWidget {
  final Map<String, dynamic>? customer;
  final Future<void> Function(String name, String phone, String address) onSave;

  const CustomerFormSheet({
    super.key,
    this.customer,
    required this.onSave,
  });

  @override
  State<CustomerFormSheet> createState() => _CustomerFormSheetState();
}

class _CustomerFormSheetState extends State<CustomerFormSheet> {
  final _formKey = GlobalKey<FormState>();

  late final _nameCtrl =
      TextEditingController(text: widget.customer?['name'] ?? '');
  late final _phoneCtrl =
      TextEditingController(text: widget.customer?['phone'] ?? '');
  late final _addressCtrl =
      TextEditingController(text: widget.customer?['address'] ?? '');

  bool _isSaving = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;

    setState(() => _isSaving = true);

    try {
      // Ambil dan trim nilai setelah validasi
      final name = _nameCtrl.text.trim();
      final phone = _phoneCtrl.text.trim();
      final address = _addressCtrl.text.trim();

      await widget.onSave(
        name,
        phone.isEmpty ? '' : phone,
        address.isEmpty ? '' : address,
      );

      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceFirst('Exception: ', '')),
            backgroundColor: Colors.red.shade600,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.customer != null;

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      expand: false,
      builder: (_, scrollController) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Form(
          key: _formKey,
          child: ListView(
            controller: scrollController,
            padding: EdgeInsets.only(
              left: 22,
              right: 22,
              top: 18,
              bottom: MediaQuery.of(context).viewInsets.bottom + 22,
            ),
            children: [
              Center(
                child: Container(
                  width: 70,
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: AppColors.selly.withOpacity(0.18),
                    child: Icon(
                      isEdit ? Icons.edit_rounded : Icons.person_add,
                      color: AppColors.azura,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      isEdit ? 'Edit Pelanggan' : 'Tambah Pelanggan',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              _buildField(
                controller: _nameCtrl,
                label: 'Nama Lengkap *',
                icon: Icons.person_outline_rounded,
                validator: (value) {
                  final v = (value ?? '').trim();
                  if (v.isEmpty) {
                    return 'Nama pelanggan wajib diisi';
                  }
                  if (v.length < 2) {
                    return 'Nama minimal 2 karakter';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              _buildField(
  controller: _phoneCtrl,
  label: 'Nomor Telepon *',
  icon: Icons.phone_android_rounded,
  keyboardType: TextInputType.phone, // tetap pakai phone untuk keyboard
  // ❌ HAPUS FilteringTextInputFormatter.digitsOnly
  inputFormatters: [
    LengthLimitingTextInputFormatter(15), // biarkan max 15 karakter (termasuk huruf/spasi)
  ],
  validator: (value) {
    final v = (value ?? '').trim();
    if (v.isEmpty) {
      return 'Nomor telepon wajib diisi';
    }

    // Bersihkan input: ambil hanya digit (0-9)
    final onlyDigits = v.replaceAll(RegExp(r'[^0-9]'), '');

    if (onlyDigits.isEmpty) {
      return 'Nomor telepon harus berisi angka';
    }
    if (onlyDigits.length < 8) {
      return 'Minimal 8 digit angka';
    }
    if (onlyDigits.length > 15) {
      return 'Maksimal 15 digit angka';
    }
    if (!onlyDigits.startsWith('0')) {
      return 'Harus diawali dengan angka 0 (misal: 0812...)';
    }

    // Optional: Update controller dengan nilai bersih (tanpa huruf/spasi)
    // Supaya tampilan input jadi rapi saat valid
    if (_phoneCtrl.text != onlyDigits) {
      // Gunakan WidgetsBinding untuk hindari "setState during build"
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _phoneCtrl.text != onlyDigits) {
          _phoneCtrl.value = TextEditingValue(
            text: onlyDigits,
            selection: TextSelection.collapsed(offset: onlyDigits.length),
          );
        }
      });
    }

    return null;
  },
),
              const SizedBox(height: 16),

              _buildField(
                controller: _addressCtrl,
                label: 'Alamat Lengkap',
                icon: Icons.location_on_outlined,
                maxLines: 4,
                validator: (value) {
                  final v = (value ?? '').trim();
                  if (v.isEmpty) return null;
                  if (v.length < 10) {
                    return 'Alamat minimal 10 karakter';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isSaving ? null : () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.azura),
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        'Batal',
                        style: GoogleFonts.poppins(
                          color: AppColors.azura,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.azura,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: _isSaving
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : Text(
                              isEdit ? 'Simpan' : 'Tambah',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
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

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    String? hint,
    required IconData icon,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      maxLines: maxLines,
      textCapitalization:
          maxLines > 1 ? TextCapitalization.sentences : TextCapitalization.words,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: AppColors.azura),
        filled: true,
        fillColor: AppColors.inputFill,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.azura, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.red.shade400),
        ),
        // Opsional: agar pesan error lebih dekat ke field
        errorStyle: const TextStyle(height: 0.9),
      ),
      validator: validator,
    );
  }
}