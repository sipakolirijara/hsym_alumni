import 'package:flutter/material.dart';
import '../../president/screens/president_dashboard_screen.dart';
import '../../secretary/screens/secretary_dashboard_screen.dart';
import '../../pro/screens/pro_dashboard_screen.dart';
import '../../treasurer/screens/treasurer_dashboard_screen.dart';
import '../../finsec/screens/finsec_dashboard_screen.dart';
import 'member_dashboard_screen.dart';

class RoleDashboardScreen extends StatelessWidget {
  final String role;
  const RoleDashboardScreen({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    switch (role.toLowerCase()) {
      case 'president':
        return const PresidentDashboardScreen(roleTitle: 'President');
      case 'vice-president':
        return const PresidentDashboardScreen(roleTitle: 'Vice President');
      case 'secretary':
        return const SecretaryDashboardScreen(roleTitle: 'Secretary');
      case 'asst-secretary':
        return const SecretaryDashboardScreen(roleTitle: 'Asst. Secretary');
      case 'pro':
        return const ProDashboardScreen();
      case 'treasurer':
        return const TreasurerDashboardScreen();
      case 'fin-secretary':
        return const FinSecDashboardScreen(roleTitle: 'Financial Secretary');
      case 'auditor':
      case 'auditor-1':
      case 'auditor-2':
        return const FinSecDashboardScreen(roleTitle: 'Auditor');
      case 'provost':
        return const SecretaryDashboardScreen(roleTitle: 'Provost');
      case 'welfare':
      case 'welfare-officer':
        return const SecretaryDashboardScreen(roleTitle: 'Welfare Officer');
      case 'legal':
      case 'legal-adviser':
        return const SecretaryDashboardScreen(roleTitle: 'Legal Adviser');
      case 'member':
      default:
        return const MemberDashboardScreen();
    }
  }
}
