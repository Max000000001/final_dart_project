import 'package:flutter/material.dart';
import 'usersDataControl.dart';
import 'customersDataControl.dart';

class customerAddForm extends StatefulWidget {
  @override
  var _value;

  customerAddForm({var value}):_value = value;

  _elementFormState createState() => _elementFormState();
  getValue(){
    // print("_value = ${_value}");
    return _value;
  }

}

bool isValidPhoneNumber(String phoneNumber) {
  final RegExp phoneRegex = RegExp(r'^8-9\d{2}-\d{3}-\d{2}-\d{2}$');
  return phoneRegex.hasMatch(phoneNumber);
}

bool isValidEmail(String email) {
  final RegExp emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$');
  return emailRegex.hasMatch(email);
}

bool isAlphaWithSpaces(String value) {
  final alphaRegex = RegExp(r'^[a-zA-Z\s]+$');
  return alphaRegex.hasMatch(value);
}


class _elementFormState extends State<customerAddForm> {
  var uid;
  usersDataControl dc = new usersDataControl();
  customersDataControl dcC = new customersDataControl();
  var typeOfEditing = "";

  final TextEditingController loginController = TextEditingController();
  final TextEditingController paswController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController infoController = TextEditingController();
  void initState(){
    super.initState();

    if (widget._value!=null){
      loginController.text = dcC.GetItemByCID(int.parse(widget._value))['FIO'];
      paswController.text = dcC.GetItemByCID(int.parse(widget._value))['phoneNumber'];
      subjectController.text = dcC.GetItemByCID(int.parse(widget._value))['email'];
      infoController.text = dcC.GetItemByCID(int.parse(widget._value))['info'];
      typeOfEditing = "save";
    }
    else{
      loginController.text='';
      typeOfEditing = "new";
    }
    // print(widget._value);
  }
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Container(),
        title: Text("Add customer"),
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
              prefixIcon: Icon(Icons.person),
              hintText: "FIO",
            ),
            controller: loginController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "FIO is empty";
              }
              if (!isAlphaWithSpaces(value)) {
                return "FIO must contain only english letters and spaces";
              }
              if (value.length < 10) {
                return "FIO must contain at least 10 symbols";
              }
              return null;
            },
          ),
          SizedBox(height: 10),

          TextFormField(
            // obscureText: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.phone),
              hintText: "Phone number",
            ),
            controller: paswController,
            validator: (value){
              if (value == null || value.isEmpty) {
                return "Phone number is empty";
              }
              if (value.length < 11){
                return "Phone number must contain at least 11 symbols";
              }
              return null;
            },
          ),

          SizedBox(height: 10),

          TextFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.email),
              hintText: "Email",
            ),
            controller: subjectController,
            validator: (value){
              if (value == null || value.isEmpty) {
                return "Email is empty";
              }
              if (value.length < 10){
                return "Email must contain at least 10 symbols";
              }
              return null;
            },
          ),

          SizedBox(height: 10),

          TextFormField(
            minLines: 6,
            maxLines: null,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              alignLabelWithHint: true,
              border: OutlineInputBorder(),
              labelText: 'Additional info about customer',
            ),
            controller: infoController,
          ),

          SizedBox(height: 10),

          ElevatedButton(
            child: Text(typeOfEditing),
            onPressed: _btnPress,
          ),
          SizedBox(height: 10),
          ElevatedButton(
            // selectionColor: Colors.red ,
              child: Text("delete", ),
              onPressed: _btn2Press,
              style: ElevatedButton.styleFrom(
                primary: Colors.red,)
          ),
        ],
      ),
    );
  }

  void _btn2Press(){
    dcC.deleteItem(int.parse(widget._value));
    uid = dc.GetCurrentUID();
    Navigator.pushNamed(context, "/elementListCustomers/$uid");
  }

  void _btnPress() {
    if (_formKey.currentState!.validate()) {
      if (!isValidPhoneNumber(paswController.text)) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Invalid Phone Number"),
              content: Text("Please enter a valid phone number in the format: 8-9XX-XXX-XX-XX"),
              actions: [
                TextButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
        return;
      }

      if (!isValidEmail(subjectController.text)) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Invalid Email"),
              content: Text("Please enter a valid email address"),
              actions: [
                TextButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
        return;
      }

      // Proceed with saving the data
      if (typeOfEditing == "new") {
        dc.saveItem(
          int.parse(widget._value),
          loginController.text,
          paswController.text,
          subjectController.text,
          infoController.text,
        );
      } else if (typeOfEditing == "save") {
        dcC.saveItem(
          int.parse(widget._value),
          loginController.text,
          paswController.text,
          subjectController.text,
          infoController.text,
        );
      }

      dcC.printData();
      uid = dc.GetCurrentUID();
      Navigator.pushNamed(context, "/elementListCustomers/$uid");
    }
  }

}








//