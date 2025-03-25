import 'package:ecommerce_int2/app/admin/controller/service_controller.dart';
import 'package:ecommerce_int2/app/admin/view/service/add_service.dart';
import 'package:flutter/material.dart';

class ServicePage extends StatefulWidget {
  const ServicePage({super.key});

  @override
  State<ServicePage> createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Service'),
        centerTitle: true,
      ),
      body: FutureBuilder(
          future: ServiceController.getService(),
          builder: (context, AsyncSnapshot snapshot) {
            if(snapshot.hasData) {
              final data = snapshot.data;
              print('$data');
              return ListView.separated(
                itemCount: data.length,
                separatorBuilder: (_, __) => const SizedBox(height: 2,),
                itemBuilder: (_, index) {
                  return Container(
                    padding: EdgeInsets.all(4),
                    margin: EdgeInsets.all(16),
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Center(child: Text('${data[index].service}', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)),
                  );
                },
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => AddService()));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
