class ProductModel {
  var ID;
  var prix_achat;
  var prix_vente;
  var name;
  var image;
  var date;
  var Category;
  var quantity;
  var numero;
  var min_vente;
  var porteFeuille;
  int frais = 0;
  ProductModel({
    required this.Category,
    required this.ID,
    required this.date,
    required this.image,
    required this.prix_achat,
    required this.name,
    required this.quantity,
    required this.numero,
    required this.prix_vente,
    required this.min_vente,
    required this.porteFeuille,
    required this.frais,
  });
}
