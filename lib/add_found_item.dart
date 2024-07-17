import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'home.dart';

class AddFound extends StatefulWidget {
  @override
  _TambahDataFoundState createState() => _TambahDataFoundState();
}

class _TambahDataFoundState extends State<AddFound> {
  TextEditingController idController = TextEditingController();
  TextEditingController namaController = TextEditingController();
  TextEditingController deskripsiController = TextEditingController();
  File? _imageFile;
  final picker = ImagePicker();

  Future pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<String> uploadImage(File imageFile) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference ref = FirebaseStorage.instance.ref().child('uploads').child(fileName);
    UploadTask uploadTask = ref.putFile(imageFile);
    TaskSnapshot taskSnapshot = await uploadTask;
    return await taskSnapshot.ref.getDownloadURL();
  }

  void addData() async {
    if (_imageFile != null) {
      String imageUrl = await uploadImage(_imageFile!);

      DocumentReference documentReference = FirebaseFirestore.instance.collection('item_found').doc(idController.text);

      // create Map to send data in key:value pair form
      Map<String, dynamic> mtr = ({
        "id": idController.text,
        "nama": namaController.text,
        "deskripsi": deskripsiController.text,
        "image": imageUrl
      });

      // send data to Firebase
      documentReference.set(mtr).whenComplete(() => print('${idController.text} created'));
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Home()),
        (Route<dynamic> route) => false,
      );
    } else {
      print('No image selected.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Found Item"),
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: ListView(
          children: <Widget>[
            Text(
              "ITEMS FOUND",
              style: TextStyle(
                color: Colors.blue,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            TextFormField(
              controller: idController,
              decoration: InputDecoration(
                labelText: "ID Item",
              ),
            ),
            TextFormField(
              controller: namaController,
              decoration: InputDecoration(labelText: "Nama"),
            ),
            TextFormField(
              controller: deskripsiController,
              decoration: InputDecoration(labelText: "Deskripsi"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: pickImage,
              child: Text("Pilih Gambar"),
            ),
            _imageFile != null
                ? Image.file(_imageFile!)
                : Text("Tidak ada gambar yang dipilih."),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: addData,
              child: Text("Simpan"),
            ),
          ],
        ),
      ),
    );
  }
}
