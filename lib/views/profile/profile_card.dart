import 'package:audibrain/utils/colors.dart';
import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap; // A callback function for handling taps

  const ProfileCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,  // Accept the onTap function
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: ListTile(
        leading: Icon(icon, size: 20,color: AColors.primary,),  // Use the passed icon directly
        title: Text(title, style: const TextStyle(fontSize: 16)),
        subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 15),  // Changed to 'arrow_forward'
        onTap: onTap,  // Use the onTap property of ListTile
      ),
    );
  }
}
