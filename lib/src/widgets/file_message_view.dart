/*
 * Copyright (c) 2022 Simform Solutions
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */
import 'package:chatview/src/models/models.dart';
import 'package:chatview/src/utils/constants/constants.dart';
import 'package:chatview/src/widgets/delete_icon.dart';
import 'package:chatview/src/widgets/share_icon.dart';
import 'package:flutter/material.dart';

import 'reaction_widget.dart';

class FileMessageView extends StatelessWidget {
  const FileMessageView({
    Key? key,
    required this.message,
    required this.isMessageBySender,
    this.fileMessageConfiguration,
    this.messageReactionConfig,
    this.highlightImage = false,
    this.highlightScale = 1.2,
    this.deleteIconConfig,
  }) : super(key: key);

  /// Provides message instance of chat.
  final Message message;

  /// Represents current message is sent by current user.
  final bool isMessageBySender;

  /// Provides configuration for image message appearance.
  final FileMessageConfiguration? fileMessageConfiguration;

  /// Provides configuration of reaction appearance in chat bubble.
  final MessageReactionConfiguration? messageReactionConfig;

  /// Represents flag of highlighting image when user taps on replied image.
  final bool highlightImage;

  /// Provides scale of highlighted image when user taps on replied image.
  final double highlightScale;

  ///
  final DeleteIconConfiguration? deleteIconConfig;

  String get fileUrl => message.message;

  ///
  String? get name => message.name;

  Widget get iconButton => ShareIcon(
        shareIconConfig: fileMessageConfiguration?.shareIconConfig,
        imageUrl: fileUrl,
      );

  Widget get deleteButton => DeleteIcon(
        deleteIconConfiguration: deleteIconConfig,
        message: message,
      );

  Color get color => isMessageBySender
      ? fileMessageConfiguration?.incomingColor ?? Colors.purple
      : Colors.white;

  Color get colorInverse => !isMessageBySender
      ? fileMessageConfiguration?.incomingColor ?? Colors.purple
      : Colors.white;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          isMessageBySender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: isMessageBySender
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            Stack(
              children: [
                GestureDetector(
                  onTap: () => fileMessageConfiguration?.onTap != null
                      ? fileMessageConfiguration?.onTap!(fileUrl, name ?? '')
                      : null,
                  child: Transform.scale(
                    scale: highlightImage ? highlightScale : 1.0,
                    alignment: isMessageBySender
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      padding:
                          fileMessageConfiguration?.padding ?? EdgeInsets.zero,
                      margin: fileMessageConfiguration?.margin ??
                          EdgeInsets.only(
                            top: 0,
                            right: isMessageBySender ? 6 : 0,
                            left: isMessageBySender ? 0 : 6,
                            bottom:
                                message.reaction.reactions.isNotEmpty ? 15 : 0,
                          ),
                      decoration: BoxDecoration(
                        color: color.withOpacity(.65),
                        borderRadius: fileMessageConfiguration?.borderRadius ??
                            BorderRadius.circular(replyBorderRadius2),
                      ),
                      height: fileMessageConfiguration?.height ?? 65,
                      width: fileMessageConfiguration?.width ?? 205,
                      child: ClipRRect(
                        borderRadius: fileMessageConfiguration?.borderRadius ??
                            BorderRadius.circular(14),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: Row(
                            children: [
                              Container(
                                height: 45,
                                width: 45,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 6),
                                decoration: BoxDecoration(
                                  color: color,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: colorInverse,
                                    width: .5
                                  ),
                                ),
                                child: Icon(
                                  Icons.description,
                                  color: colorInverse,
                                  size: 22,
                                ),
                              ),
                              if (message.name != null) ...[
                                buildFileNameWidget(
                                    message.name!, colorInverse),
                                buildFileExtensionWidget(
                                    message.name!, colorInverse),
                                Text(
                                  ' - ${formatSize(message.size!)}',
                                  style: TextStyle(
                                    color: colorInverse,
                                    fontSize: 12,
                                  ),
                                ),
                              ]
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                if (message.reaction.reactions.isNotEmpty)
                  ReactionWidget(
                    isMessageBySender: isMessageBySender,
                    reaction: message.reaction,
                    messageReactionConfig: messageReactionConfig,
                  ),
              ],
            ),
            //if (!isMessageBySender) iconButton,
          ],
        ),
      ],
    );
  }
}

Widget buildFileNameWidget(String file, Color color) {
  String fileName = file.split('.').first;

  return Flexible(
    child: Text(
      fileName,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(color: color, fontSize: 12),
    ),
  );
}

Widget buildFileExtensionWidget(String file, Color color) {
  String extension = file.split('.').last;

  return Text(
    '.$extension',
    style: TextStyle(color: color, fontSize: 12),
  );
}

String formatSize(double size) {
  const int kiloByte = 1024;
  const int megaByte = kiloByte * 1024;
  const int gigaByte = megaByte * 1024;

  if (size >= gigaByte) {
    final double sizeInGB = size / gigaByte;
    return '${sizeInGB.toStringAsFixed(2)} Go';
  } else if (size >= megaByte) {
    final double sizeInMB = size / megaByte;
    return '${sizeInMB.toStringAsFixed(2)} Mo';
  } else if (size >= kiloByte) {
    final double sizeInKB = size / kiloByte;
    return '${sizeInKB.toStringAsFixed(2)} ko';
  } else {
    return '${size.toStringAsFixed(2)} o';
  }
}
