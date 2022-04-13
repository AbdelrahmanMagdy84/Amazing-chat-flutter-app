import 'package:flutter/material.dart';

class PasswordChecker extends StatelessWidget {
  const PasswordChecker({
    Key? key,
    required this.upperCase,
    required this.lowerCase,
    required this.hasNumber,
    required this.validPasswordLength,
  }) : super(key: key);

  final bool upperCase;
  final bool lowerCase;
  final bool hasNumber;
  final bool validPasswordLength;
  Widget rowBuilder(bool checker, BuildContext ctx, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 5,
      ),
      child: Row(
        children: [
          Icon(
            Icons.check,
            color: checker ? Theme.of(ctx).colorScheme.primary : Colors.grey,
          ),
          Text(label)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        rowBuilder(lowerCase, context, "Lower-case"),
        rowBuilder(upperCase, context, "Upper-case"),
        rowBuilder(hasNumber, context, "Number"),
        rowBuilder(validPasswordLength, context, "> 8 chars"),
      ],
    );
  }
}
