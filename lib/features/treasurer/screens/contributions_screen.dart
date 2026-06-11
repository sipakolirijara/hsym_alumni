import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/glass_container.dart';
import '../../../core/api/treasurer_service.dart';

class ContributionsScreen extends StatefulWidget {
  const ContributionsScreen({super.key});
  @override
  State<ContributionsScreen> createState() => _ContributionsScreenState();
}

class _ContributionsScreenState extends State<ContributionsScreen> {
  List<dynamic> _contributions = [];
  bool _isLoading = true;

  @override
  void initState() { super.initState(); _fetchData(); }

  Future<void> _fetchData() async {
    final result = await TreasurerService.getAllContributions();
    if (mounted && result['success'] == true) {
      setState(() { _contributions = result['data']; _isLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Global Ledger'), backgroundColor: AppTheme.darkBackground),
      backgroundColor: AppTheme.darkBackground,
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator(color: AppTheme.brandPrimary))
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _contributions.length,
            itemBuilder: (context, index) {
              final item = _contributions[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: GlassContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(item['full_name'], style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
                          Text('NGN ${item['amount_paid']} / ${item['amount_due']}', style: const TextStyle(color: AppTheme.brandPrimary)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text('Period: ${item['period_name']}', style: const TextStyle(color: Colors.white54, fontSize: 12)),
                      Text('Status: ${item['payment_status'].toUpperCase()}', style: TextStyle(color: item['payment_status'] == 'paid' ? AppTheme.brandPrimary : Colors.orange, fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              );
            },
          ),
    );
  }
}
