import 'dart:convert';
import 'package:ecommerce_int2/app/admin/view/service/service.dart';
import 'package:flutter/material.dart';
import '../../../../constants/apiEndPoints.dart';
import 'package:http/http.dart' as http;

class AddService extends StatefulWidget {
  const AddService({super.key});

  @override
  State<AddService> createState() => _AddServiceState();
}

class _AddServiceState extends State<AddService> {
  final service = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  _addService() async {
    try {
      var res = await http.post(
        Uri.parse(ApiEndPoints.baseURL + ApiEndPoints.add_service),
        body: {
          "name": service.text,
          "seller_id": "2",
        },
      );
      if (res.statusCode == 200) {
        var jsonResponse = jsonDecode(res.body);
        if (jsonResponse['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Add successfully')),
          );
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => ServicePage()));
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
        title: Text('Add service'),
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
                  controller: service,
                  decoration: InputDecoration(
                    hintText: 'Enter service',
                    label: Text('Service'),
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
                      return 'Please enter service';
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
                      await _addService();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please enter credential')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange
                  ),
                  child: Text('Add Service', style: TextStyle(color: Colors.white),)
              ),
            )
          ],
        ),
      ),
    );
  }
}
