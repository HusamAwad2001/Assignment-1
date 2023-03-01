import 'package:assignment_1/text_field_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddUserData extends StatefulWidget {
  const AddUserData({Key? key}) : super(key: key);

  @override
  State<AddUserData> createState() => _AddUserDataState();
}

class _AddUserDataState extends State<AddUserData> {
  final _nameController = TextEditingController();
  final _numberController = TextEditingController();
  final _addressController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add User'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFieldWidget(
                controller: _nameController,
                hintText: 'Name',
                validation: 'Please enter your name',
              ),
              const SizedBox(height: 10),
              TextFieldWidget(
                controller: _numberController,
                keyboardType: TextInputType.number,
                hintText: 'Number',
                validation: 'Please enter your number',
              ),
              const SizedBox(height: 10),
              TextFieldWidget(
                controller: _addressController,
                hintText: 'Address',
                validation: 'Please enter your address',
              ),
              const SizedBox(height: 20),
              isLoading
                  ? const Center(
                child: CircularProgressIndicator(),
              )
                  : ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text('Save'),
                onPressed: (){
                  setState(() {
                    performData();
                  });
                },
              ),
            ],
          ).paddingSymmetric(horizontal: 15, vertical: 25),
        ),
      ),
    );
  }

  void performData() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        saveData();
      });
    }
  }

  Future<void> saveData() async {
    FocusNode().requestFocus();
    isLoading = true;
    await FirebaseFirestore.instance.collection('UsersData').add(
      {
        'name': _nameController.text.trim().toString(),
        'number': _numberController.text.trim().toString(),
        'address': _addressController.text.trim().toString(),
      },
    ).then((value) {
      Get.back();
      setState(() {
        isLoading = false;
        _numberController.clear();
        _nameController.clear();
        _addressController.clear();
      });
    });
  }
}
