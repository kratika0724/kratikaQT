import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qt_distributer/constants/app_colors.dart';
import 'package:qt_distributer/constants/app_textstyles.dart';
import 'package:qt_distributer/models/response models/cash_submission_request_response.dart';
import 'package:qt_distributer/services/api_path.dart';
import 'package:qt_distributer/services/api_service.dart';
import 'package:intl/intl.dart';

class CashSubmissionHistoryScreen extends StatefulWidget {
  const CashSubmissionHistoryScreen({super.key});

  @override
  State<CashSubmissionHistoryScreen> createState() =>
      _CashSubmissionHistoryScreenState();
}

class _CashSubmissionHistoryScreenState
    extends State<CashSubmissionHistoryScreen>
    with SingleTickerProviderStateMixin {
  final ApiService _apiService = ApiService();
  late TabController _tabController;

  // Data for each tab
  Map<String, List<CashSubmissionRequestData>> _tabData = {
    'pending': [],
    'approved': [],
    'rejected': [],
  };

  Map<String, bool> _isLoading = {
    'pending': true,
    'approved': true,
    'rejected': true,
  };

  Map<String, String?> _errors = {
    'pending': null,
    'approved': null,
    'rejected': null,
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_onTabChanged);
    _fetchCashSubmissionHistory(status: 'pending');
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    final currentTab = _getCurrentTabKey();
    _fetchCashSubmissionHistory(status: _getStatusForTab(currentTab));
  }

  String _getCurrentTabKey() {
    switch (_tabController.index) {
      case 0:
        return 'pending';
      case 1:
        return 'approved';
      case 2:
        return 'rejected';
      default:
        return 'pending';
    }
  }

  String _getStatusForTab(String tabKey) {
    switch (tabKey) {
      case 'pending':
        return 'pending';
      case 'approved':
        return 'approved';
      case 'rejected':
        return 'rejected';
      default:
        return 'pending';
    }
  }

  Future<void> _fetchCashSubmissionHistory({String? status = "pending"}) async {
    final tabKey = status ?? 'pending';
    setState(() {
      _isLoading[tabKey] = true;
      _errors[tabKey] = null;
    });

    try {
      final Map<String, String> queryParams = {};
      if (status != null) {
        queryParams['status'] = status;
      }
      final response = await _apiService.getAuth(
        context,
        ApiPath.cashSubmissionReqList,
        queryParams,
      );

      final submissionResponse =
          CashSubmissionRequestResponse.fromJson(response);
      if (submissionResponse.success) {
        setState(() {
          _tabData[tabKey] = submissionResponse.data;
          _isLoading[tabKey] = false;
        });
      } else {
        setState(() {
          _errors[tabKey] = submissionResponse.message;
          _isLoading[tabKey] = false;
        });
      }
    } catch (e) {
      setState(() {
        _errors[tabKey] = 'Failed to load cash submission history: $e';
        _isLoading[tabKey] = false;
      });
    }
  }

  Future<void> _refreshCurrentTab() async {
    final currentTab = _getCurrentTabKey();
    await _fetchCashSubmissionHistory(status: _getStatusForTab(currentTab));
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd MMM yyyy, hh:mm a').format(date);
    } catch (e) {
      return dateString;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ghostWhite.withOpacity(0.99),
      appBar: AppBar(
        title: Text(
          'Cash Submission History',
          style: boldTextStyle(
            fontSize: dimen18,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.primary,
        elevation: 2,
        shadowColor: AppColors.primary.withOpacity(0.1),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _refreshCurrentTab,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: mediumTextStyle(
            fontSize: dimen12,
            color: Colors.white,
          ),
          tabs: const [
            Tab(text: 'Pending'),
            Tab(text: 'Approved'),
            Tab(text: 'Rejected'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTabContent('pending'),
          _buildTabContent('approved'),
          _buildTabContent('rejected'),
        ],
      ),
    );
  }

  Widget _buildTabContent(String tabKey) {
    if (_isLoading[tabKey]!) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errors[tabKey] != null) {
      return _buildErrorWidget(tabKey);
    }

    if (_tabData[tabKey]!.isEmpty) {
      return _buildEmptyWidget(tabKey);
    }

    return _buildSubmissionList(tabKey);
  }

  Widget _buildErrorWidget(String tabKey) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Error',
            style: boldTextStyle(
              fontSize: dimen18,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _errors[tabKey]!,
            style: mediumTextStyle(
              fontSize: dimen14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () =>
                _fetchCashSubmissionHistory(status: _getStatusForTab(tabKey)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyWidget(String tabKey) {
    String title;
    String message;

    switch (tabKey) {
      case 'pending':
        title = 'No Pending Submissions';
        message = 'You don\'t have any pending cash submission requests.';
        break;
      case 'approved':
        title = 'No Approved Submissions';
        message = 'You don\'t have any approved cash submission requests.';
        break;
      case 'rejected':
        title = 'No Rejected Submissions';
        message = 'You don\'t have any rejected cash submission requests.';
        break;
      default:
        title = 'No Cash Submissions';
        message = 'You haven\'t made any cash submission requests yet.';
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: boldTextStyle(
                fontSize: dimen18,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: mediumTextStyle(
                fontSize: dimen14,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmissionList(String tabKey) {
    return RefreshIndicator(
      onRefresh: () =>
          _fetchCashSubmissionHistory(status: _getStatusForTab(tabKey)),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _tabData[tabKey]!.length,
        itemBuilder: (context, index) {
          final submission = _tabData[tabKey]![index];
          return _buildSubmissionCard(submission);
        },
      ),
    );
  }

  Widget _buildSubmissionCard(CashSubmissionRequestData submission) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with amount and status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.account_balance_wallet,
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '₹${submission.amount}',
                          style: boldTextStyle(
                            fontSize: dimen18,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          'Cash Submission',
                          style: mediumTextStyle(
                            fontSize: dimen12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusColor(submission.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _getStatusColor(submission.status),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    submission.status.toUpperCase(),
                    style: mediumTextStyle(
                      fontSize: dimen12,
                      color: _getStatusColor(submission.status),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Note section
            if (submission.note.isNotEmpty) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.note,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      submission.note,
                      style: mediumTextStyle(
                        fontSize: dimen14,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
            Row(
              children: [
                Icon(
                  Icons.admin_panel_settings,
                  size: 16,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Requested to : ${submission.topUserName}',
                    style: mediumTextStyle(
                      fontSize: dimen12,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Date information
            Row(
              children: [
                Icon(
                  Icons.schedule,
                  size: 16,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Submitted: ${_formatDate(submission.createdAt)}',
                    style: mediumTextStyle(
                      fontSize: dimen12,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
            if (submission.updatedAt != submission.createdAt) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.update,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Updated: ${_formatDate(submission.updatedAt)}',
                      style: mediumTextStyle(
                        fontSize: dimen12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
