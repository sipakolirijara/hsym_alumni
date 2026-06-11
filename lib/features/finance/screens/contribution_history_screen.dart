import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/glass_container.dart';
import '../../../core/api/finance_service.dart';

class ContributionHistoryScreen extends StatefulWidget {
  const ContributionHistoryScreen({super.key});
  @override
  State<ContributionHistoryScreen> createState() => _ContributionHistoryScreenState();
}

class _ContributionHistoryScreenState extends State<ContributionHistoryScreen> {
  List<dynamic> _history = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchHistory();
  }

  Future<void> _fetchHistory() async {
    final result = await FinanceService.getHistory();
    if (result['success'] == true && mounted) {
      setState(() {
        _history = result['data'];
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Contributions'), backgroundColor: AppTheme.darkBackground),
      backgroundColor: AppTheme.darkBackground,
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator(color: AppTheme.brandPrimary))
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _history.length,
            itemBuilder: (context, index) {
              final item = _history[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: GlassContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(item['period_name'], style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16)),
                          Text('NGN ${item['amount_due']}', style: const TextStyle(color: AppTheme.brandPrimary, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text('Status: ${item['payment_status']}', style: const TextStyle(color: Colors.black54)),
                      Text('Verification: ${item['verification_status'] ?? 'None'}', style: const TextStyle(color: Colors.black54)),
                    ],
                  ),
                ),
              );
            },
          ),
    );
  }
}
