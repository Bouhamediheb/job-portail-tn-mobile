import 'package:flutter/widgets.dart';
import 'package:portail_tn/features/widgets/vetical_space.dart';
import 'package:portail_tn/themes/color_styles.dart';

class ValidationError extends StatelessWidget {
  const ValidationError({super.key, required this.errorText});

  final String errorText;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        VerticalSpace(value: 4, ctx: context),
        Text(
          errorText,
          style: const TextStyle(color: ColorStyles.failureColor),
        ),
      ],
    );
  }
}
