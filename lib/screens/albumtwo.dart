import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pictureapp/screens/add_image.dart';
import 'package:pictureapp/screens/dashboard.dart';
import 'package:pictureapp/services/firebase_services.dart';
import 'package:transparent_image/transparent_image.dart';

class AlbumTwo extends StatefulWidget {
  const AlbumTwo({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AlbumTwoState createState() => _AlbumTwoState();
}

class _AlbumTwoState extends State<AlbumTwo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: const Text('Album Two')),
      body: Column(
        children: [
          const SizedBox(height: 30),
          const Center(
            child: Text('Tap on an image for further settings'),
          ),
          const SizedBox(height: 30),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('imageURLs')
                  .where('album', isEqualTo: '2')
                  .where('userid', isEqualTo: FirebaseServices().getUserId())
                  .snapshots(),
              builder: (context, snapshot) {
                return !snapshot.hasData
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Container(
                        padding: const EdgeInsets.all(4),
                        child: GridView.builder(
                            itemCount: snapshot.data!.docs.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3),
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (context) {
                                        return Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            const SizedBox(
                                              height: 30,
                                            ),
                                            Center(
                                              child: InkWell(
                                                onTap: () {
                                                  FirebaseFirestore.instance
                                                      .collection('imageURLs')
                                                      .doc(snapshot
                                                          .data!.docs[index].id)
                                                      .delete();
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text(
                                                  'Delete',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 30,
                                            ),
                                            Center(
                                              child: InkWell(
                                                onTap: () {
                                                  FirebaseFirestore.instance
                                                      .collection('imageURLs')
                                                      .doc(snapshot
                                                          .data!.docs[index].id)
                                                      .update({'album': '1'});
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text(
                                                  'Move to album One',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 30,
                                            ),
                                            Center(
                                              child: snapshot.data!.docs[index]
                                                          .get('audience')
                                                          .toString() ==
                                                      'private'
                                                  ? InkWell(
                                                      onTap: () {
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'imageURLs')
                                                            .doc(snapshot.data!
                                                                .docs[index].id)
                                                            .update({
                                                          'audience': 'public'
                                                        });
                                                        Navigator.of(context)
                                                            .pop();
                                                        Fluttertoast.showToast(
                                                            msg:
                                                                "Public can now view the post",
                                                            toastLength: Toast
                                                                .LENGTH_LONG,
                                                            gravity:
                                                                ToastGravity
                                                                    .CENTER,
                                                            backgroundColor:
                                                                Colors.blue,
                                                            textColor:
                                                                Colors.white,
                                                            fontSize: 16.0);
                                                      },
                                                      child: const Text(
                                                        'Enable public viewing',
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    )
                                                  : InkWell(
                                                      onTap: () {
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'imageURLs')
                                                            .doc(snapshot.data!
                                                                .docs[index].id)
                                                            .update({
                                                          'audience': 'private'
                                                        });
                                                        Navigator.of(context)
                                                            .pop();
                                                        Fluttertoast.showToast(
                                                            msg:
                                                                "Only you can view this post",
                                                            toastLength: Toast
                                                                .LENGTH_LONG,
                                                            gravity:
                                                                ToastGravity
                                                                    .CENTER,
                                                            backgroundColor:
                                                                Colors.blue,
                                                            textColor:
                                                                Colors.white,
                                                            fontSize: 16.0);
                                                      },
                                                      child: const Text(
                                                        'Make this post private',
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                            ),
                                            const SizedBox(
                                              height: 30,
                                            ),
                                          ],
                                        );
                                      });
                                },
                                child: Container(
                                  margin: const EdgeInsets.all(3),
                                  child: FadeInImage.memoryNetwork(
                                      fit: BoxFit.cover,
                                      placeholder: kTransparentImage,
                                      image: snapshot.data!.docs[index]
                                          .get('url')),
                                ),
                              );
                            }),
                      );
              },
            ),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: InkWell(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Dashboard()),
                    );
                  },
                  child: const Center(child: Text('Back to dashboard')))),
          const SizedBox(
            height: 20,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const UploadScreen(
                          albumtype: '2',
                        )));
              },
              child: Container(
                color: Colors.lightBlue,
                height: 60,
                width: 300,
                child: const Center(
                  child: Text(
                    'Add photo',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
