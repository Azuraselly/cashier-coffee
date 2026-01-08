import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kasir/utils/constants.dart';
import 'package:kasir/services/customer_service.dart'; // sesuaikan path

class CustomerInput extends StatefulWidget {
  final TextEditingController controller;
  final Function(int? customerId)? onCustomerSelected; // callback id_pelanggan

  const CustomerInput({
    super.key,
    required this.controller,
    this.onCustomerSelected,
  });

  @override
  State<CustomerInput> createState() => _CustomerInputState();
}

class _CustomerInputState extends State<CustomerInput> {
  final CustomerService _customerService = CustomerService();
  List<Map<String, dynamic>> _allCustomers = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadAllCustomers(); // preload semua customer sekali saja
  }

  Future<void> _loadAllCustomers() async {
    setState(() => _isLoading = true);
    final customers = await _customerService.fetchAll();
    if (mounted) {
      setState(() {
        _allCustomers = customers;
        _isLoading = false;
      });
    }
  }

  List<Map<String, dynamic>> _filterCustomers(String query) {
    if (query.isEmpty) return [];
    final lowerQuery = query.toLowerCase();
    return _allCustomers
        .where((customer) =>
            (customer['name'] ?? '').toString().toLowerCase().contains(lowerQuery))
        .take(10)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.card),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Customer",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 5),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.azura, width: 2),
            ),
            child: Autocomplete<Map<String, dynamic>>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                return _filterCustomers(textEditingValue.text);
              },
              displayStringForOption: (option) => option['name'] ?? '',
              fieldViewBuilder:
                  (context, textEditingController, focusNode, onFieldSubmitted) {
                // Sinkronkan dengan controller parent
                textEditingController.text = widget.controller.text;

                // Update controller parent saat user ketik
                textEditingController.addListener(() {
                  widget.controller.text = textEditingController.text;
                  widget.controller.selection = textEditingController.selection;
                });

                return TextField(
                  controller: textEditingController,
                  focusNode: focusNode,
                  onSubmitted: (_) => onFieldSubmitted(),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Ketik nama customer...",
                    hintStyle:
                        GoogleFonts.poppins(fontSize: 16, color: Colors.black54),
                  ),
                  style: GoogleFonts.poppins(fontSize: 16, color: Colors.black),
                );
              },
              optionsViewBuilder: (context, onSelected, options) {
                return Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    elevation: 8,
                    borderRadius: BorderRadius.circular(12),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 300),
                      child: Container(
                        width: MediaQuery.of(context).size.width - 72,
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: options.isEmpty && !_isLoading
                            ? const Padding(
                                padding: EdgeInsets.all(16),
                                child: Text(
                                  "Tidak ditemukan customer",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              )
                            : _isLoading
                                ? const Padding(
                                    padding: EdgeInsets.all(16),
                                    child: CircularProgressIndicator(),
                                  )
                                : ListView.builder(
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    itemCount: options.length,
                                    itemBuilder: (context, index) {
                                      final customer =
                                          options.elementAt(index);
                                      return InkWell(
                                        onTap: () => onSelected(customer),
                                        child: ListTile(
                                          title: Text(
                                            customer['name'] ?? '',
                                            style: GoogleFonts.poppins(
                                                fontSize: 16),
                                          ),
                                          subtitle: customer['phone'] != null
                                              ? Text(
                                                  customer['phone'],
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 14,
                                                      color: Colors.grey),
                                                )
                                              : null,
                                          trailing: const Icon(
                                              Icons.person_outline),
                                        ),
                                      );
                                    },
                                  ),
                      ),
                    ),
                  ),
                );
              },
              onSelected: (Map<String, dynamic> selected) {
                widget.controller.text = selected['name'] ?? '';
                // Kirim ID ke parent kalau diperlukan
                widget.onCustomerSelected?.call(selected['id_pelanggan']);
              },
            ),
          ),
          const SizedBox(height: 5),
        ],
      ),
    );
  }
}