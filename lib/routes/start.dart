import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_editor_plus/image_editor_plus.dart';
import 'package:image_editor_plus/utils.dart';
import 'package:path_provider/path_provider.dart';
import '../constants/colors.dart';
import 'package:image_picker/image_picker.dart';

class Start extends StatefulWidget {
  const Start({Key? key}) : super(key: key);

  @override
  State<Start> createState() => _Start();
}

class _Start extends State<Start> {
  var imgFile;
  bool okimg = false;
  bool okedit = false;

  //IMAGE SELECT==================================
  Future getImg(ImageSource source) async {
    try {
      final image =
          await ImagePicker().pickImage(source: source, imageQuality: 75);
      if (image == null) return;
      File? img = File(image.path);
      Uint8List imageRaw = await img.readAsBytes();
      setState(() {
        imgFile = imageRaw;
        okimg = true;
        // Navigator.of(context).pop();
      });
    } on PlatformException catch (e) {
      print(e);
      setState(() {
        okimg = false;
      });
      Navigator.of(context).pop();
      print("####### ERROR IAMGE #####");
    }
  }

  Future<void> getImgEditor() async {
    EasyLoading.showSuccess("You can Edit Now!");

    final geteditimage =
        Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ImageEditor(
        image: imgFile,
      );
    })).then((geteditimage) {
      if (geteditimage != null) {
        setState(() {
          imgFile = geteditimage;
          okedit = true;
        });
      }
    }).catchError((er) {
      print(er);
    });
  }

  Future<void> save() async {
    print(imgFile.runtimeType);

    Directory appDocDirectory = await getApplicationDocumentsDirectory();

    Directory(appDocDirectory.path + '/' + 'dir')
        .create(recursive: true)
        .then((Directory directory) async {
      print('Path of New Dir: ' + directory.path);
      File ans = await File(directory.path + '/edit.jpg').writeAsBytes(imgFile);

      GallerySaver.saveImage(ans.path);
    });
  }

  //-------------------------------------------
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    EasyLoading.dismiss();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => exit(context),
      child: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/splash/splash_bg.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                "inEDIT",
              ),
              titleTextStyle: TextStyle(
                  color: ColorsFile.colorwhite,
                  fontSize: 26,
                  fontWeight: FontWeight.bold),
              centerTitle: true,
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.06,
                child: !okedit
                    ? ElevatedButton(
                        onPressed: () async {
                          print("------ EDIT PRESSED----------");

                          if (imgFile != null) {
                            getImgEditor();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Please Select an Image!"),
                            ));
                            EasyLoading.showError('Failed to Load, Try Again');
                            EasyLoading.dismiss();
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.edit,
                              size: 25,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.02,
                            ),
                            const Text(
                              'Edit',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        style: ElevatedButton.styleFrom(
                          shape: const StadiumBorder(),
                          elevation: 5,
                          primary: okimg ? Colors.red : Colors.grey,
                          shadowColor: ColorsFile.colorblack,
                        ),
                      )
                    : ElevatedButton(
                        onPressed: () async {
                          print("------ START AGAIN PRESSED----------");

                          setState(() {
                            okedit = false;
                            imgFile = null;
                            okimg = false;
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.restart_alt,
                              size: 25,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.02,
                            ),
                            const Text(
                              'Start Again',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        style: ElevatedButton.styleFrom(
                          shape: const StadiumBorder(),
                          elevation: 5,
                          primary: okimg ? Colors.red : Colors.grey,
                          shadowColor: ColorsFile.colorblack,
                        ),
                      ),
              ),
            ),
            backgroundColor: ColorsFile.colorwhite,
            body: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/splash/splash_bg.png"),
                      fit: BoxFit.cover)),
              child: Center(
                  child: SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.03,
                      ),
                      !okedit
                          ? Text(
                              "Select an Image",
                              style: TextStyle(
                                  fontSize: 32,
                                  color: Colors.amber,
                                  fontWeight: FontWeight.bold),
                            )
                          : Text(
                              "Edit Done!",
                              style: TextStyle(
                                  fontSize: 32,
                                  color: Colors.amber,
                                  fontWeight: FontWeight.bold),
                            ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      imgFile != null
                          ? Image.memory(
                              imgFile!,
                              height: MediaQuery.of(context).size.height * 0.5,
                              width: MediaQuery.of(context).size.width * 0.8,
                              fit: BoxFit.contain,
                            )
                          : Container(
                              height: MediaQuery.of(context).size.height * 0.3,
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(20), // Image border
                                child: SizedBox.fromSize(
                                  size: Size.fromRadius(48), // Image radius
                                  child: Image.asset('assets/images/logo2.png',
                                      fit: BoxFit.cover),
                                ),
                              )),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      okedit
                          ? ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.purple,
                                onPrimary: Colors.grey,
                                shadowColor: Colors.grey[400],
                                elevation: 8,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0)),
                              ),
                              onPressed: () async {
                                print("SAVING IMAGE");
                                save();
                                EasyLoading.showSuccess("Image Saved!");
                              },
                              child: Container(
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Icon(
                                        Icons.save_alt,
                                        size: 40,
                                        color: ColorsFile.colorwhite,
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.01,
                                      ),
                                      Text(
                                        "SAVE EDIT",
                                        style: TextStyle(
                                            fontSize: 13, color: Colors.amber),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: ColorsFile.colorblue,
                                    onPrimary: Colors.grey,
                                    shadowColor: Colors.grey[400],
                                    elevation: 8,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0)),
                                  ),
                                  onPressed: () {
                                    getImg(ImageSource.gallery);
                                  },
                                  child: Container(
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.image,
                                            size: 40,
                                            color: ColorsFile.colorwhite,
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.01,
                                          ),
                                          Text(
                                            "Use Gallery",
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.amber),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                )),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.08,
                                ),
                                Container(
                                    child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: ColorsFile.colorblue,
                                    onPrimary: Colors.grey,
                                    shadowColor: Colors.grey[400],
                                    elevation: 8,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0)),
                                  ),
                                  onPressed: () {
                                    getImg(ImageSource.camera);
                                  },
                                  child: Container(
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.camera_alt,
                                            size: 40,
                                            color: ColorsFile.colorwhite,
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.01,
                                          ),
                                          Text(
                                            "Use Camera",
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.amber),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                )),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.2,
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
              )),
            ),
          ),
        ),
      ),
    );
  }
}

//EXIT POPUP
Future<bool> exit(BuildContext context) async {
  return await showDialog(
    builder: (context) => AlertDialog(
      title: Text("Exit !"),
      content: Text("Confirm, you want to quit inEDIT?"),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: Text("Yes")),
        TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text("No")),
      ],
    ),
    context: context,
  );
}
