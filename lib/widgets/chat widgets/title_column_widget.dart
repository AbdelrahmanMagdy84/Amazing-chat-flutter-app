import 'package:flutter/material.dart';

class TitleColumnWidget extends StatelessWidget {
  const TitleColumnWidget({
    Key? key,
    required this.imageUrl,
    required this.username,
  }) : super(key: key);

  final String imageUrl;
  final String username;

  @override
  Widget build(BuildContext context) {
    bool isProtrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Wrap(
          alignment: WrapAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              radius: isProtrait ? 20 : 15,
              backgroundImage: imageUrl != "" ? NetworkImage(imageUrl) : null,
            ),
            Container(
              width: 120,
              alignment: Alignment.center,
              padding: const EdgeInsets.all(5),
              child: Text(
                username,
                style: TextStyle(
                    overflow: TextOverflow.ellipsis,
                    fontSize: isProtrait ? 12 : 16,
                    color: Theme.of(context).colorScheme.secondary),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
