import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WishList extends StatefulWidget {
  @override
  _WishListState createState() => _WishListState();
}

class _WishListState extends State<WishList> {
  

  Future getData()async{                                            
    var url = 'https://iciest-pine.000webhostapp.com/wishlistFetch.php';
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
        title: Text('Wishlist',style: TextStyle(
          fontWeight: FontWeight.bold
        )),
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
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    tileColor: Colors.blue[50],
                      leading: GestureDetector(child: Icon(Icons.edit),
                        onTap: (){
                        //   Navigator.push(context, MaterialPageRoute(builder: (context) => AddEditPage(list: list,index: index,id: snapshot.data[index]['id']) ,),);
                        // debugPrint('Edit Clicked');
                      },),
                      title: Text(snapshot.data[index]['wid'].toString()),
                      subtitle: Text(snapshot.data[index]['phone']),
                      trailing: 
                          GestureDetector(child: Icon(Icons.delete,color: Colors.red,),
                            onTap: (){
                              setState(() {
                                var url = 'https://iciest-pine.000webhostapp.com/wishdel.php';
                                http.post(Uri.parse(url),body: {
                                  'wid' : snapshot.data[index]['wid'],
                                });
                              });
                              debugPrint('delete Clicked ${snapshot.data[index]['wid'].toString()}');
                            },),                     
                    ),
                );
              }
          )
              : CircularProgressIndicator();
        },
      ),
    );
  }
}
