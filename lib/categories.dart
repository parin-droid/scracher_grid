import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';


class CategoriesPage extends StatefulWidget {

  const CategoriesPage({Key? key}) : super(key: key);

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  static List<Animal> animals = [Animal(Id: 1 , name: "Lion"),
    Animal(Id: 2 , name: "Tiger"),
    Animal(Id: 3 , name: "cat"),
    Animal(Id: 4 , name: "Dog"),
    Animal(Id: 5 , name: "Zebra"),
    Animal(Id: 6 , name: "Owl"),
    Animal(Id: 7 , name: "Horse"),];

  final items = animals.map((e) => MultiSelectItem(e, e.name)).toList();
  List<MultiSelectItem> selectedAnimals = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Category" , style: TextStyle(color: Colors.black ,fontSize: 20, fontWeight: FontWeight.bold, ),),
              SizedBox(height: 10,),
              MultiSelectDialogField(items: items,
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(20)
                  ),
                  title: Text("Category"),
                  onConfirm: (results){
                selectedAnimals.contains(results)? selectedAnimals.remove(items): null;

              })
            ],
          ),
        ),
      ),
    );
  }

}
class Animal {
  final int Id;
  final String name;
    Animal({required this.Id,required this.name});
}