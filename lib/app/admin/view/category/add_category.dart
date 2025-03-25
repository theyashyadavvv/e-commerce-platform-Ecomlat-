import 'dart:convert';
import 'package:ecommerce_int2/app/admin/view/category/category.dart';
import 'package:flutter/material.dart';
import '../../../../constants/apiEndPoints.dart';
import 'package:http/http.dart' as http;

class AddCategory extends StatefulWidget {
  const AddCategory({super.key});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  final category = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  _addCategory() async {
    try {
      var res = await http.post(
        Uri.parse(ApiEndPoints.baseURL + ApiEndPoints.add_category),
        body: {
          "name": category.text,
        },
      );
      if (res.statusCode == 200) {
        var jsonResponse = jsonDecode(res.body);
        if (jsonResponse['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Add successfully')),
          );
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => CategoryPage()));
        } else {
          // Handle error
          print("Error: ${jsonResponse['message']}");
        }
      } else {
        print("Server error: ${res.statusCode}");
      }
    } catch (e) {
      // Handle other errors
      print("Error: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add category'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            SizedBox(height: 20,),
            Form(
              key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: TextFormField(
                  controller: category,
                  decoration: InputDecoration(
                    hintText: 'Enter category',
                    label: Text('Category'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0), // Set the border radius
                      borderSide: BorderSide(
                        color: Colors.blue, // Border color
                        width: 2.0, // Border width
                      ),
                      ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter category';
                    }
                    return null; // Return null if the input is valid
                  },
                )
            ),
            SizedBox(
              height: 24,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * .8,
              child: ElevatedButton(
                  onPressed: () async {
                    if(_formKey.currentState!.validate()) {
                      await _addCategory();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please enter credential')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange
                  ),
                  child: Text('Add Category', style: TextStyle(color: Colors.white),)
              ),
            )
          ],
        ),
      ),
    );
  }
}
