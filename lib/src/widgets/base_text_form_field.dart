import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BaseTextFormField extends StatelessWidget {
  BaseTextFormField(
      {this.controller,
      this.keyboardType = TextInputType.text,
      this.textInputAction = TextInputAction.done,
      this.textAlign = TextAlign.start,
      this.autovalidate = false,
      this.hintText = '',
      this.maxLines = 1,
      this.inputFormatters,
      this.textColor,
      this.hintColor,
      this.borderColor,
      this.prefix,
      this.prefixIcon,
      this.suffix,
      this.suffixIcon,
      this.enabled = true,
      this.readOnly = false,
      this.enableInteractiveSelection = true,
      this.validator,
      this.textStyle,
      this.placeholderTextStyle,
      this.maxLength,
      this.focusNode,
      this.initialValue});

  final TextEditingController controller;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final TextAlign textAlign;
  final bool autovalidate;
  final String hintText;
  final int maxLines;
  final List<TextInputFormatter> inputFormatters;
  final Color textColor;
  final Color hintColor;
  final Color borderColor;
  final Widget prefix;
  final Widget prefixIcon;
  final Widget suffix;
  final Widget suffixIcon;
  final bool enabled;
  final FormFieldValidator<String> validator;
  final TextStyle placeholderTextStyle;
  final TextStyle textStyle;
  final int maxLength;
  final FocusNode focusNode;
  final bool readOnly;
  final bool enableInteractiveSelection;
  final String initialValue;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enableInteractiveSelection: enableInteractiveSelection,
      readOnly: readOnly,
      initialValue: initialValue,
      focusNode: focusNode,
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      textAlign: textAlign,
      autovalidate: autovalidate,
      maxLines: maxLines,
      inputFormatters: inputFormatters,
      enabled: enabled,
      maxLength: maxLength,
      style: textStyle ??
          TextStyle(
              fontSize: 16.0,
              color:
                  textColor ?? Theme.of(context).primaryTextTheme.title.color),
      decoration: InputDecoration(
          prefix: prefix,
          prefixIcon: prefixIcon,
          suffix: suffix,
          suffixIcon: suffixIcon,
          hintStyle: placeholderTextStyle ??
              TextStyle(
                  color: hintColor ?? Theme.of(context).hintColor,
                  fontSize: 16),
          hintText: hintText,
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: borderColor ??
                      Theme.of(context).primaryTextTheme.title.backgroundColor,
                  width: 1.0)),
          disabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: borderColor ??
                      Theme.of(context).primaryTextTheme.title.backgroundColor,
                  width: 1.0)),
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: borderColor ??
                      Theme.of(context).primaryTextTheme.title.backgroundColor,
                  width: 1.0))),
      validator: validator,
    );
  }
}
