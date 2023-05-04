import 'package:chatview/chatview.dart';
import 'package:flutter/material.dart';

class SendingMessageAnimatingWidget extends StatefulWidget {
  const SendingMessageAnimatingWidget(this.status, {Key? key})
      : super(key: key);

  final MessageStatus status;

  @override
  State<SendingMessageAnimatingWidget> createState() =>
      _SendingMessageAnimatingWidgetState();
}

class _SendingMessageAnimatingWidgetState
    extends State<SendingMessageAnimatingWidget> with TickerProviderStateMixin {
  bool get isSent => widget.status != MessageStatus.pending;

  bool isVisible = false;

  _attachOnStatusChangeListeners() {
    if (isSent) {
      Future.delayed(const Duration(milliseconds: 400), () {
        isVisible = true;
        if (mounted) {
          setState(() {});
        }
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _attachOnStatusChangeListeners();
    return AnimatedPadding(
      curve: Curves.easeInOutExpo,
      duration: const Duration(seconds: 1),
      padding: EdgeInsets.only(right: isSent ? 5 : 8.0, bottom: isSent ? 8 : 2),
      child: isVisible
          ? const SizedBox()
          : isSent
              ? const Icon(
                  Icons.check_circle_rounded,
                  color: Colors.grey,
                  size: 12,
                )
              : const Icon(
                  Icons.circle_outlined,
                  color: Colors.grey,
                  size: 12,
                ),
    );
  }
}
