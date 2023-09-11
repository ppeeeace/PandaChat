class Message {
  final String? text;
  final String? senderUid;

  Message({
    this.text,
    this.senderUid,
  });

  factory Message.fromJson(jsonData) {
    return Message(
      text: jsonData['message'],
      senderUid: jsonData['senderUid'],
    );
  }
}
