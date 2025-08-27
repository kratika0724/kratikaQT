import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qt_distributer/constants/app_colors.dart';
import 'package:qt_distributer/widgets/common_text_widgets.dart';
import '../../../providers/dashboard_provider.dart';
import '../../../utils/ui_utils.dart';
import '../../../widgets/log_out_button.dart';
import '../../../widgets/user_profile_card.dart';
import '../../user profile/show_userprofile_screen.dart';
import '../../vendor_pages/vendor payments/pending_bills_list.dart';

class PendingBillsScreen extends StatefulWidget {
  const PendingBillsScreen({super.key});

  @override
  State<PendingBillsScreen> createState() => _PendingBillsScreenState();
}

class _PendingBillsScreenState extends State<PendingBillsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(builder: (context, provider, child) {
      return Scaffold(
        backgroundColor: AppColors.ghostWhite,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: HeaderTextBlack("Pending Bills"),
          backgroundColor: AppColors.primary_appbar,
          // elevation: 3,
        ),
        body: SafeArea(
          child: const PendingBillsList(),
        ),
      );
    });
  }
}
