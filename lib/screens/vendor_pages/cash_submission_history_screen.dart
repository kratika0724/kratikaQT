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
    extends State<CashSubmissionHistoryScreen> {
  final ApiService _apiService = ApiService();
  bool _isLoading = true;
  String? _error;
  List<CashSubmissionRequestData> _submissions = [];

  @override
  void initState() {
    super.initState();
    _fetchCashSubmissionHistory();
  }

  Future<void> _fetchCashSubmissionHistory() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await _apiService.getAuth(
        context,
        ApiPath.cashSubmissionReqList,
        {},
      );

      final submissionResponse =
          CashSubmissionRequestResponse.fromJson(response);

      if (submissionResponse.success) {
        setState(() {
          _submissions = submissionResponse.data;
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = submissionResponse.message;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Failed to load cash submission history: $e';
        _isLoading = false;
      });
    }
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
            onPressed: _fetchCashSubmissionHistory,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? _buildErrorWidget()
              : _submissions.isEmpty
                  ? _buildEmptyWidget()
                  : _buildSubmissionList(),
    );
  }

  Widget _buildErrorWidget() {
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
            _error!,
            style: mediumTextStyle(
              fontSize: dimen14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _fetchCashSubmissionHistory,
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

  Widget _buildEmptyWidget() {
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
              'No Cash Submissions',
              style: boldTextStyle(
                fontSize: dimen18,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'You haven\'t made any cash submission requests yet.',
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

  Widget _buildSubmissionList() {
    return RefreshIndicator(
      onRefresh: _fetchCashSubmissionHistory,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _submissions.length,
        itemBuilder: (context, index) {
          final submission = _submissions[index];
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
