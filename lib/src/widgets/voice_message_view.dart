import 'dart:async';
import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:chatview/chatview.dart';
import 'package:chatview/src/widgets/delete_icon.dart';
import 'package:chatview/src/widgets/reaction_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';

class VoiceMessageView extends StatefulWidget {
  const VoiceMessageView({
    Key? key,
    required this.screenWidth,
    required this.message,
    required this.isMessageBySender,
    this.inComingChatBubbleConfig,
    this.outgoingChatBubbleConfig,
    this.onMaxDuration,
    this.messageReactionConfig,
    this.config,
  }) : super(key: key);

  /// Provides configuration related to voice message.
  final VoiceMessageConfiguration? config;

  /// Allow user to set width of chat bubble.
  final double screenWidth;

  /// Provides message instance of chat.
  final Message message;
  final Function(int)? onMaxDuration;

  /// Represents current message is sent by current user.
  final bool isMessageBySender;

  /// Provides configuration of reaction appearance in chat bubble.
  final MessageReactionConfiguration? messageReactionConfig;

  /// Provides configuration of chat bubble appearance from other user of chat.
  final ChatBubble? inComingChatBubbleConfig;

  /// Provides configuration of chat bubble appearance from current user of chat.
  final ChatBubble? outgoingChatBubbleConfig;

  @override
  State<VoiceMessageView> createState() => _VoiceMessageViewState();
}

class _VoiceMessageViewState extends State<VoiceMessageView> {
  late PlayerController controller;
  late StreamSubscription<PlayerState> playerStateSubscription;
  late Future<Response> futureResponse;
  late String tempDir;

  final ValueNotifier<PlayerState> _playerState =
      ValueNotifier(PlayerState.stopped);

  PlayerState get playerState => _playerState.value;

  PlayerWaveStyle playerWaveStyle = const PlayerWaveStyle(scaleFactor: 70);

  Widget get deleteButton => DeleteIcon(
        deleteIconConfiguration: widget.config?.deleteIconConfig,
        message: widget.message,
      );

  @override
  void initState() {
    super.initState();

    getApplicationDocumentsDirectory().then((value) {
      tempDir = value.path;
    });

    controller = PlayerController();
    futureResponse = get(Uri.parse(widget.message.message));
    futureResponse.then((response) {
      Uint8List bytes = response.bodyBytes;
      File file =
          File('$tempDir/${extractFileNameFromUrl(widget.message.message)}');

      if (response.statusCode == 200) {
        file.writeAsBytes(bytes).then((_) {
          controller
              .preparePlayer(
                path: file.path,
                noOfSamples: widget.config?.playerWaveStyle
                        ?.getSamplesForWidth(widget.screenWidth * 0.5) ??
                    playerWaveStyle
                        .getSamplesForWidth(widget.screenWidth * 0.5),
              )
              .whenComplete(
                  () => widget.onMaxDuration?.call(controller.maxDuration));
        });
      }
      playerStateSubscription = controller.onPlayerStateChanged
          .listen((state) => _playerState.value = state);
    });
  }

  @override
  void dispose() {
    playerStateSubscription.cancel();
    controller.dispose();
    _playerState.dispose();
    super.dispose();
  }

  String extractFileNameFromUrl(String url) {
    List<String> urlParts = url.split('/');
    String fileName = urlParts.last.split('?').first;
    String fileID = fileName.split('-').last.split('.').first;
    String fileExtension = fileName.split('-').last.split('.').last;
    return fileID + fileExtension;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: widget.isMessageBySender
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      children: [
        if (widget.isMessageBySender) deleteButton,
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              decoration: widget.config?.decoration ??
                  BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: widget.isMessageBySender
                        ? widget.outgoingChatBubbleConfig?.color
                        : widget.inComingChatBubbleConfig?.color,
                  ),
              padding: widget.config?.padding ??
                  const EdgeInsets.symmetric(horizontal: 8),
              margin: widget.config?.margin ??
                  EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical:
                        widget.message.reaction.reactions.isNotEmpty ? 15 : 0,
                  ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ValueListenableBuilder<PlayerState>(
                    builder: (context, state, child) {
                      return IconButton(
                        onPressed: _playOrPause,
                        icon: state.isStopped ||
                                state.isPaused ||
                                state.isInitialised
                            ? widget.config?.playIcon ??
                                const Icon(
                                  Icons.play_arrow,
                                  color: Colors.white,
                                )
                            : widget.config?.pauseIcon ??
                                const Icon(
                                  Icons.stop,
                                  color: Colors.white,
                                ),
                      );
                    },
                    valueListenable: _playerState,
                  ),
                  AudioFileWaveforms(
                    size: Size(widget.screenWidth * 0.50, 60),
                    playerController: controller,
                    waveformType: WaveformType.fitWidth,
                    playerWaveStyle:
                        widget.config?.playerWaveStyle ?? playerWaveStyle,
                    padding: widget.config?.waveformPadding ??
                        const EdgeInsets.only(right: 10),
                    margin: widget.config?.waveformMargin,
                    animationCurve:
                        widget.config?.animationCurve ?? Curves.easeIn,
                    animationDuration: widget.config?.animationDuration ??
                        const Duration(milliseconds: 500),
                    enableSeekGesture: widget.config?.enableSeekGesture ?? true,
                  ),
                ],
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
      ],
    );
  }

  void _playOrPause() {
    assert(
      defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.android,
      "Voice messages are only supported with android and ios platform",
    );
    if (playerState.isInitialised ||
        playerState.isPaused ||
        playerState.isStopped) {
      controller.startPlayer(finishMode: FinishMode.pause);
    } else {
      controller.pausePlayer();
    }
  }
}
