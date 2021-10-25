import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:phpmysqlcrud/AddEditPage.dart';
import 'package:phpmysqlcrud/wishlist.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,

        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}


class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Future getData()async{                                            
    var url = 'https://iciest-pine.000webhostapp.com/read.php';
    var response = await http.get(Uri.parse(url));
    return json.decode(response.body);
  }
  

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
  
    var size =MediaQuery.of(context).size;
    return Scaffold(
      
      appBar: AppBar(
        
        actions: [
          IconButton(onPressed: (){ Navigator.push(context, MaterialPageRoute(builder: (context) => WishList(),),);
          }, icon: Icon(Icons.shopping_cart))
        ],
        title: Text('DYNMAC',style: TextStyle(
          fontWeight: FontWeight.bold
        ),),
        centerTitle: true,

      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddEditPage(),),);
          debugPrint('Clicked FloatingActionButton Button');
        },
      ),
      body: FutureBuilder(
        future: getData(),
        builder: (context,snapshot){
          if(snapshot.hasError) print(snapshot.error);
          return snapshot.hasData
              ? ListView.builder(
              itemCount: snapshot.data.length,
              
              itemBuilder: (context,index){
                Object list = snapshot.data; 
                return ListTile(
                    leading: GestureDetector(child: Icon(Icons.edit),
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AddEditPage(list: list,index: index,id: snapshot.data[index]['id']) ,),);
                      debugPrint('Edit Clicked');
                    },),
                    title: Text(snapshot.data[index]['lastname']),
                    subtitle: Text(snapshot.data[index]['phone']),
                    trailing: 
                        GestureDetector(child: Icon(Icons.add),
                          onTap: (){
                            // setState(() {
                            //   var url = 'https://iciest-pine.000webhostapp.com/delete.php';
                            //   http.post(Uri.parse(url),body: {
                            //     'id' : snapshot.data[index]['id'],
                            //   });
                            // });

                            var url = 'https://iciest-pine.000webhostapp.com/wishlist.php';
                            http.post(Uri.parse(url),body: {
                              'pid' : snapshot.data[index]['id'],
                              'uid' : snapshot.data[index]['id'],
                             
                            });

                            ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    backgroundColor: Colors.green,
                                    content: Text(
                                        "Added to wishlist"),
                                  ),
                                );
                            debugPrint('list Clicked');
                          },),

                         
                     
                  );
              }
          )
              : CircularProgressIndicator();
        },
      ),
    );
  }
}
