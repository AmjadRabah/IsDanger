// ignore_for_file: prefer_const_constructors, unused_local_variable, deprecated_member_use, dead_code

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
//import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_core/firebase_core.dart';
// ignore_for_file: avoid_print, duplicate_ignore, use_key_in_widget_constructors
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
//import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';

String _data = "";
String UserName = "";
String Pass = "";

void main() => runApp(MaterialApp(
      home: Home(),
    ));

// ignore: use_key_in_widget_constructors
class Home extends StatefulWidget {
  @override
  _QrCodeState createState() => _QrCodeState();
}

class _QrCodeState extends State<Home> {
  _scan() async {
    await FlutterBarcodeScanner.scanBarcode(
            "#000000", "Cancel", true, ScanMode.BARCODE)
        .then((value) => setState(() => _data = value));
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // ignore: prefer_const_constructors
          title: Text(
            "Is Danger",
            // ignore: prefer_const_constructors
            style: TextStyle(color: Colors.white),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.admin_panel_settings_sharp,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AdminLogIn()));
              },
            )
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/Photo1.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              RichText(
                textDirection: TextDirection.rtl,
                // ignore: prefer_const_literals_to_create_immutables
                text: TextSpan(children: <TextSpan>[
                  TextSpan(
                      text:
                          "                                                            ",
                      style: TextStyle(fontSize: 30, color: Colors.white)),
                  TextSpan(
                      text:
                          "עובד יקר במקרה של דליפת חומר מסוכן יש ללחוץ על הכפתור ",
                      style: TextStyle(fontSize: 30, color: Colors.white)),
                  TextSpan(
                      text:
                          "                                                             ",
                      style: TextStyle(fontSize: 30, color: Colors.white)),
                  TextSpan(
                      text:
                          "                                                             ",
                      style: TextStyle(fontSize: 30, color: Colors.white)),
                ]),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FlatButton(
                      onPressed: () => _scan(),
                      color: Colors.red,
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        // ignore: prefer_const_literals_to_create_immutables
                        children: <Widget>[
                          Icon(Icons.qr_code_scanner),
                          Text("Scan")
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (_data != "")
                // ignore: deprecated_member_use
                ElevatedButton(
                  // ignore: prefer_const_constructors
                  child: Text("מעבר לתוצאות"),

                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => loadPdf()));
                  },
                ),
              RichText(
                textDirection: TextDirection.rtl,
                // ignore: prefer_const_literals_to_create_immutables
                text: TextSpan(children: <TextSpan>[
                  TextSpan(
                      text:
                          "                                                            ",
                      style: TextStyle(fontSize: 30, color: Colors.white)),
                ]),
              ),
              Image.asset(
                'assets/Photo2.png',
                semanticLabel: 'ISCAR',
              )
            ],
          ),
        ));
  }
}

class AdminLogIn extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<AdminLogIn> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Admin LogIn'),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.home,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Home()));
              },
            )
          ],
        ),
        body: Padding(
            padding: EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[
                Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Sign in',
                      style: TextStyle(fontSize: 20),
                    )),
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    onChanged: (value) {
                      UserName = value;
                    },
                    controller: nameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'User Name',
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: TextField(
                    onChanged: (value) {
                      Pass = value;
                    },
                    obscureText: true,
                    controller: passwordController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                    ),
                  ),
                ),
                Container(
                    height: 50,
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: RaisedButton(
                      textColor: Colors.white,
                      color: Colors.blue,
                      child: Text('Login'),
                      onPressed: () {
                        if (Pass == "IsDanger" && UserName == "IsDanger") {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => _Admin()));
                        } else {
                          showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text('LogIn Filed'),
                              content:
                                  const Text('User Name or Password incorrect'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () => Navigator.pop(context, 'OK'),
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    )),
              ],
            )));
  }
}

class _Admin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Admin Page"),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.home,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Home()));
            },
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/Photo1.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              RichText(
                textDirection: TextDirection.rtl,
                // ignore: prefer_const_literals_to_create_immutables
                text: TextSpan(children: <TextSpan>[
                  TextSpan(
                      text:
                          "                                                            ",
                      style: TextStyle(fontSize: 30, color: Colors.white)),
                  TextSpan(
                      text: " לחץ על + להוספת חומרים חדשים ",
                      style: TextStyle(fontSize: 30, color: Colors.white)),
                ]),
              )
            ]),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () async {
          final path = await FlutterDocumentPicker.openDocument();
          print(path);
          File file = File(path);
          firebase_storage.UploadTask task = await uploadFile(file);
          Navigator.pop(context);
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('upload status'),
              content: const Text('המידע נוסף בהצלחה'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'OK'),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<firebase_storage.UploadTask> uploadFile(File file) async {
    if (file == null) {
      return null;
    }

    firebase_storage.UploadTask uploadTask;
    // Create a Reference to the file
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('files')
        .child('/1035.pdf');

    final metadata = firebase_storage.SettableMetadata(
        contentType: 'application/pdf',
        customMetadata: {'picked-file-path': file.path});
    print("Uploading..!");

    uploadTask = ref.putData(await file.readAsBytes(), metadata);

    print("done..!");
    return Future.value(uploadTask);
  }
}

// ignore: camel_case_types
class loadPdf extends StatefulWidget {
  @override
  _loadPdfState createState() => _loadPdfState();
}

// ignore: camel_case_types
class _loadPdfState extends State<loadPdf> {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future<void> listExample() async {
    firebase_storage.ListResult result = await firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child('files')
        .listAll();

    // ignore: avoid_function_literals_in_foreach_calls, duplicate_ignore
    result.items.forEach((firebase_storage.Reference ref) {
      // ignore: avoid_print
      print('Found file: $ref');
    });

    // ignore: avoid_function_literals_in_foreach_calls
    result.prefixes.forEach((firebase_storage.Reference ref) {
      // ignore: avoid_print
      print('Found directory: $ref');
    });
  }

  Future<void> downloadURLExample() async {
    String downloadURL = await firebase_storage.FirebaseStorage.instance
        .ref('files/' + _data + '.pdf')
        .getDownloadURL();
    print(downloadURL);
    PDFDocument doc = await PDFDocument.fromURL(downloadURL);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ViewPDF(doc))); //Notice the Push Route once this is done.
    _data = "";
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    listExample();
    downloadURLExample();
    print("All done!");
  }

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return CircularProgressIndicator();
  }
}

// ignore: must_be_immutable
class ViewPDF extends StatefulWidget {
  PDFDocument document;
  // ignore: use_key_in_widget_constructors
  ViewPDF(this.document);
  @override
  _ViewPDFState createState() => _ViewPDFState();
}

class _ViewPDFState extends State<ViewPDF> {
  @override
  Widget build(BuildContext context) {
    return Center(child: PDFViewer(document: widget.document));
  }
}
