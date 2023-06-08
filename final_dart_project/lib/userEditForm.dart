import 'package:flutter/material.dart';
import 'usersDataControl.dart';

class userEditForm extends StatefulWidget {
  var _value;

  userEditForm({var value}) : _value = value;

  @override
  _ElementFormState createState() => _ElementFormState();
}

class _ElementFormState extends State<userEditForm> {
  var uid;
  usersDataControl dc = usersDataControl();
  var typeOfEditing = "";

  final TextEditingController loginController = TextEditingController();
  final TextEditingController paswController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();

  void initState() {
    super.initState();

    if (widget._value != null) {
      loginController.text = dc.GetItemByUID(int.parse(widget._value))['login'];
      paswController.text = dc.GetItemByUID(int.parse(widget._value))['pasw'];
      nameController.text = dc.GetItemByUID(int.parse(widget._value))['name'];
      surnameController.text = dc.GetItemByUID(int.parse(widget._value))['surname'];
      typeOfEditing = "save";
    } else {
      loginController.text = '';
      typeOfEditing = "save";
    }
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Container(),
        title: Text("Edit User"),
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.face),
              hintText: "Login",
            ),
            controller: loginController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Login is empty";
              }
              if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)) {
                return "Login can only contain English letters and numbers";
              }
              if (value.length < 3) {
                return "Login must contain at least 3 characters";
              }
              return null;
            },
          ),
          SizedBox(height: 10),
          TextFormField(
            obscureText: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.password),
              hintText: "Password",
            ),
            controller: paswController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Password is empty";
              }
              if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)) {
                return "Password can only contain English letters and numbers";
              }
              if (value.length < 3) {
                return "Password must contain at least 3 characters";
              }
              return null;
            },
          ),
          SizedBox(height: 10),
          TextFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person),
              hintText: "Name",
            ),
            controller: nameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Name is empty";
              }
              if (!RegExp(r'^[A-Z][a-zA-Z]*$').hasMatch(value)) {
                return "Name must start with a capital letter and only contain English letters";
              }
              if (value.length < 3) {
                return "Name must contain at least 3 characters";
              }
              return null;
            },
          ),
          SizedBox(height: 10),
          TextFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person),
              hintText: "Surname",
            ),
            controller: surnameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Surname is empty";
              }
              if (!RegExp(r'^[A-Z][a-zA-Z]*$').hasMatch(value)) {
                return "Surname must start with a capital letter and only contain English letters";
              }
              if (value.length < 3) {
                return "Surname must contain at least 3 characters";
              }
              return null;
            },
          ),
          SizedBox(height: 10),
          ElevatedButton(
            child: Text(typeOfEditing),
            onPressed: _btnPress,
          ),
          SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: Text("back to menu"),
            onPressed: _btnPress2,
          ),
        ],
      ),
    );
  }

  void _btnPress() {
    if (_formKey.currentState!.validate()) {
      dc.saveItem(
        int.parse(widget._value),
        loginController.text,
        paswController.text,
        nameController.text,
        surnameController.text,
      );
      dc.printData();
      uid = widget._value;
      Navigator.pushNamed(context, "/menu/$uid");
    }
  }

  void _btnPress2() {
    uid = widget._value;
    Navigator.pushNamed(context, "/menu/$uid");
  }
}
