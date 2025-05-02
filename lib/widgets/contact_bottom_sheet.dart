import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constants/app_textstyles.dart';

class ContactBottomSheet extends StatelessWidget {
  const ContactBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 40),
          padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Contact Us", style: semiBoldTextStyle(fontSize: dimen18, color: Colors.black)),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.call, color: Colors.black),
                title: Text(
                  "Call us",
                  style: semiBoldTextStyle(fontSize: dimen15, color: Colors.black),
                ),
                subtitle: Text(
                  "To speak with a representative, start an instant call with our support team.",
                  style: regularTextStyle(fontSize: dimen13, color: Colors.black54),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _makePhoneCall(context, '+919876543210');
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Divider(thickness: 0.4, color: Colors.grey.shade300),
              ),
              ListTile(
                leading: const Icon(Icons.email, color: Colors.black),
                title: Text(
                  "Email us",
                  style: semiBoldTextStyle(fontSize: dimen15, color: Colors.black),
                ),
                subtitle: Text(
                  "Send a query to our customer support team via email.",
                  style: regularTextStyle(fontSize: dimen13, color: Colors.black54),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _launchEmail(context, "vososhop@gmail.com");
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),

        // Floating Close Button
        Positioned(
          top: -20,
          left: 0,
          right: 0,
          child: Center(
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const CircleAvatar(
                backgroundColor: Colors.white,
                radius: 22,
                child: Icon(Icons.close, color: Colors.black87),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _launchEmail(BuildContext context, String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=Support Request&body=Hello,',
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      _showSnackBar(context, "Could not open email app");
    }
  }

  Future<void> _makePhoneCall(BuildContext context, String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    _launchUrl(context, phoneUri);
  }

  Future<void> _launchUrl(BuildContext context, Uri uri) async {
    if (await canLaunchUrl(uri)) {
      try {
        await launchUrl(uri);
      } catch (e) {
        _showSnackBar(context, "Could not make call.");
      }
    } else {
      _showSnackBar(context, "Could not open the link.");
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    }
  }
}
