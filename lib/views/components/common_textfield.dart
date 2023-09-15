import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CommonTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final String? Function(String?)? onChange;
  final Icon? prefixIcon;
  final Icon? suffixIcon;
  final Widget? suffix;
  final String? hineText;
  final String? labelText;
  final int? maxLength;
  final bool readOnly;
  final bool secureText;
  final TextInputType? textType;
  final TextInputAction? textAction;
  final Function()? onTap;
  final List<TextInputFormatter>? digitsOnly;
  final InputBorder? inputBorder;
  const CommonTextFormField({
    this.controller,
    this.validator,
    this.prefixIcon,
    this.hineText,
    this.labelText,
    this.digitsOnly,
    this.maxLength,
    this.readOnly = false,
    this.textType,
    this.onTap,
    super.key,
    this.textAction,
    this.suffix,
    this.secureText = false,
    this.suffixIcon,
    this.onChange,
    this.inputBorder,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: textType,
      maxLength: maxLength,
      validator: validator,
      textInputAction: textAction,
      onChanged: onChange,
      readOnly: readOnly,
      obscureText: secureText,
      onTap: onTap,

      // Multiple Function
      // onTap: (){
      //   (onTap != null) ? onTap!() : null;
      // },

      inputFormatters: digitsOnly,
      decoration: InputDecoration(
        border: inputBorder,
        counterText: "",
        prefixIcon: prefixIcon,
        suffix: suffix,
        suffixIcon: suffixIcon,
        hintText: hineText,
        labelText: labelText,
        labelStyle: const TextStyle(
          fontSize: 17,
          color: Color(0xff7C7C7C),
        ),
      ),
    );
  }
}
