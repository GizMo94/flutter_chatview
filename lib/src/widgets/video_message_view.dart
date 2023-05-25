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
import 'package:chatview/src/widgets/delete_icon.dart';
import 'package:chatview/src/widgets/reaction_widget.dart';
import 'package:chatview/src/widgets/share_icon.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

///
class VideoMessageView extends StatefulWidget {
  ///
  const VideoMessageView({
    Key? key,
    required this.message,
    required this.isMessageBySender,
    this.videoMessageConfig,
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
  final VideoMessageConfiguration? videoMessageConfig;

  /// Provides configuration of reaction appearance in chat bubble.
  final MessageReactionConfiguration? messageReactionConfig;

  /// Represents flag of highlighting image when user taps on replied image.
  final bool highlightImage;

  /// Provides scale of highlighted image when user taps on replied image.
  final double highlightScale;

  ///
  final DeleteIconConfiguration? deleteIconConfig;

  @override
  State<VideoMessageView> createState() => _VideoMessageViewState();
}

class _VideoMessageViewState extends State<VideoMessageView> {
  String get videoUrl => widget.message.message;

  Widget get iconButton => ShareIcon(
        shareIconConfig: widget.videoMessageConfig?.shareIconConfig,
        imageUrl: videoUrl,
      );

  Widget get deleteButton => DeleteIcon(
        deleteIconConfiguration: widget.deleteIconConfig,
        message: widget.message,
      );

  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.network(videoUrl);

    _videoPlayerController.addListener(() {
      setState(() {});
    });
    _videoPlayerController.initialize().then((_) => setState(() {}));

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      showOptions: false,
      allowPlaybackSpeedChanging: false,
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: widget.isMessageBySender
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      children: [
        Stack(
          children: [
            GestureDetector(
              onTap: () => (widget.videoMessageConfig?.onTap != null &&
                      _videoPlayerController.value.isPlaying)
                  ? widget.videoMessageConfig?.onTap!(videoUrl)
                  : null,
              child: Transform.scale(
                scale: widget.highlightImage ? widget.highlightScale : 1.0,
                alignment: widget.isMessageBySender
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Container(
                  padding:
                      widget.videoMessageConfig?.padding ?? EdgeInsets.zero,
                  margin: widget.videoMessageConfig?.margin ??
                      EdgeInsets.only(
                        top: 6,
                        right: widget.isMessageBySender ? 6 : 0,
                        left: widget.isMessageBySender ? 0 : 6,
                        bottom: widget.message.reaction.reactions.isNotEmpty
                            ? 15
                            : 0,
                      ),
                  height: widget.videoMessageConfig?.height ?? 230,
                  width: widget.videoMessageConfig?.width ?? 230,
                  child: ClipRRect(
                    borderRadius: widget.videoMessageConfig?.borderRadius ??
                        BorderRadius.circular(14),
                    child: Chewie(
                      controller: _chewieController,
                    ),
                  ),
                ),
              ),
            ),
            if (widget.message.reaction.reactions.isNotEmpty)
              ReactionWidget(
                isMessageBySender: widget.isMessageBySender,
                reaction: widget.message.reaction,
                messageReactionConfig: widget.messageReactionConfig,
              ),
          ],
        ),
        //if (!widget.isMessageBySender) iconButton,
      ],
    );
  }
}

///
class ControlsOverlay extends StatelessWidget {
  ///
  const ControlsOverlay({required this.controller});

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 50),
          reverseDuration: const Duration(milliseconds: 200),
          child: controller.value.isPlaying
              ? const SizedBox.shrink()
              : Container(
                  color: Colors.black26,
                  child: const Center(
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 100.0,
                      semanticLabel: 'Play',
                    ),
                  ),
                ),
        ),
        GestureDetector(
          onTap: () {
            controller.value.isPlaying ? controller.pause() : controller.play();
          },
        ),
      ],
    );
  }
}
