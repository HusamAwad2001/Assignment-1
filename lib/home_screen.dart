import 'package:assignment_1/add_user_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:assignment_1/text_field_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assignment 1'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(const AddUserData()),
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: StreamBuilder(
          stream: _fireStore.collection('UsersData').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasData) {
              return snapshot.data!.docs.isNotEmpty
                  ? ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        return Card(
                          color: Colors.blue.withOpacity(.2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            title: Text(
                                'Name: ${snapshot.data!.docs[index]['name']}\n\nNumber: ${snapshot.data!.docs[index]['number']}\n\nAddress: ${snapshot.data!.docs[index]['address']}'),
                            trailing: IconButton(
                              onPressed: () {
                                deleteUserData(snapshot.data!.docs[index].id);
                              },
                              icon: const Icon(Icons.delete, color: Colors.red),
                            ),
                          ).paddingAll(10),
                        ).paddingSymmetric(horizontal: 5);
                      },
                    )
                  : const Center(
                      child: Text(
                        'No Data',
                        style: TextStyle(fontSize: 18),
                      ),
                    );
            } else {
              return const Center(child: Text('Something went wrong!'));
            }
          },
        ),
      ),
    );
  }

  Future<bool> deleteUserData(String id) async {
    return await _fireStore
        .collection('UsersData')
        .doc(id)
        .delete()
        .then((value) => true)
        .catchError((error) => false);
  }
}
