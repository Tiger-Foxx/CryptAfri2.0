import 'Config.dart';
import 'package:http/http.dart' as http;
import '../models/category.model.dart';

class ProductService {
  /*static Future<List<Category>> categories() async {
    final reponse = await http.get(Uri.parse('${Config.apiUrl}/categories'));
    print(reponse.body);
    /*
    if (reponse.statusCode == 200) {
      final parsed = json.decode(reponse.body).cast<Map<String, dynamic>>();
      return parsed.map<Category>((json) => Category.fromJson(json)).toList();
    } else {
      throw Exception("Unable to fetch");
    }*/
    return [];
  }*/
}
