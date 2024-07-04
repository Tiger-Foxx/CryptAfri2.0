import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  String id;
  DateTime date;
  String content;
  String urlImage;

  MessageModel({
    required this.id,
    required this.date,
    required this.content,
    required this.urlImage,
  });

  factory MessageModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return MessageModel(
      id: doc.id,
      date: (data['date'] as Timestamp).toDate(),
      content: data['content'] ?? '',
      urlImage: data['url_image'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'content': content,
      'url_image': urlImage,
    };
  }
}
