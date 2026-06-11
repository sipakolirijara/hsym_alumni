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
      case 'president': return const PresidentDashboardScreen(roleTitle: 'President');
      case 'vice-president': return const PresidentDashboardScreen(roleTitle: 'Vice President');
      case 'secretary': return const SecretaryDashboardScreen(roleTitle: 'Secretary');
      case 'asst-secretary': return const SecretaryDashboardScreen(roleTitle: 'Asst. Secretary');
      case 'treasurer': return const TreasurerDashboardScreen();
      case 'fin-secretary': return const FinSecDashboardScreen(roleTitle: 'Financial Secretary');
      case 'auditor': return const FinSecDashboardScreen(roleTitle: 'Auditor');
      case 'provost': return const SecretaryDashboardScreen(roleTitle: 'Provost');
      case 'welfare-officer': return const SecretaryDashboardScreen(roleTitle: 'Welfare Officer');
      case 'legal-adviser': return const SecretaryDashboardScreen(roleTitle: 'Legal Adviser');
      case 'organising-secretary': return const SecretaryDashboardScreen(roleTitle: 'Organising Sec');
      case 'pro':
      case 'pro1':
      case 'pro2':
      case 'pro3': return const ProDashboardScreen();
      case 'media-director': return const ProDashboardScreen(); // Shares PRO/Gallery access
      case 'adviser': return const MemberDashboardScreen(); // With enhanced visibility logic
      case 'member': default: return const MemberDashboardScreen();
    }
  }
}
