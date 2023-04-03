import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io' as io;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

  class DownloadImage extends StatefulWidget {
  const DownloadImage({super.key, required this.title});

  final String title;

  @override
  State<DownloadImage> createState() => _MyDownloadImage();
  }

  class _MyDownloadImage extends State<DownloadImage> {
    final user = FirebaseAuth.instance.currentUser!;
    int _counter = 0;

    String allimage = "";
  void _incrementCounter() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      dialogTitle: 'Выбор файла',
    );
    if (result != null) {
      final size = result.files.first.size;
      final file = io.File(result.files.single.path!);
      final fileExtensions = result.files.first.extension!;
      final nameimage = getRandomString(5);
      allimage = nameimage;
      print("размер:$size file:${file.path} fileExtensions:${fileExtensions}");

      //Добавление пользователя
      addUserDetails(
        nameimage,
        file.path,
        fileExtensions,
        link,
      );

      FirebaseStorage.instance.ref().child(user.uid).child(nameimage).putFile(file);
    } else {}
  }

    Future addUserDetails(String name, String path, String size, String link) async{
      final user1 = FirebaseAuth.instance.currentUser!;
      print(user1);
      await FirebaseFirestore.instance.collection("users").doc(user1.email).collection(allimage).add({
        "name": name,
        "path": path,
        "size": size,
        "link": link,
      });
      allimage = "";
    }

  String link = '';
  List<ModelTest> fullpath = [];

  final _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();
  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  Future<void> initImage() async {
    fullpath.clear();
    final storageReference = FirebaseStorage.instance.ref(user.uid).list();
    final list = await storageReference;
    list.items.forEach((element) async {
      final url = await element.getDownloadURL();
      fullpath.add(ModelTest(url, element.name));
      setState(() {});
    });
  }

  @override
  void initState() {
    initImage().then(
          (value) {},
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(widget.title),
        actions: [
          IconButton(
              onPressed: () async {
                await initImage();
              },
              icon: Icon(Icons.refresh)),
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: Icon(Icons.logout)),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: ListView.builder(
                itemCount: fullpath.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: InkWell(
                      onLongPress: () async {
                        link = '';
                        await FirebaseStorage.instance
                            .ref("/" + fullpath[index].name)
                            .delete();
                        await initImage();
                        setState(() {});
                      },
                      onTap: () {
                        setState(() {
                          link = fullpath[index].url;
                        });
                      },
                      child: ListTile(
                        title: Text(fullpath[index].name),
                      ),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              flex: 2,
              child: Image.network(
                link,
                errorBuilder: (context, error, stackTrace) {
                  return Text('Выберите файл!');
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
class ModelTest {
  final String url;
  final String name;

  ModelTest(this.url, this.name);
}