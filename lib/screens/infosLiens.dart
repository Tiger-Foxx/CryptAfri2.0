import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(LienScreen());
}

class LienScreen extends StatelessWidget {
  static const routeName = 'lien';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nos liens',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final List<Map<String, String>> links = [
    {
      'title': 'Groupes d\'informations',
      'description':
          "Rejoignez notre groupe d'information et soyez informé des dernières tendances",
      'url': 'https://t.me/+z2wGYXkuETZkODI0',
      'image': 'assets/images/0.jpg'
    },
    {
      'title': 'Services proposés',
      'description': 'Nous vous proposons une gamme de services variées',
      'url': 'http://t.me/cryptafrique',
      'image': 'assets/images/0.jpg'
    },
  ];

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false, forceWebView: false);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Groupes Telegram',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800)),
        backgroundColor: Colors.amber,
        iconTheme: IconThemeData(color: Colors.amber),
      ),
      body: ListView.builder(
        itemCount: links.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              contentPadding: EdgeInsets.all(10),
              leading:
                  Image.asset(links[index]['image']!, width: 50, height: 50),
              title: Text(links[index]['title']!,
                  style: TextStyle(color: Colors.black)),
              subtitle: Text(links[index]['description']!),
              trailing: ElevatedButton(
                onPressed: () => _launchURL(links[index]['url']!),
                child: Text('Rejoindre'),
                style: ElevatedButton.styleFrom(foregroundColor: Colors.amber),
              ),
            ),
          );
        },
      ),
    );
  }
}
