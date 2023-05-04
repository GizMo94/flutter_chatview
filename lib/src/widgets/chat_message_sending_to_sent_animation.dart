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
    return isVisible
        ? const SizedBox()
        : isSent
            ? const Padding(
                padding: EdgeInsets.only(right: 4.0),
                child: Icon(
                  Icons.check_circle_rounded,
                  color: Colors.grey,
                  size: 12,
                ),
              )
            : const Padding(
                padding: EdgeInsets.only(right: 4.0),
                child: Icon(
                  Icons.circle_outlined,
                  color: Colors.grey,
                  size: 12,
                ),
              );
  }
}
