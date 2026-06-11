import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/glass_container.dart';
import '../../../core/api/treasurer_service.dart';

class VerificationsScreen extends StatefulWidget {
  const VerificationsScreen({super.key});
  @override
  State<VerificationsScreen> createState() => _VerificationsScreenState();
}

class _VerificationsScreenState extends State<VerificationsScreen> {
  List<dynamic> _pending = [];
  bool _isLoading = true;

  @override
  void initState() { super.initState(); _fetchData(); }

  Future<void> _fetchData() async {
    setState(() { _isLoading = true; });
    final result = await TreasurerService.getPendingVerifications();
    if (mounted && result['success'] == true) {
      setState(() { _pending = result['data']; _isLoading = false; });
    }
  }

  void _showVerifyDialog(dynamic item) {
    final remarksController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.lightBackground,
        title: const Text('Verify Payment', style: TextStyle(color: Colors.black87)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Member: ${item['full_name']}', style: const TextStyle(color: Colors.black87)),
            Text('Amount: NGN ${item['amount']}', style: const TextStyle(color: AppTheme.brandPrimary, fontWeight: FontWeight.bold)),
            Text('Ref: ${item['transaction_reference'] ?? 'N/A'}', style: const TextStyle(color: Colors.black54)),
            const SizedBox(height: 16),
            TextField(
              controller: remarksController,
              style: const TextStyle(color: Colors.black87),
              decoration: const InputDecoration(labelText: 'Remarks (Required for rejection)', labelStyle: TextStyle(color: Colors.white54)),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => _process(item['id'].toString(), 'rejected', remarksController.text),
            child: const Text('Reject', style: TextStyle(color: Colors.redAccent)),
          ),
          ElevatedButton(
            onPressed: () => _process(item['id'].toString(), 'approved', remarksController.text),
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.brandPrimary),
            child: const Text('Approve'),
          ),
        ],
      ),
    );
  }

  Future<void> _process(String id, String status, String remarks) async {
    Navigator.pop(context);
    final result = await TreasurerService.verifyPayment(id, status, remarks);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result['message'])));
      if (result['success'] == true) _fetchData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pending Verifications'), backgroundColor: AppTheme.lightBackground),
      backgroundColor: AppTheme.lightBackground,
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator(color: AppTheme.brandPrimary))
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _pending.length,
            itemBuilder: (context, index) {
              final item = _pending[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: GlassContainer(
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text('${item['full_name']} (${item['member_no']})', style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
                    subtitle: Text('Amount: NGN ${item['amount']}\nPeriod: ${item['period_name']}', style: const TextStyle(color: Colors.black54)),
                    trailing: ElevatedButton(
                      onPressed: () => _showVerifyDialog(item),
                      child: const Text('Review'),
                    ),
                  ),
                ),
              );
            },
          ),
    );
  }
}
