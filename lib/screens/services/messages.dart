import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

// La fonction pour envoyer un email
void sendEmail(String email, String message) async {
  // Le nom d'utilisateur et le mot de passe de l'envoyeur
  String username = 'donfackarthur750@gmail.com';
  String password = 'montgomery2+';

  // Le serveur SMTP de Gmail
  final smtpServer = gmail(username, password);

  // Le message à envoyer
  final mailMessage = Message()
    ..from = Address(username)
    ..recipients.add(email) // L'email du destinataire
    ..subject = 'Message from Flutter' // Le sujet du message
    ..text = message; // Le contenu du message

  try {
    // Envoyer le message
    final sendReport = await send(mailMessage, smtpServer);
    print('Message sent: ' + sendReport.toString());
  } on MailerException catch (e) {
    // Gérer les erreurs
    print('Message not sent.');
    for (var p in e.problems) {
      print('Problem: ${p.code}: ${p.msg}');
    }
  }
}
