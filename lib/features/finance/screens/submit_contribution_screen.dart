import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/glass_container.dart';
import '../../../core/api/finance_service.dart';

class SubmitContributionScreen extends StatefulWidget {
  const SubmitContributionScreen({super.key});

  @override
  State<SubmitContributionScreen> createState() => _SubmitContributionScreenState();
}

class _SubmitContributionScreenState extends State<SubmitContributionScreen> {
  bool _isLoading = true;
  bool _isSubmitting = false;
  Map<String, dynamic>? _periodData;
  Map<String, dynamic>? _contribution;
  Map<String, dynamic>? _bankDetails;
  
  final _amountController = TextEditingController();
  final _referenceController = TextEditingController();
  final _notesController = TextEditingController();
  String _selectedMethod = 'bank_transfer';
  XFile? _proofFile;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final result = await FinanceService.getCurrentPeriod();
    if (result['success'] == true && mounted) {
      setState(() {
        _periodData = result['data']['period'];
        _contribution = result['data']['contribution'];
        _bankDetails = result['data']['bank_details'];
        
        if (_contribution != null) {
          _amountController.text = _contribution!['balance'].toString();
        }
        _isLoading = false;
      });
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result['message'] ?? 'Failed to load period')));
        context.pop();
      }
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (image != null) {
      setState(() { _proofFile = image; });
    }
  }

  Future<void> _submit() async {
    if (_amountController.text.isEmpty) return;
    
    setState(() { _isSubmitting = true; });
    final result = await FinanceService.submitPayment(
      contributionId: _contribution!['id'].toString(),
      amount: _amountController.text,
      paymentMethod: _selectedMethod,
      reference: _referenceController.text,
      notes: _notesController.text,
      proofFile: _proofFile,
    );
    setState(() { _isSubmitting = false; });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result['message'])));
      if (result['success'] == true) context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppTheme.darkBackground,
        body: Center(child: CircularProgressIndicator(color: AppTheme.brandPrimary)),
      );
    }

    final double balance = double.tryParse(_contribution?['balance'].toString() ?? '0') ?? 0;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.darkBackground,
        elevation: 0,
        title: const Text('Submit Payment'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      backgroundColor: AppTheme.darkBackground,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GlassContainer(
              child: Column(
                children: [
                  Text('Period: ${_periodData?['period_name']}', style: const TextStyle(color: Colors.black54)),
                  const SizedBox(height: 8),
                  Text('Balance Due: NGN $balance', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.brandPrimary)),
                ],
              ),
            ),
            if (balance > 0) ...[
              const SizedBox(height: 24),
              TextField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                style: const TextStyle(color: Colors.black87),
                decoration: const InputDecoration(
                  labelText: 'Amount (NGN)',
                  labelStyle: TextStyle(color: Colors.white54),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppTheme.glassBorder)),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppTheme.brandPrimary)),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedMethod,
                dropdownColor: AppTheme.darkBackground,
                style: const TextStyle(color: Colors.black87),
                decoration: const InputDecoration(
                  labelText: 'Payment Method',
                  labelStyle: TextStyle(color: Colors.white54),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppTheme.glassBorder)),
                ),
                items: const [
                  DropdownMenuItem(value: 'bank_transfer', child: Text('Bank Transfer')),
                  DropdownMenuItem(value: 'cash', child: Text('Cash')),
                  DropdownMenuItem(value: 'pos', child: Text('POS')),
                ],
                onChanged: (val) => setState(() { _selectedMethod = val!; }),
              ),
              if (_selectedMethod == 'bank_transfer' && _bankDetails != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: AppTheme.brandPrimary.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Bank: ${_bankDetails!['bank_name']}', style: const TextStyle(color: Colors.black87)),
                      Text('Name: ${_bankDetails!['account_name']}', style: const TextStyle(color: Colors.black87)),
                      Text('Account: ${_bankDetails!['account_number']}', style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 16),
              TextField(
                controller: _referenceController,
                style: const TextStyle(color: Colors.black87),
                decoration: const InputDecoration(
                  labelText: 'Transaction Reference (Optional if proof uploaded)',
                  labelStyle: TextStyle(color: Colors.white54),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppTheme.glassBorder)),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppTheme.brandPrimary)),
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.upload_file, color: Colors.black87),
                label: Text(_proofFile == null ? 'Upload Receipt' : 'Receipt Selected', style: const TextStyle(color: Colors.black87)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppTheme.brandPrimary),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isSubmitting ? null : _submit,
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                child: _isSubmitting 
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.black87, strokeWidth: 2))
                    : const Text('Submit Payment', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ] else ...[
              const SizedBox(height: 32),
              const Icon(Icons.check_circle, color: AppTheme.brandPrimary, size: 64),
              const SizedBox(height: 16),
              const Text('You are fully paid for this period!', textAlign: TextAlign.center, style: TextStyle(color: Colors.black87, fontSize: 18)),
            ]
          ],
        ),
      ),
    );
  }
}
