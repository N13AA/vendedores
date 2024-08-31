import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:app/app/ui/routes/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

const List<String> list = <String>['Cliente', 'Vendedor'];
const List<String> categories = <String>['Típicos', 'Antojos', 'Panadería', 'Mercadito'];

class Namepage extends StatelessWidget {
  Namepage({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  TextEditingController FirstController = TextEditingController();
  TextEditingController LastController = TextEditingController();
  TextEditingController ShopNameController = TextEditingController();

  Future<void> addData(BuildContext context) async {
    if (dropdownValue == 'Vendedor') {
         var url = Uri.parse("http://192.168.0.189:8081/vendor");
   var requestBody = {
      "FirstName": FirstController.text,
      "LastName": LastController.text,
      "BusinessName":ShopNameController.text,
       "Category": selectedCategory,
    };
     var response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(requestBody),
    );
    

    final Data = jsonDecode(response.body.toString());
    final id = Data['ID'];

    // Guardar el ID en SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await prefs.setString('id', id);
      await prefs.setString('role', dropdownValue);

    // Redirigir al usuario a la página principal
    Navigator.pushReplacementNamed(context, Routes.HOME);
    }
    else {
      var url = Uri.parse("http://192.168.0.189:8081/location");
       var requestBody = {
      "FirstName": FirstController.text,
      "LastName": LastController.text,
      "Role": dropdownValue,
    };
     var response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(requestBody),
    );
    

    final Data = jsonDecode(response.body.toString());
    final id = Data['ID'];

    // Guardar el ID en SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await prefs.setString('id', id);
     await prefs.setString('role', dropdownValue);

    // Redirigir al usuario a la página principal
    Navigator.pushReplacementNamed(context, Routes.HOME);
    }

   
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Enter your name"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: TextFormField(
                    controller: FirstController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), labelText: "Firstname"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your Firstname';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: TextFormField(
                    controller: LastController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), labelText: "Lastname"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your Lastname';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: Seleccion(
                    shopNameController: ShopNameController,
                    onCategorySelected: (category) {
                      selectedCategory = category;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16.0),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          addData(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please fill input')),
                          );
                        }
                      },
                      child: const Text('Submit'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Seleccion extends StatefulWidget {
  final TextEditingController shopNameController;
  final Function(String) onCategorySelected;

  const Seleccion({
    Key? key,
    required this.shopNameController,
    required this.onCategorySelected,
  }) : super(key: key);

  @override
  State<Seleccion> createState() => _SeleccionState();
}
  String dropdownValue = list.first;
  String? selectedCategory;
class _SeleccionState extends State<Seleccion> {
  

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButton<String>(
          value: dropdownValue,
          icon: const Icon(Icons.arrow_downward),
          elevation: 16,
          style: const TextStyle(color: Colors.deepPurple),
          underline: Container(
            height: 2,
            color: Colors.deepPurpleAccent,
          ),
          onChanged: (String? value) {
            setState(() {
              dropdownValue = value!;
            });
          },
          items: list.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        if (dropdownValue == 'Vendedor') ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextFormField(
              controller: widget.shopNameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Nombre de la tienda',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, ingrese el nombre de la tienda';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: DropdownButtonFormField<String>(
              value: selectedCategory,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Categoría del negocio',
              ),
              items: categories.map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  selectedCategory = value;
                });
                widget.onCategorySelected(value!);
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, seleccione una categoría';
                }
                return null;
              },
            ),
          ),
        ],
      ],
    );
  }
}