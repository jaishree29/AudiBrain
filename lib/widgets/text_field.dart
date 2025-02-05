import 'package:audibrain/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ATextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final bool isPhone;
  final List<TextInputFormatter> formatters;
  final String? errorMessage;
  final Icon? icon;
  final Widget? suffixIcon;
  final Function? onChanged;
  final Function? onTap;
  final String? hintText;
  final ValueChanged? onSubmitted;
  final ValueChanged<String>? onFieldSubmitted;
  final FormFieldValidator<String>? validator;

  const ATextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    this.isPhone = false,
    this.formatters = const [],
    this.errorMessage,
    this.icon,
    this.suffixIcon,
    this.onChanged,
    this.onTap,
    this.hintText,
    this.onSubmitted,
    this.onFieldSubmitted,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          onFieldSubmitted: onSubmitted,
          onTap: () => onTap,
          onChanged: (value) => onChanged?.call(value),
          inputFormatters: formatters,
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          cursorColor: AColors.primary.withOpacity(0.3),
          validator: validator,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: icon,
            prefixIconColor: AColors.primary.withOpacity(0.3),
            prefixText: isPhone == true ? '+91 ' : '',
            prefixStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(
                color: isDarkMode ? AColors.lightGrey : AColors.darkGrey,
              ),
            ),
            floatingLabelStyle: TextStyle(
              fontWeight: FontWeight.w500,
              color: isDarkMode
                  ? AColors.lightGrey
                  : AColors.primary.withOpacity(0.3),
            ),
            labelStyle: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              color: isDarkMode ? AColors.lightGrey : AColors.lightGrey,
            ),
            labelText: labelText,
            errorText: errorMessage,
            errorStyle: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.w300,
              color: Colors.red,
            ),
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }
}
