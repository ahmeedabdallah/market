void main (){
}
class Product {
  String name;
  int quantity;
  double price;
  int id;
  Product(this.id,this.name,this.quantity,this.price);
  @override
  String tostring()=>"id : $id  | name : $name | quantity : $quantity | price : $price";
}
