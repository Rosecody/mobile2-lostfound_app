import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'home.dart';

class EditDataLost extends StatefulWidget {
  final String? id;
  final String? nama;
  final String? deskripsi;
  
  EditDataLost({this.id, this.nama, this.deskripsi});

  @override
  _EditDataLostState createState() => _EditDataLostState();
}

class _EditDataLostState extends State<EditDataLost> {
  TextEditingController idController = new TextEditingController();
  TextEditingController namaController = new TextEditingController();
  TextEditingController deskripsiController = new TextEditingController();
  File? _imageFile;
  final picker = ImagePicker();
  bool _isUploading = false;

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
    Reference ref = FirebaseStorage.instance.ref().child('edited').child(fileName);
    UploadTask uploadTask = ref.putFile(imageFile);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    return await taskSnapshot.ref.getDownloadURL();
  }

  void editData() async {
    setState(() {
      _isUploading = true;
    });

    String imageUrl = "";
    if (_imageFile != null) {
      imageUrl = await uploadImage(_imageFile!);
    }

    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('item_lost').doc(widget.id);

    Map<String, dynamic> newData = {
      "id": widget.id,
      "nama": namaController.text,
      "deskripsi": deskripsiController.text,
      "image": imageUrl,
    };

    // update data to Firestore
    await documentReference.update(newData);

    setState(() {
      _isUploading = false;
    });

    print('${widget.id} updated');
  }

  void deleteData() {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('item_lost').doc(widget.id);

    // delete data from Firestore
    documentReference
        .delete()
        .whenComplete(() => print('${widget.id} deleted'));
  }

  void konfirmasi() {
    AlertDialog alertDialog = AlertDialog(
      content: Text("Apakah anda yakin akan menghapus data '${widget.nama}'"),
      actions: <Widget>[
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
          ),
          child: Text(
            "OK DELETE!",
            style: TextStyle(color: Colors.black),
          ),
          onPressed: () {
            deleteData();
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => Home()),
              (Route<dynamic> route) => false,
            );
          },
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
          ),
          child: Text("CANCEL", style: TextStyle(color: Colors.black)),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alertDialog;
      },
    );
  }

  @override
  void initState() {
    idController = TextEditingController(text: widget.id);
    namaController = TextEditingController(text: widget.nama);
    deskripsiController = TextEditingController(text: widget.deskripsi);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Lost Item"),
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: ListView(
          children: <Widget>[
            Text(
              "ITEMS LOST",
              style: TextStyle(
                color: Colors.red,
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
                labelText: "Id Items",
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
            SizedBox(
              height: 20,
            ),
            _imageFile == null
                ? ElevatedButton(
                    onPressed: pickImage,
                    child: Text("Pilih Gambar"),
                  )
                : Column(
                    children: [
                      Image.file(_imageFile!),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: pickImage,
                        child: Text("Ganti Gambar"),
                      ),
                    ],
                  ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                  onPressed: _isUploading ? null : editData,
                  child: _isUploading
                      ? CircularProgressIndicator()
                      : Text("Edit"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  onPressed: konfirmasi,
                  child: Text("Delete"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
