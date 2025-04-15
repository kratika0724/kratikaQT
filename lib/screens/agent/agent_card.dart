import 'package:flutter/material.dart';
import 'package:qt_distributer/constants/app_colors.dart';
import 'package:qt_distributer/constants/app_textstyles.dart';
import '../../models/agent_model.dart';

class AgentCard extends StatelessWidget {
  final AgentModel agent;

  const AgentCard({Key? key, required this.agent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 0),
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: _buildAvatar(),
          title: Text(
            agent.name,
            style: semiBoldTextStyle(fontSize: dimen15, color: AppColors.textSecondary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 2),
              // _buildBaseInfoRow('Company:', agent.companyName),
              _buildBaseInfoRow('Contact:', agent.contact),
              _buildBaseInfoRow('Email Id:', agent.email),
              // const SizedBox(height: 3),
              _buildStatusRow('Status:', agent.status),
              _buildCreatedRow('Created At:', agent.createdAt),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return const LinearGradient(
          colors: [Colors.amber, Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(bounds);
      },
      child: const Icon(Icons.person, size: 60, color: Colors.white),
    );
  }

  Widget _buildBaseInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: regularTextStyle(fontSize: dimen13, color: Colors.black),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              value,
              style: regularTextStyle(fontSize: dimen13, color: Colors.black),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreatedRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0,right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            value,
            style: regularTextStyle(fontSize: dimen13, color: Colors.black54),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0,right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            value,
            style: regularTextStyle(
                fontSize: dimen13,
                color: value.toLowerCase() == 'active'
                    ? Colors.green
                    : Colors.red
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}
