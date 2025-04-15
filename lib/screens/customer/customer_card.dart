import 'package:flutter/material.dart';
import 'package:qt_distributer/constants/app_colors.dart';
import 'package:qt_distributer/models/customer_model.dart';
import '../../constants/app_textstyles.dart';

class CustomerCard extends StatelessWidget {
  final CustomerModel customer;

  const CustomerCard({Key? key, required this.customer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.white
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2.0),
        child: ListTile(
          leading: _buildAvatar(),
          title: Text(
            customer.name ?? '',
            style: semiBoldTextStyle(fontSize: dimen15, color: AppColors.textSecondary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow('Contact:', customer.contact),
              _buildInfoRow('Service:', customer.service,color: Colors.black54),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildAvatar() {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          colors: [Colors.indigo.shade900, Colors.blue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(bounds);
      },
      child: const Icon(Icons.person, size: 50, color: Colors.white),
    );
  }

  Widget _buildInfoRow(String label, String value, {Color color = Colors.black}) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Text(
            label,
            style: regularTextStyle(fontSize: dimen13, color: color),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: regularTextStyle(fontSize: dimen13, color: color),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ],
    );
  }

}
