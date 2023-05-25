import 'package:chatview/chatview.dart';

class Data {
  static const profileImage =
      "https://raw.githubusercontent.com/SimformSolutionsPvtLtd/flutter_showcaseview/master/example/assets/simform.png";
  static final messageList = [
    Message(
      id: '1',
      message: "Hi!",
      createdAt: DateTime(2022,20,05),
      sendBy: '1', // userId of who sends the message
      status: MessageStatus.read,
    ),
    Message(
      id: '2',
      message: "Hi!",
      createdAt: DateTime.now(),
      sendBy: '2',
      status: MessageStatus.read,
    ),
    Message(
      id: '3',
      message: "We can meet?I am free",
      createdAt: DateTime.now(),
      sendBy: '1',
      status: MessageStatus.read,
    ),
    Message(
      id: '4',
      message: "Can you write the time and place of the meeting?",
      createdAt: DateTime.now(),
      sendBy: '1',
      status: MessageStatus.read,
    ),
    Message(
      id: '5',
      message: "That's fine",
      createdAt: DateTime.now(),
      sendBy: '2',
      reaction: Reaction(reactions: ['\u{2764}'], reactedUserIds: ['1']),
      status: MessageStatus.read,
    ),
    Message(
      id: '6',
      message: "When to go ?",
      createdAt: DateTime.now(),
      sendBy: '3',
      status: MessageStatus.read,
    ),
    Message(
      id: '7',
      message: "I guess Simform will reply",
      createdAt: DateTime.now(),
      sendBy: '4',
      status: MessageStatus.read,
    ),
    Message(
      id: '8',
      message: "https://bit.ly/3JHS2Wl",
      createdAt: DateTime.now(),
      sendBy: '2',
      reaction: Reaction(
        reactions: ['\u{2764}', '\u{1F44D}', '\u{1F44D}'],
        reactedUserIds: ['2', '3', '4'],
      ),
      status: MessageStatus.read,
      replyMessage: const ReplyMessage(
        message: "Can you write the time and place of the meeting?",
        replyTo: '1',
        replyBy: '2',
        messageId: '4',
      ),
    ),
    Message(
      id: '9',
      message: "Done",
      createdAt: DateTime.now(),
      sendBy: '1',
      status: MessageStatus.read,
      reaction: Reaction(
        reactions: [
          '\u{2764}',
          '\u{2764}',
          '\u{2764}',
        ],
        reactedUserIds: ['2', '3', '4'],
      ),
    ),
    Message(
      id: '10',
      message: "https://storage.googleapis.com/download/storage/v1/b/locallyteams.appspot.com/o/demo%2Ffr26898907282%2Fchatmessage%2F85a2ff5b-6550-49ec-96eb-669a6f2dfcfd%2F022a76e2-7ded-4690-b853-d26c860a260a331965509413082349.mp4?generation=1684944526250208&alt=media",
      status: MessageStatus.read,
      createdAt: DateTime.now(),
      sendBy: '1',
      messageType: MessageType.video
    ),
    Message(
      id: '11',
      message: "https://miro.medium.com/max/1000/0*s7of7kWnf9fDg4XM.jpeg",
      createdAt: DateTime.now(),
      messageType: MessageType.image,
      sendBy: '1',
      reaction: Reaction(reactions: ['\u{2764}'], reactedUserIds: ['2']),
      status: MessageStatus.read,
    ),
    Message(
      id: '12',
      message: "pv1681468698_SIGNED.pdf",
      name: "pv1681468698_SIGNED.pdf",
      size: 58051,
      createdAt: DateTime.now(),
      sendBy: '1',
      messageType: MessageType.file,
      status: MessageStatus.archive,
    ),
  ];
}
