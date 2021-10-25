import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:phpmysqlcrud/main.dart';

class AddEditPage extends StatefulWidget {
  final List list;
  final int index;
  final String id;
  AddEditPage({ this.list, this.index,this.id});
  @override
  _AddEditPageState createState() => _AddEditPageState();
}

class _AddEditPageState extends State<AddEditPage> {

  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController address = TextEditingController();

  bool editMode = false;


  addUpdateData(){
    if(editMode){
      var url = 'https://iciest-pine.000webhostapp.com/edit.php';
      http.post(Uri.parse(url),body: {
        'id' : widget.list[widget.index]['id'],
        'fistname' : firstName.text,
        'lastname' : lastName.text,
        'phone' : phone.text,
        'address' : address.text,
      });
    }else{
      var url = 'https://iciest-pine.000webhostapp.com/add.php';
      http.post(Uri.parse(url),body: {
        'fistname' : firstName.text,
        'lastname' : lastName.text,
        'phone' : phone.text,
        'address' : address.text,
      });
    }

  }


  @override
  void initState() {
    super.initState();

    if(widget.index != null){
      editMode = true;
      firstName.text = widget.list[widget.index]['fistname'];
      lastName.text = widget.list[widget.index]['lastname'];
      phone.text = widget.list[widget.index]['phone'];
      address.text = widget.list[widget.index]['address'];
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(editMode ? 'Update' :'Add Data'),),
      body: ListView(
        children: <Widget>[

         
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: firstName,
              decoration: InputDecoration(
                labelText: 'First Name',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: lastName,
              decoration: InputDecoration(
                labelText: 'Last Name',
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: phone,
              decoration: InputDecoration(
                labelText: 'Phone',
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: address,
              decoration: InputDecoration(
                labelText: 'Address',
              ),
            ),
          ),

          Padding(padding: EdgeInsets.all(8),
            child: RaisedButton(
              onPressed: (){
                setState(() {
                  addUpdateData();
                });
                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    backgroundColor: Colors.green,
                                    content: Text(
                                        "Item added"),
                                  ),
                                );
                Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage(),),);
                debugPrint('Clicked RaisedButton Button');
              },
              color: Colors.blue,
              child: Text(editMode ? 'Update' :'Save',style: TextStyle(color: Colors.white),),
            ),
          ),
          Padding(padding: EdgeInsets.all(8),
            child: RaisedButton(
              onPressed: (){
                setState(() {
                              var url = 'https://iciest-pine.000webhostapp.com/delete.php';
                              http.post(Uri.parse(url),body: {
                                'id' : widget.list[widget.index]['id'],
                              });


                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    backgroundColor: Colors.red,
                                    content: Text(
                                        "Item deleted"),
                                  ),
                                );
                            debugPrint('delete Clicked');
               // Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage(),),);
               Navigator.pop(context);
                debugPrint('Clicked RaisedButton Button');
              },
              color: Colors.red,
              child: Text('Delete',style: TextStyle(color: Colors.white),),
            ),
          ),
        ],
      ),
    );
  }
}
