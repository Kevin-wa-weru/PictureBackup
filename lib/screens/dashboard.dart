import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pictureapp/screens/albumone.dart';
import 'package:pictureapp/screens/albumtwo.dart';
import 'package:pictureapp/services/firebase_services.dart';
import 'package:transparent_image/transparent_image.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<Map<dynamic, dynamic>> imageOne = [];
  List<Map<dynamic, dynamic>> imageTwo = [];
  // ignore: prefer_typing_uninitialized_variables
  var album;

  bool appisLoading = false;

  Future fetchFirstImages() async {
    setState(() {
      appisLoading = true;
    });

    QuerySnapshot<Map<String, dynamic>> albumOne = await FirebaseFirestore
        .instance
        .collection('imageURLs')
        .where('album', isEqualTo: '1')
        .where('userid', isEqualTo: FirebaseServices().getUserId())
        .limit(1)
        .get();

    QuerySnapshot<Map<String, dynamic>> albumTwo = await FirebaseFirestore
        .instance
        .collection('imageURLs')
        .where('album', isEqualTo: '2')
        .where('userid', isEqualTo: FirebaseServices().getUserId())
        .limit(1)
        .get();

    for (album in albumOne.docs) {
      setState(() {
        imageOne.add(album.data());
      });
    }

    for (album in albumTwo.docs) {
      setState(() {
        imageTwo.add(album.data());
      });
    }

    setState(() {
      appisLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();

    fetchFirstImages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Dashboard'),
          automaticallyImplyLeading: false,
        ),
        body: appisLoading == false
            ? Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  const Center(
                    child: Text(
                      'Select Album to add photo',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const AlbumOne()),
                            );
                          },
                          child: Container(
                            height: 200,
                            width: 150,
                            color: Colors.grey,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 170,
                                  child: Container(
                                      margin: const EdgeInsets.all(3),
                                      child: imageOne.isNotEmpty
                                          ? FadeInImage.memoryNetwork(
                                              fit: BoxFit.cover,
                                              placeholder: kTransparentImage,
                                              image: imageOne[0]['url'])
                                          : const Center(
                                              child: Text('Tap to add'))),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Center(
                                  child: Text(
                                    'Album One',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const AlbumTwo()),
                            );
                          },
                          child: Container(
                            height: 200,
                            width: 150,
                            color: Colors.grey,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 170,
                                  child: Container(
                                      margin: const EdgeInsets.all(3),
                                      child: imageTwo.isNotEmpty
                                          ? FadeInImage.memoryNetwork(
                                              fit: BoxFit.cover,
                                              placeholder: kTransparentImage,
                                              image: imageTwo[0]['url'])
                                          : const Center(
                                              child: Text('Tap to add'))),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Center(
                                  child: Text(
                                    'Album Two',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Center(
                    child: Text(
                      'Public Posts Appear Below',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('imageURLs')
                          .where('audience', isEqualTo: 'public')
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
                                      return Container(
                                        margin: const EdgeInsets.all(3),
                                        child: FadeInImage.memoryNetwork(
                                            fit: BoxFit.cover,
                                            placeholder: kTransparentImage,
                                            image: snapshot.data!.docs[index]
                                                .get('url')),
                                      );
                                    }),
                              );
                      },
                    ),
                  ),
                ],
              )
            : const Center(child: CircularProgressIndicator()));
  }
}
