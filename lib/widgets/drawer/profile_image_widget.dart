import 'package:flutter/material.dart';

class ProfileImageWidget extends StatelessWidget {
  BoxConstraints constraints;
  bool isLoading;
  String imageUrl;
  Function(BuildContext context)? chooseImage;
  ProfileImageWidget({
    required this.constraints,
    required this.isLoading,
    required this.imageUrl,
    required this.chooseImage,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          radius: constraints.maxWidth * 0.26,
          child: CircleAvatar(
            backgroundColor: Colors.grey,
            radius: constraints.maxWidth * 0.25,
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.primary),
                  )
                : null,
            backgroundImage: isLoading ? null : NetworkImage(imageUrl),
            onBackgroundImageError: isLoading ? null : (_, __) {},
          ),
        ),
        Positioned(
          bottom: 10,
          right: 20,
          child: IconButton(
            onPressed: () => chooseImage!(context),
            icon: const Icon(
              Icons.image_sharp,
              size: 40,
            ),
          ),
        )
      ],
    );
  }
}
