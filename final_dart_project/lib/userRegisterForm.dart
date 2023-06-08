import 'package:flutter/material.dart';
import 'usersDataControl.dart';

class userRegisterForm extends StatefulWidget {
  var _value;
  // final int _value;
  userRegisterForm({var value}) : _value = value;

  @override
  _userRegisterFormState createState() => _userRegisterFormState();
}

class _userRegisterFormState extends State<userRegisterForm> {
  usersDataControl dc = new usersDataControl();
  var typeOfEditing = "";

  final TextEditingController loginController = TextEditingController();
  final TextEditingController paswController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();

  void initState() {
    super.initState();

    if (widget._value != null) {
      loginController.text = dc.GetItemByUID(int.parse(widget._value))['login'];
      typeOfEditing = "register";
    } else {
      loginController.text = '';
      typeOfEditing = "register";
    }
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Container(),
        title: Text("Register User"),
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
              String res = dc.checkLogin(value.toString());
              if (res !=""){
                return "Login is already used. Choose another login";
              }
              if (value == null || value.isEmpty) {
                return "Login is empty";
              }
              if (!isAlphaNumeric(value)) {
                return "Login must contain only English letters and numbers";
              }
              if (value.length < 3) {
                return "Login must contain at least 3 symbols";
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
              if (!isAlphaNumeric(value)) {
                return "Password must contain only English letters and numbers";
              }
              if (value.length < 3) {
                return "Password must contain at least 3 symbols";
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
              if (!isEnglishName(value)) {
                return "Name must contain only English letters, and the first letter must be capital";
              }
              if (value.length < 3) {
                return "Name must contain at least 3 symbols";
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
              if (!isEnglishName(value)) {
                return "Surname must contain only English letters, and the first letter must be capital";
              }
              if (value.length < 3) {
                return "Surname must contain at least 3 symbols";
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
            child: Text("Back to Authorization"),
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
      Navigator.pushNamed(context, "/2");
    }
  }

  void _btnPress2() {
    dc.deleteItem(int.parse(widget._value));
    Navigator.pushNamed(context, "/");
  }

  bool isAlphaNumeric(String value) {
    final alphaNumericRegex = RegExp(r'^[a-zA-Z0-9]+$');
    return alphaNumericRegex.hasMatch(value);
  }

  bool isEnglishName(String value) {
    final englishNameRegex = RegExp(r'^[A-Z][a-zA-Z]+$');
    return englishNameRegex.hasMatch(value);
  }
}
