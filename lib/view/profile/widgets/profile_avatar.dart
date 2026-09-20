import 'dart:io';
import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final String? imageUrl;
  final File? localImage;

  const ProfileAvatar({
    super.key,
    required this.imageUrl,
    required this.localImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 2,
      height: MediaQuery.of(context).size.width / 2,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 5),
        shape: BoxShape.circle,
        color: Colors.blueAccent.withOpacity(0.2),
        image: DecorationImage(
          image: imageUrl != null
              ? localImage == null
                  ? NetworkImage(imageUrl!) as ImageProvider
                  : FileImage(localImage!)
              : const AssetImage("assets/images/profile.jpg"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
