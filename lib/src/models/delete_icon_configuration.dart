import 'package:chatview/chatview.dart';
import 'package:flutter/material.dart';

class DeleteIconConfiguration {
  /// Provides callback when user press on share button.
  final void Function(Message)? onPressed; // Returns imageURL

  /// Provides ability to add custom share icon.
  final Widget? icon;

  /// Used to give share icon background color.
  final Color? defaultIconBackgroundColor;

  /// Used to give share icon padding.
  final EdgeInsetsGeometry? padding;

  /// Used to give share icon margin.
  final EdgeInsetsGeometry? margin;

  /// Used to give share icon color.
  final Color? defaultIconColor;

  DeleteIconConfiguration({
    this.onPressed,
    this.icon,
    this.defaultIconBackgroundColor,
    this.padding,
    this.margin,
    this.defaultIconColor,
  });
}
