import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:kasir/utils/constants.dart';

class CustomerCard extends StatelessWidget {
  final Map<String, dynamic> customer;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CustomerCard({
    super.key,
    required this.customer,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final name = customer['name']?.toString() ?? '-';
    final phone = customer['phone']?.toString();
    final address = customer['address']?.toString();

    final DateTime createdAt = customer['created_at'] is DateTime
        ? customer['created_at']
        : DateTime.parse(customer['created_at'].toString());

    return Dismissible(
      key: ValueKey(customer['id_pelanggan']),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        child: const Icon(Icons.delete_forever, color: Colors.white, size: 32),
      ),
      confirmDismiss: (_) async {
        onDelete();
        return false;
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black.withOpacity(0.02)),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 4, offset: const Offset(0, 4))
          ],
        ),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  AppColors.selly.withOpacity(0.95),
                  AppColors.azura.withOpacity(0.95)
                ]),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  name.isNotEmpty ? name[0].toUpperCase() : '?',
                  style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 20),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 16)),
                  if (phone != null) ...[
                    const SizedBox(height: 6),
                    Text('Phone: $phone', style: GoogleFonts.poppins(color: Colors.black54, fontSize: 13)),
                  ],
                  if (address != null) ...[
                    const SizedBox(height: 4),
                    Text(address, style: GoogleFonts.poppins(color: Colors.black54, fontSize: 13)),
                  ],
                  const SizedBox(height: 6),
                  Text(
                    'Bergabung ${DateFormat('dd MMM yyyy').format(createdAt)}',
                    style: GoogleFonts.poppins(color: Colors.black45, fontSize: 11),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(icon: Icon(Icons.edit, color: AppColors.azura), onPressed: onEdit),
                IconButton(icon: const Icon(Icons.delete, color: Colors.redAccent), onPressed: onDelete),
              ],
            ),
          ],
        ),
      ),
    );
  }
}