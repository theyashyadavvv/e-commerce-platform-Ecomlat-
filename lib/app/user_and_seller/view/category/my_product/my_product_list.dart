import 'dart:math';

import 'package:ecommerce_int2/app/user_and_seller/model/products.dart';
import 'package:ecommerce_int2/app/user_and_seller/view/product/product_page.dart';
import 'package:ecommerce_int2/helper/base.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Product {
  final String name;
  final String category;
  final double price;
  final double rating;
  final String city;
  final String image;
  final String stock;
  final String stock_alert;
  final String description;
  final String pid;

  Product({
    required this.name,
    required this.category,
    required this.price,
    required this.rating,
    required this.city,
    required this.image,
    required this.stock,
    required this.stock_alert,
    required this.description,
    required this.pid,
  });
}

List<Product> products = [
  Product(
      name: "Mport",
      category: "Gadgets",
      price: 250,
      rating: 4.5,
      city: "Mumbai",
      stock:"0",
      stock_alert:"0",
      description: "description",
      image: "assets/myproduct/images.jpg",
      pid: "123"
  ),
  Product(
      name: "Multiport Adaptor",
      category: "Gadgets",
      price: 340,
      rating: 4.5,
      city: "Chennai",
      stock:"0",
      stock_alert:"0",
      description: "description",
      image: "assets/myproduct/images (1).jpg",
      pid: "1234"
  ),
  Product(
      name: "USB Drive",
      category: "Gadgets",
      price: 500,
      rating: 4.5,
      city: "Mumbai",
      stock:"0",
      stock_alert:"0",
      description: "description",
      image: "assets/myproduct/kingston-datatraveler-ultimate-gt-1.jpg",
      pid: "1235"
  ),
  Product(
      name: "Lighter",
      category: "Gadgets",
      price: 20,
      rating: 4.5,
      city: "Mumbai",
      stock:"0",
      stock_alert:"0",
      description: "description",
      image: "assets/myproduct/images.jpg",
      pid: "1236"
  ),
  //=======================Gadgets
  Product(
      name: "Sony Bravia",
      category: "Electronics",
      price: 25000,
      rating: 4.5,
      city: "Mumbai",
      stock:"0",
      stock_alert:"0",
      description: "description",
      image: "",
      pid: "1237"
  ),
  Product(
      name: "Samsung TV",
      category: "Electronics",
      price: 18000,
      rating: 4.5,
      city: "Mumbai",
      stock:"0",
      stock_alert:"0",
      description: "description",
      image: "",
      pid: "1238"
  ),
  Product(
      name: "LG",
      category: "Electronics",
      price: 21000,
      rating: 4.5,
      city: "Chennai",
      stock:"0",
      stock_alert:"0",
      description: "description",
      image: "",
      pid: "1239"
  ),
  Product(
      name: "Sony Bravia",
      category: "Electronics",
      price: 25000,
      rating: 4.5,
      city: "Mumbai",
      stock:"0",
      stock_alert:"0",
      description: "description",
      image: "",
      pid: "12310"
  ),
  //=======================Electronics
  Product(
      name: "Tawel",
      category: "Clothing",
      price: 500,
      rating: 4.0,
      city: "Delhi",
      stock:"0",
      stock_alert:"0",
      description: "description",
      image: "assets/myproduct/cloth1.jpg",
      pid: "12311"
  ),
  Product(
      name: "Tawel Collection",
      category: "Electronics",
      price: 1200,
      rating: 4.3,
      city: "Kolkata",
      stock:"0",
      stock_alert:"0",
      description: "description",
      image: "",
      pid: "12312"
  ),
  Product(
      name: "New Colors",
      category: "Clothing",
      price: 300,
      rating: 3.8,
      city: "Bangalore",
      stock:"0",
      stock_alert:"0",
      description: "description",
      image: "assets/myproduct/cloth2.jpg",
      pid: "12313"
  ),
  Product(
      name: "Product 5",
      category: "Clothing",
      price: 300,
      rating: 3.8,
      city: "Bangalore",
      stock:"0",
      stock_alert:"0",
      description: "description",
      image: "assets/myproduct/cloth3.jpg",
      pid: "12314"
  ),
  //=======================Clothing
];

List<Product> filteredProducts = products;

void filterProducts(
    {String? category,
    double? minPrice,
    double? maxPrice,
    double? minRating,
    String? city}) {
  filteredProducts = products.where((product) {
    final matchCategory = category == null || product.category == category;
    final matchPrice = (minPrice == null || product.price >= minPrice) &&
        (maxPrice == null || product.price <= maxPrice);
    final matchRating = minRating == null || product.rating >= minRating;
    final matchCity = city == null || product.city == city;

    return matchCategory && matchPrice && matchRating && matchCity;
  }).toList();
}

void sortProducts(String sortBy) {
  if (sortBy == "Price Low to High") {
    filteredProducts.sort((a, b) => a.price.compareTo(b.price));
  } else if (sortBy == "Price High to Low") {
    filteredProducts.sort((a, b) => b.price.compareTo(a.price));
  } else if (sortBy == "Rating High to Low") {
    filteredProducts.sort((a, b) => b.rating.compareTo(a.rating));
  }
}

class ProductListPage extends StatefulWidget {
  final String category;

  ProductListPage({required this.category});
  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  String _email = '';

  Future getUserEmail() async {
  final _prefs = await SharedPreferences.getInstance();
  _email = _prefs.getString('userEmail') ?? '';
  setState(() {});
  }

  String? selectedCategory;
  String? selectedCity;
  String? sortBy;
  double? minPrice, maxPrice, minRating;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     getUserEmail();
    setState(() {
      selectedCategory = widget.category;
      filterProducts(
          category: selectedCategory,
          minPrice: minPrice,
          maxPrice: maxPrice,
          minRating: minRating,
          city: selectedCity);
    });
  }

  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    return Scaffold(
      appBar: AppBar(
        title: Text("Product List"),
      ),
      body: Column(
        children: [
// Category Dropdown
          // DropdownButton<String>(
          //   hint: Text("Select Category"),
          //   value: selectedCategory,
          //   items: ["Electronics", "Clothing", "Furniture"].map((category) {
          //     return DropdownMenuItem<String>(
          //       value: category,
          //       child: Text(category),
          //     );
          //   }).toList(),
          //   onChanged: (value) {
          //     setState(() {
          //       selectedCategory = value;
          //     });
          //     filterProducts(
          //         category: selectedCategory,
          //         minPrice: minPrice,
          //         maxPrice: maxPrice,
          //         minRating: minRating,
          //         city: selectedCity);
          //   },
          // ),

// City Dropdown
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: double.infinity,
                decoration:BoxDecoration(  borderRadius:
                                                    BorderRadius.circular(25),
                                                border: Border.all(
                                                    width: 1.5,
                                                    color: Colors.blue)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    elevation: 0,isExpanded: true,
                    hint: Text("Select City"),
                    value: selectedCity,
                    items: ["Mumbai", "Delhi", "Chennai", "Kolkata", "Bangalore"]
                        .map((city) {
                      return DropdownMenuItem<String>(
                        value: city,
                        child: Text(city),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCity = value;
                      });
                      filterProducts(
                          category: selectedCategory,
                          minPrice: minPrice,
                          maxPrice: maxPrice,
                          minRating: minRating,
                          city: selectedCity);
                    },
                  ),
                ),
              ),
            ),
          ),

// Sorting Dropdown
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
               width: double.infinity,
                  decoration:BoxDecoration(  borderRadius:
                                                      BorderRadius.circular(25),
                                                  border: Border.all(
                                                      width: 1.5,
                                                      color: Colors.blue)),
              child: Padding(
               padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    hint: Text("Sort By"),
                    value: sortBy,
                    items: [
                      "Price Low to High",
                      "Price High to Low",
                      "Rating High to Low"
                    ].map((sortOption) {
                      return DropdownMenuItem<String>(
                        value: sortOption,
                        child: Text(sortOption),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        sortBy = value;
                      });
                      sortProducts(sortBy!);
                    },
                  ),
                ),
              ),
            ),
          ),

// Display filtered and sorted products
          Expanded(
            child:  filteredProducts.isEmpty ? Center(child: Text("No Data Found")) : ListView.builder(
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: (){
                    Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ProductPage(_email, product: Products(
              description:  filteredProducts[index].description,
              name:  filteredProducts[index].name,
              price:  filteredProducts[index].price.toString(),
              imgurl:  filteredProducts[index].image,
              categoryId:  "123",
              gst:   "123",
              pid:   filteredProducts[index].pid.toString(),
              stock:"0",
              stock_alert:"0",
              sellerBoost: "123",
              sellerId:  "123",
              )),
          ),
        );
                  },
                  child: ListTile(
                      leading:Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(14),color: Colors.green),
                        height: 70,
                        width: 70,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: filteredProducts[index].image == ""? Icon(Icons.error): Image.asset(filteredProducts[index].image, fit: BoxFit.fill,))),
                    title: Text(filteredProducts[index].name),
                    subtitle: Text(
                        "${filteredProducts[index].price} INR | Rating: ${filteredProducts[index].rating}"),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
