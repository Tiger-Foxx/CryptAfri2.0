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
    this.urlImage =
        'https://a.c-dn.net/c/content/dam/publicsites/sgx/images/Email/Trading_Cryptocurrencies_Effectively_Using_PriceAction.jpg/jcr:content/renditions/original-size.webp',
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
