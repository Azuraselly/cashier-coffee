import 'package:flutter/material.dart';
import 'package:kasir/screens/dashboard/widgets/stat_card.dart';
import 'package:kasir/screens/dashboard/widgets/overview_tab.dart';
import 'package:kasir/screens/dashboard/widgets/transaction_item.dart';
import 'package:kasir/screens/dashboard/widgets/charts/line_chart_widget.dart';
import 'package:kasir/screens/dashboard/widgets/charts/bar_chart_widget.dart';
import 'package:kasir/widgets/sidebar_drawer.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedTab = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const SidebarDrawer(),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(radius: 16, backgroundColor: Colors.white.withOpacity(0.3), child: const Icon(Icons.person, color: Colors.white, size: 18)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Search
            Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30), boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2)),
              ]),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),

            // Stats
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(child: StatCard(icon: Icons.inventory_2_outlined, value: '159', label: 'Total Stok')),
                  const SizedBox(width: 12),
                  Expanded(child: StatCard(icon: Icons.people_outline, value: '45', label: 'Pelanggan Aktif')),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Line Chart
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
              ]),
              child: const LineChartWidget(),
            ),

            const SizedBox(height: 24),

            // Tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Text('Overview', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const Spacer(),
                  OverviewTab(text: 'Today', isSelected: _selectedTab == 0, onTap: () => setState(() => _selectedTab = 0)),
                  OverviewTab(text: 'Weekly', isSelected: _selectedTab == 1, onTap: () => setState(() => _selectedTab = 1)),
                  OverviewTab(text: 'Monthly', isSelected: _selectedTab == 2, onTap: () => setState(() => _selectedTab = 2)),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Bar Chart
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
              ]),
              child: const BarChartWidget(),
            ),

            const SizedBox(height: 24),

            // Transaksi
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Align(alignment: Alignment.centerLeft, child: Text('Transaksi Terbaru', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600))),
            ),
            const SizedBox(height: 12),
            const TransactionItem(trx: 'TRX-1000', name: 'Devina Putri', amount: 'Rp.30.000'),
            const TransactionItem(trx: 'TRX-2000', name: 'Salsadilla', amount: 'Rp.40.000'),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}