import 'package:flutter/material.dart';
import 'package:qt_distributer/constants/app_colors.dart';
import 'package:qt_distributer/constants/app_textstyles.dart';
import '../../models/agent_model.dart';

class AgentCard extends StatelessWidget {
  final AgentModel agent;

  const AgentCard({Key? key, required this.agent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.white
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Column(
          children: [
            _buildNameStatusRow(agent.name, agent.status),
            SizedBox(height: 5,),
            _buildBaseInfoRow('Contact', agent.contact),
            _buildBaseInfoRow('Email Id', agent.email),
            _buildBaseInfoRow('Created At', agent.createdAt)
          ],
        ),
        // child: ListTile(
        //   contentPadding: EdgeInsets.zero,
        //   leading: _buildAvatar(),
        //   title: Text(
        //     agent.name,
        //     style: semiBoldTextStyle(fontSize: dimen15, color: AppColors.textSecondary),
        //     maxLines: 1,
        //     overflow: TextOverflow.ellipsis,
        //   ),
        //   subtitle: Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       const SizedBox(height: 2),
        //       // _buildBaseInfoRow('Company:', agent.companyName),
        //       _buildBaseInfoRow('Contact:', agent.contact),
        //       _buildBaseInfoRow('Email Id:', agent.email),
        //       // const SizedBox(height: 3),
        //       _buildStatusRow('Status:', agent.status),
        //       _buildCreatedRow('Created At:', agent.createdAt),
        //     ],
        //   ),
        // ),
      ),
    );
  }

  Widget _buildAvatar() {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return  LinearGradient(
          colors: [Colors.indigo.shade900, Colors.blue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(bounds);
      },
      child: const Icon(Icons.person, size: 35, color: Colors.white),
    );
  }

  Widget _buildNameStatusRow(String name, String status) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildAvatar(),
        SizedBox(width: 6,),
        Expanded(
          flex: 2,
          child: Text(
            name,
            style: boldTextStyle(fontSize: dimen16, color: Colors.black),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
        Spacer(),
        Text(
          status,
          style: regularTextStyle(
              fontSize: dimen14,
              color: status.toLowerCase() == 'active'
                  ? Colors.green
                  : Colors.red
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ],
    );
  }
  Widget _buildBaseInfoRow(String label, String value) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: mediumTextStyle(fontSize: dimen13, color: Colors.black),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            ": ",
            style: mediumTextStyle(fontSize: dimen13, color: Colors.black),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
        Expanded(
          flex: 6,
          child: Text(
            value,
            style: mediumTextStyle(fontSize: dimen13, color: Colors.black),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ],
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
