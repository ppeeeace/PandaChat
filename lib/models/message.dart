import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String? message;
  final String? senderUid;
  final String? senderEmail;
  final String? receiverUid;
  final Timestamp? timestamp;

  Message({
    this.message,
    this.senderUid,
    this.senderEmail,
    this.receiverUid,
    this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'senderUid': senderUid,
      'senderEmail': senderEmail,
      'receiverUid': receiverUid,
      'timestamp': timestamp!.toDate().toString(),
    };
  }

  factory Message.fromJson(jsonData) {
    return Message(
      message: jsonData['message'],
      senderUid: jsonData['senderUid'],
      senderEmail: jsonData['senderEmail'],
      receiverUid: jsonData['receiverUid'],
      timestamp: Timestamp.fromDate(DateTime.parse(jsonData['timestamp'])),
    );
  }
}
