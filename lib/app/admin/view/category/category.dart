import 'package:ecommerce_int2/app/admin/controller/category_controller.dart';
import 'package:ecommerce_int2/app/admin/view/category/add_category.dart';
import 'package:flutter/material.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Category'),
        centerTitle: true,
      ),
      body: FutureBuilder(
          future: CategoryController.getCategory(),
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
                       child: Center(child: Text('${data[index].category}', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)),
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
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => AddCategory()));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
