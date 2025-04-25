import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qt_distributer/constants/app_textstyles.dart';
import '../../models/response models/agent_response.dart';

class AgentCard extends StatelessWidget {
  final AgentModel agent;
  final bool isExpanded;
  final VoidCallback onExpandToggle;

  const AgentCard({
    Key? key,
    required this.agent,
    required this.isExpanded,
    required this.onExpandToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('dd MMM yyyy, hh:mm a').format(agent.createdAt);

    return GestureDetector(
      onTap: onExpandToggle,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.0),
          color: isExpanded
              ? (agent.isActive
              ? Colors.green.withOpacity(0.1)
              : Colors.red.withOpacity(0.1))
              : Colors.white,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildNameStatusRow('${agent.firstName} ${agent.middleName} ${agent.lastName}', agent.isActive ? 'Active' : 'Inactive'),
            _buildBaseInfoRow(agent.email),
            const SizedBox(height: 4),
            if (isExpanded) ...[
              const SizedBox(height: 8),
              DottedLine(
                dashLength: 4.0,
                dashColor: Colors.grey.shade300,
                lineThickness: 1,
              ),
              const SizedBox(height: 8),
              // _buildInfoRow('Email', agent.email),
              _buildInfoRow('Mobile', agent.mobile),
              _buildInfoRow('CRM ID', agent.crmId),
              _buildInfoRow('Quintus ID', agent.quintusId),
              _buildInfoRow('Gender', agent.gender),
              _buildInfoRow('DOB', agent.dob.toLocal().toString().split(' ')[0]),
              _buildInfoRow('Address', '${agent.address.address1}, ${agent.address.city}, ${agent.address.state}, ${agent.address.country}'),
              _buildInfoRow('Created At', formattedDate),
              // _buildInfoRow('Updated By', agent.updatedBy),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(String gender) {
    final isMale = gender.toLowerCase() == 'male';
    return CircleAvatar(
      radius: 20,
      backgroundColor: Colors.transparent,
      child: ShaderMask(
        shaderCallback: (Rect bounds) {
          return LinearGradient(
            colors: isMale
                ? [Colors.indigo.shade900, Colors.blue]
                : [Colors.pink.shade300, Colors.pinkAccent.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds);
        },
        child: const Icon(Icons.account_circle, size: 30, color: Colors.white),
      ),
    );
  }

  Widget _buildNameStatusRow(String name, String status) {
    return Row(
      children: [
        // _buildAvatar(agent.gender),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            name,
            style: semiBoldTextStyle(fontSize: dimen15, color: Colors.black),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(
          status,
          style: regularTextStyle(
            fontSize: dimen14,
            color: status.toLowerCase() == 'active' ? Colors.green : Colors.red,
          ),
        ),
        const Icon(Icons.keyboard_arrow_down, color: Colors.black54),
      ],
    );
  }

  Widget _buildBaseInfoRow(String emailId) {
    return Padding(
      padding: const EdgeInsets.only(left: 6.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              emailId,
              style: regularTextStyle(fontSize: dimen15, color: Colors.black),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(left: 6.0, bottom: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: mediumTextStyle(fontSize: dimen13, color: Colors.black),
            ),
          ),
          const Text(': '),
          Expanded(
            flex: 5,
            child: Text(
              value,
              style: mediumTextStyle(fontSize: dimen13, color: Colors.black),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

