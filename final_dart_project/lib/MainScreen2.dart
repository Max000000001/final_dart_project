import 'dart:js';
import 'package:flutter/material.dart';
import 'RestartWidget.dart';
import 'usersDataControl.dart';
import 'authControl.dart';

var uid;

class MainScreen2 extends StatelessWidget {
  authControl ac = new authControl();

  @override
  Widget build(BuildContext context) {
    return showAuthForm(context);
  }

  Widget showAuthForm(BuildContext context){
    final TextEditingController loginController = TextEditingController();
    final TextEditingController paswController = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Container(),
        title: Text("Authorization"),
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: _buildContent(context),
      ),
    );
  }
  Widget _buildContent(BuildContext context) {
    final TextEditingController loginController = TextEditingController();
    final TextEditingController paswController = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    return Form(
        key: _formKey,
        child: Column(
          children: [
            Text("You have been registered. Now you can enter the site with your login and password",
                style: TextStyle(color: Colors.green)),
            SizedBox(height: 10),

            TextFormField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.face),
                  hintText: "Login"
              ),
              controller: loginController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Login is empty";
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
                  hintText: "Password"
              ),
              controller: paswController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Password is empty";
                }
                if (value.length < 3) {
                  return "Password must contain at least 3 symbols";
                }
                return null;
              },
            ),

            SizedBox(height: 10),

            ElevatedButton(
              child: Text('Login'),
              onPressed: ()=>{
                checkLogin(loginController.text, paswController.text, context),
                RestartWidget.restartApp(context),
              },
            ),

            SizedBox(height: 10),

            ElevatedButton(
              child: Text('Register'),
              onPressed: ()=>{
                dc.IncreaseUID(),
                uid = dc.GetUID(),
                dc.addItem(uid, loginController.text, paswController.text, "name", "surname"),
                Navigator.pushNamed(context, "/elementForm/$uid"),
              },
            ),

          ],
        )
    );
  }
  usersDataControl dc = new usersDataControl();
  void checkLogin(String login, String pasw, BuildContext context){
    String res = dc.checkUser(login, pasw);
    if(res!=""){
      ac.makeAuth(res);
      uid = dc.GetItemByLogin(login)["uid"];
      Navigator.pushNamed(context, '/menu/$uid');
    }
    else {
      Navigator.pushNamed(context, '/3');
    }
  }

}



