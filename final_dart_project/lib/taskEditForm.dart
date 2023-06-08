import 'package:flutter/material.dart';
import 'usersDataControl.dart';
import 'tasksDataControl.dart';
import 'customersDataControl.dart';
import 'dart:async';

class taskEditForm extends StatefulWidget {
  @override
  var _value;

  taskEditForm({var value}):_value = value;

  _elementFormState createState() => _elementFormState();
  getValue(){
    return _value;
  }
}

class _elementFormState extends State<taskEditForm> {
  var uid;
  usersDataControl dc = new usersDataControl();
  tasksDataControl dc2 = new tasksDataControl();
  customersDataControl dcC = new customersDataControl();
  var typeOfEditing = "";

  String? selectedCustomer;
  List<String> listOfCustomers = [];

  String? selectedProduct;
  List<String> listOfProducts = ['Product 1', 'Product 2', 'Product 3', 'Product 4'];

  List<String> statusOptions = ['Created', 'Producing', 'Delivering', 'Completed', 'Cancelled'];
  String? selectedStatus;

  final TextEditingController customerController = TextEditingController();
  final TextEditingController productController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController statusController = TextEditingController();
  DateTime? selectedDate; // Добавлено для хранения выбранной даты

  void initState(){
    super.initState();

    dcC = customersDataControl(); // Создание экземпляра dcC

    if (widget._value != null){
      var item = dc2.GetItemByTID(int.parse(widget._value));
      // customerController.text = item['customer'];
      // productController.text = item['product'];
      quantityController.text = item['quantity'];
      selectedDate = DateTime.parse(item['deadline']); // Установка выбранной даты
      selectedStatus = item['status'];
      selectedCustomer = item['customer'];
      selectedProduct = item['product'];
      typeOfEditing = "save";
    } else {
      typeOfEditing = "new";
    }

    initializeA(); // Вызов метода initializeA() для заполнения списка listOfCustomers
  }

  void initializeA() {
    listOfCustomers = dcC.returnFIOsOfCustomers(); // Присваивание значений из dcC.returnFIOsOfCustomers()
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit task"),
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent(){
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
                hintText: "Customer",
              ),
              value: selectedCustomer,
              onChanged: (String? newValue) {
                setState(() {
                  selectedCustomer = newValue;
                });
              },
              items: listOfCustomers.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              validator: (value) {
                print(listOfCustomers);
                if (listOfCustomers.isEmpty){
                  return "There are no customers registered. Before creating task you must register at least one customer";
                }
                if (value == null || value.isEmpty){
                  return "Customer is empty";
                }
                return null;
              },
            ),
          ),

          SizedBox(height: 10),

          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.production_quantity_limits),
              hintText: "Product",
            ),
            value: selectedProduct,
            onChanged: (String? newValue) {
              setState(() {
                selectedProduct = newValue;
              });
            },
            items: listOfProducts.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            validator: (value){
              if (value == null || value.isEmpty) {
                return "Product is empty";
              }
              return null;
            },
          ),

          SizedBox(height: 10),

          TextFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.numbers),
              hintText: "Amount",
            ),
            controller: quantityController,
            keyboardType: TextInputType.number,
            validator: (value){
              if (value == null || value.isEmpty) {
                return "Amount is empty";
              }
              final intValue = int.tryParse(value);
              if (intValue == null || intValue < 1 || intValue > 100) {
                return "Amount must be an integer between 1 and 100";
              }
              return null;
            },
          ),

          SizedBox(height: 10),

          InkWell(
            onTap: () {
              _selectDate(context); // Открывает диалог выбора даты
            },
            child: InputDecorator(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.date_range),
                hintText: "Deadline",
              ),
              child: Text(selectedDate != null
                  ? "${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}"
                  : "Select date"), // Отображает выбранную дату или текст "Select date"
            ),
          ),

          SizedBox(height: 10),

          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.mode),
              hintText: "Status",
            ),
            value: selectedStatus,
            onChanged: (String? newValue) {
              setState(() {
                selectedStatus = newValue;
              });
            },
            items: statusOptions.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            validator: (value){
              if (value == null || value.isEmpty) {
                return "Status is empty";
              }
              return null;
            },
          ),

          SizedBox(height: 10),

          ElevatedButton(
            child: Text(typeOfEditing),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _btnPress();
              }
            },
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now().add(Duration(days: 1)), // Задайте первую доступную дату - завтрашнюю дату
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _btn2Press(){
    dc2.deleteItem(int.parse(widget._value));
    uid = dc.GetCurrentUID();
    Navigator.pushNamed(context, "/elementList2/$uid");
  }

  void _btnPress(){
    dc2.saveItem(
      int.parse(widget._value),
      selectedCustomer ?? '',
      selectedProduct ?? '',
      quantityController.text,
      selectedDate?.toIso8601String() ?? '', // Сохраняет выбранную дату в формате ISO 8601
      selectedStatus ?? '',
    );
    dc2.printData();
    uid = dc.GetCurrentUID();
    Navigator.pushNamed(context, "/elementList2/$uid");
  }
}
