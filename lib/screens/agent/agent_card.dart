import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:qt_distributer/constants/app_colors.dart';
import 'package:qt_distributer/constants/app_textstyles.dart';
import '../../models/agent_model.dart';

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
    return GestureDetector(
      onTap: onExpandToggle,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.0),
            color: isExpanded ? AppColors.primary.withOpacity(0.03) : Colors.white
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
          child: Column(
            children: [
              _buildNameStatusRow(agent.name, agent.status),
              Padding(
                padding: const EdgeInsets.only(left:6.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("CRM Id: "+agent.crmId,style: mediumTextStyle(fontSize: dimen13, color: Colors.black54))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left:6.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Service: "+agent.services,style: mediumTextStyle(fontSize: dimen13, color: Colors.black54))
                  ],
                ),
              ),
              if(isExpanded)...[
              SizedBox(height: 4,),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0.0),
                child: DottedLine(dashLength: 4.0, dashColor: Colors.grey.shade300,lineThickness: 1,),
              ),
              SizedBox(height: 8,),
                _buildBaseInfoRow('Contact', agent.contact),
              _buildBaseInfoRow('Email Id', agent.email),
                _buildBaseInfoRow('Gender', agent.gender),
              _buildBaseInfoRow('Created At', agent.createdAt)
              ]
            ],
          ),

        ),
      ),
    );
  }

  Widget _buildAvatar() {
    final gender = agent.gender.toLowerCase() ?? 'male'; // default to male if null
    final isMale = gender == 'male';

    return CircleAvatar(
      radius: 20,
      backgroundColor: Colors.transparent,
      child: ShaderMask(
        shaderCallback: (Rect bounds) {
          return LinearGradient(
            colors: isMale
                ? [Colors.indigo.shade900, Colors.blue]
                : [Colors.amber.shade600, Colors.amberAccent.shade100],
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
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildAvatar(),
        SizedBox(width: 0,),
        Expanded(
          flex: 2,
          child: Text(
            name,
            style: semiBoldTextStyle(fontSize: dimen15, color: Colors.black),
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
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: const Icon(
            Icons.keyboard_arrow_down,
            color: Colors.black54,size: 22,
          ),
        ),
      ],
    );
  }
  Widget _buildBaseInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(left: 6.0),
      child: Row(
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
      ),
    );
  }

}
