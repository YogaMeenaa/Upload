import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

void main() async {
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyBuv5Nka7de9kxlQvXmuFl5hoy5LaGhQGw",
          authDomain: "project-f17a9.firebaseapp.com",
          databaseURL: "https://project-f17a9-default-rtdb.firebaseio.com",
          projectId: "project-f17a9",
          storageBucket: "project-f17a9.appspot.com",
          messagingSenderId: "450708925479",
          appId: "1:450708925479:web:a7fea02e3aaf24f6883202",
          measurementId: "G-8F4JPFH9YL"));
  runApp(
    MaterialApp(debugShowCheckedModeBanner: false, initialRoute: '/', routes: {
      '/': (context) => const MyStatefulWidget(),
    }),
  );
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({super.key});

  @override
  HomeGallery createState() => HomeGallery();
}

class PhotoItem {
  final String image;
  final String name;
  final String desc;
  bool isLiked;
  final DateTime date;

  PhotoItem(
    this.image,
    this.name,
    this.desc,
    this.isLiked,
    this.date,
  );
}

List<PhotoItem> filteredItems = [];

final List<PhotoItem> _items = [
  PhotoItem(
    "https://images.pexels.com/photos/1772973/pexels-photo-1772973.png?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
    "Beautiful Evening",
    "Anand",
    false,
    DateTime(2023, 9, 1),
  ),
  PhotoItem(
    "https://images.pexels.com/photos/1758531/pexels-photo-1758531.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
    "Liam Gant",
    "Soorya",
    false,
    DateTime(2023, 9, 7),
  ),
  PhotoItem(
    "https://images.pexels.com/photos/1130847/pexels-photo-1130847.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
    "Stephan Seeber",
    "Yoga",
    false,
    DateTime(2023, 9, 11),
  ),
  PhotoItem(
    "https://images.pexels.com/photos/45900/landscape-scotland-isle-of-skye-old-man-of-storr-45900.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
    "Pixabay",
    "Ram",
    false,
    DateTime(2023, 9, 2),
  ),
  PhotoItem(
    "https://images.pexels.com/photos/165779/pexels-photo-165779.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
    "Scott Webb",
    "Arjun",
    false,
    DateTime(2023, 9, 31),
  ),
  PhotoItem(
    "https://images.pexels.com/photos/548264/pexels-photo-548264.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
    "Krivec Ales",
    "Vinay",
    false,
    DateTime(2023, 10, 1),
  ),
  PhotoItem(
    "https://images.pexels.com/photos/188973/matterhorn-alpine-zermatt-mountains-188973.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
    "Pixabay",
    "Pixiee",
    false,
    DateTime(2023, 8, 1),
  ),
  PhotoItem(
    "https://images.pexels.com/photos/795188/pexels-photo-795188.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
    "Melanie Wupper",
    "Roopa",
    false,
    DateTime(2023, 1, 1),
  ),
  PhotoItem(
    "https://images.pexels.com/photos/5222/snow-mountains-forest-winter.jpg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
    "Jaymantri",
    "Jaya",
    false,
    DateTime(2023, 2, 2),
  ),
  PhotoItem(
    "https://images.pexels.com/photos/789381/pexels-photo-789381.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
    "Riciardus",
    "Riya",
    false,
    DateTime(2023, 3, 6),
  ),
  PhotoItem(
    "https://images.pexels.com/photos/326119/pexels-photo-326119.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
    "Pixabay",
    "Suja",
    false,
    DateTime(2021, 9, 1),
  ),
  PhotoItem(
    "https://images.pexels.com/photos/707344/pexels-photo-707344.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
    "Eberhard",
    "Herald ",
    false,
    DateTime(2022, 9, 1),
  ),
  PhotoItem(
    "https://images.pexels.com/photos/691034/pexels-photo-691034.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
    "Mirsad Mujanovic",
    "Pickty",
    false,
    DateTime(2020, 9, 1),
  ),
  PhotoItem(
    "https://images.pexels.com/photos/655676/pexels-photo-655676.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
    "Vittorio Staffolani",
    "Veera",
    false,
    DateTime(2023, 9, 10),
  ),
  PhotoItem(
    "https://images.pexels.com/photos/592941/pexels-photo-592941.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
    "Tobi",
    "Dobi",
    false,
    DateTime(2023, 10, 1),
  ),
];

class HomeGallery extends State<MyStatefulWidget> {
  List<String> selectedPhotographers = [];
  late List<String> allPhotographers;

  @override
  void initState() {
    super.initState();
    // Initialize the list of all photographer names

    _fetchPhotographers();
    // allPhotographers = _items.map((item) => item.desc).toSet().toList();
  }

  Future<void> _fetchPhotographers() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('images')
        .snapshots()
        .first; // Using first to get the initial snapshot
    allPhotographers =
        snapshot.docs.map((doc) => doc['photographerName'] as String).toList();
  }

  int _selectindex = 0;

  // This function is called whenever the text field changes
  // ignore: non_constant_identifier_names
  // void _nameFilter(String enteredKeyword) {
  //   List<String> results = [];
  //   if (enteredKeyword.isEmpty) {
  //     // if the search field is empty or only contains white-space, we'll display all users
  //     results = allPhotographers;
  //   } else {
  //     var desc;
  //     results = allPhotographers
  //         .where((item) =>
  //             selectedPhotographers.isEmpty ||
  //             selectedPhotographers.contains(item.desc))
  //         .toList();
  //     // we use the toLowerCase() method to make it case-insensitive
  //   }

  //   // Refresh the UI
  //   setState(() {
  //     filteredItems = results.cast<PhotoItem>();
  //   });
  //   //print(results);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(74, 76, 80, 1),
          title: const Text('Photo Gallery'),
          actions: [
            PopupMenuButton(
              icon: const Icon(Icons.sort),
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem(
                    key: UniqueKey(),
                    value: "date desc",
                    child: StatefulBuilder(
                      builder:
                          (BuildContext context, StateSetter innerSetState) {
                        return Row(children: [
                          Checkbox(
                            value: _selectindex == 0,
                            onChanged: (bool? value) {
                              if (value == true) {
                                _selectindex = 0;
                                innerSetState(
                                  () {
                                    _items.sort(
                                        (a, b) => b.date.compareTo(a.date));
                                  },
                                );
                                Navigator.pop(context);
                              }

                              setState(() {});
                            },
                          ),
                          Text('Time Latest First',
                              style: GoogleFonts.poppins(
                                  color: const Color.fromRGBO(0, 0, 0, 1),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                        ]);
                      },
                    ),
                  ),
                  PopupMenuItem(
                    key: UniqueKey(),
                    value: "date asc",
                    child: StatefulBuilder(
                      builder:
                          (BuildContext context, StateSetter innerSetState) {
                        return Row(children: [
                          Checkbox(
                            value: _selectindex == 1,
                            onChanged: (bool? value) {
                              if (value == true) {
                                _selectindex = 1;
                                innerSetState(
                                  () {
                                    _items.sort(
                                        (a, b) => a.date.compareTo(b.date));
                                  },
                                );
                                Navigator.pop(context);
                              }

                              innerSetState(
                                () {},
                              );
                              setState(() {});
                            },
                          ),
                          Text('Time Latest Last',
                              style: GoogleFonts.poppins(
                                  color: const Color.fromRGBO(0, 0, 0, 1),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                        ]);
                      },
                    ),
                  ),
                  PopupMenuItem(
                    key: UniqueKey(),
                    value: "name",
                    child: StatefulBuilder(
                      builder:
                          (BuildContext context, StateSetter innerSetState) {
                        return Row(children: [
                          Checkbox(
                            value: _selectindex == 2,
                            onChanged: (bool? value) {
                              if (value == true) {
                                _selectindex = 2;

                                innerSetState(
                                  () {
                                    _items.sort(
                                        (a, b) => a.desc.compareTo(b.desc));
                                  },
                                );
                                Navigator.pop(context);
                              }
                              innerSetState(
                                () {},
                              );

                              setState(() {});
                            },
                          ),
                          Text('Name',
                              style: GoogleFonts.poppins(
                                  color: const Color.fromRGBO(0, 0, 0, 1),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                        ]);
                      },
                    ),
                  ),
                ];
              },
            ),
            PopupMenuButton(
              icon: const Icon(Icons.filter_list),
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem(
                    child: StatefulBuilder(
                      builder: (
                        BuildContext context,
                        StateSetter innerSetState,
                      ) {
                        return Column(
                          children: allPhotographers.map((photographer) {
                            return Row(children: [
                              Checkbox(
                                value: selectedPhotographers
                                    .contains(photographer),
                                // Text(photographer),
                                onChanged: (bool? value) {
                                  innerSetState(() {
                                    if (value == true) {
                                      selectedPhotographers.add(photographer);
                                      //  print(selectedPhotographers);
                                      setState(() {});
                                      // _nameFilter(photographer);
                                      ImageGrid(photo: selectedPhotographers);
                                    } else {
                                      selectedPhotographers
                                          .remove(photographer);
                                      setState(() {});
                                      // ImageGrid(selectedPhotographers);
                                      // _nameFilter(photographer);
                                      ImageGrid(photo: selectedPhotographers);
                                    }
                                    //  print(selectedPhotographers);
                                  });
                                },
                              ),
                              Text(photographer,
                                  style: GoogleFonts.poppins(
                                      color: const Color.fromRGBO(0, 0, 0, 1),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                            ]);
                          }).toList(),
                        );
                      },
                    ),
                  ),
                ];
              },
            ),
          ],
        ),
        body: Center(
          child: Stack(
            children: [
              ImageGrid(
                photo: const [],
              ),
              Positioned(
                // padding: const EdgeInsets.only(bottom: 5, right: 5),
                bottom: 16.0, // Adjust the position from the bottom as needed
                right: 16.0,
                child: FloatingActionButton(
                  onPressed: () {
                    // Handle the button press to upload a file
                    // You can add your upload logic here
                    _showInputDialog(context);
                  },
                  backgroundColor: const Color.fromRGBO(246, 143, 80,
                      1), // Change the background color of the button
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        30.0), // Round the edges of the button
                  ),
                  child: const Icon(Icons.add),
                ),
              ),
            ],
          ),
        ));
  }
}

// ignore: must_be_immutable
class ImageGrid extends StatelessWidget {
  // HomeGallery homeGallery = HomeGallery();

  DateTime? timestamp;

  List photo;
  // List selectedphotographer;
  ImageGrid({super.key, required this.photo});

  @override
  Widget build(BuildContext context) {
    //print(photo);
    Query query = FirebaseFirestore.instance.collection('images');
    if (photo.isNotEmpty) {
      query = query.where('photographerName', whereIn: photo);
    }

    return StreamBuilder(
      stream: query.snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text('No images available.'),
          );
        }

        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: MediaQuery.of(context).size.width > 600 ? 5 : 3,
          ),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var document = snapshot.data!.docs[index];
            var id = document.id;
            var imageUrl = document['photoURL'] as String;
            var imageName = document['photographerName'] as String;
            var isLiked = document['isLiked'] as bool;
            var desc = document['description'] as String;
            var timestampFromFirestore = document['createdTime'] as Timestamp?;
            timestamp = timestampFromFirestore?.toDate();

            String formattedDate =
                DateFormat('dd MMM, yyyy').format(timestamp!);
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    12.0), // Adjust corner radius as needed
              ),
              child: Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PhotoViewPage(
                            id: id,
                            imageUrl: imageUrl,
                            description: desc,
                            photographerName: imageName,
                            isLiked: isLiked,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            12.0), // Adjust corner radius as needed
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(imageUrl),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          bool updatedLikeStatus = !isLiked;
                          FirebaseFirestore.instance
                              .collection('images')
                              .doc(document.id)
                              .update({'isLiked': updatedLikeStatus});
                        },
                        child: Icon(
                          isLiked ? Icons.favorite : Icons.favorite,
                          color: isLiked ? Colors.red : Colors.white,
                          size: 25,
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () {
                          // Add your delete logic here
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Center(
                                  child: Text(
                                    'Confirm',
                                    style: GoogleFonts.poppins(
                                      color: const Color.fromRGBO(0, 0, 0, 1),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                content: SizedBox(
                                  width: 300,
                                  height: 70,
                                  child: Column(
                                    children: [
                                      Center(
                                        child: Text(
                                          'Sure you want to delete the selected photo?',
                                          style: GoogleFonts.poppins(
                                            color: const Color.fromRGBO(
                                                0, 0, 0, 1),
                                            fontSize: 16,
                                            // fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                contentPadding: const EdgeInsets.all(16.0),
                                actionsPadding: const EdgeInsets.all(8.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                actions: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(
                                        width: 120.0, // Set the desired width
                                        height: 40.0, // Set the desired height
                                        child: TextButton(
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pop(); // Close the dialog
                                          },
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                        Color>(
                                                    const Color.fromRGBO(
                                                        246, 143, 80, 1)),
                                          ),
                                          child: const Text(
                                            'CANCEL',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Color.fromRGBO(
                                                  255, 255, 255, 1),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 50,
                                        width: 10,
                                      ),
                                      SizedBox(
                                        width: 120.0, // Set the desired width
                                        height: 40.0, // Set the desired height
                                        child: TextButton(
                                          onPressed: () {
                                            _deleteImage(document.id);
                                            Navigator.of(context).pop();
                                          },
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                        Color>(
                                                    const Color.fromRGBO(
                                                        246, 80, 80, 1)),
                                          ),
                                          child: const Text(
                                            'DELETE',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Color.fromRGBO(
                                                  255, 255, 255, 1),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: SizedBox(
                      height: 75,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        color: Colors.black.withOpacity(0.5),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Description
                            Text(
                              desc,
                              style: const TextStyle(
                                fontSize: 10,
                                color: Color.fromRGBO(255, 255, 255, 1),
                              ),
                              textAlign: TextAlign.right,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            // Row with Date and Image Name
                            Row(
                              children: [
                                // Date
                                Expanded(
                                  child: Text(
                                    formattedDate,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: Color.fromRGBO(255, 255, 255, 1),
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                // Image Name
                                Expanded(
                                  child: Text(
                                    "-by $imageName",
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Color.fromRGBO(255, 255, 255, 1),
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _deleteImage(String documentId) async {
    try {
      await FirebaseFirestore.instance
          .collection('images')
          .doc(documentId)
          .delete();
      // print('Image deleted successfully');
    } catch (error) {
      //  print('Error deleting image: $error');
    }
  }
}

// ignore: must_be_immutable
class PhotoViewPage extends StatelessWidget {
  String description, photographerName, id, imageUrl;
  bool isLiked;

  //final PhotoItem photo;
  PhotoViewPage(
      {Key? key,
      required this.id,
      required this.photographerName,
      required this.imageUrl,
      required this.description,
      required this.isLiked})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(74, 76, 80, 1),
          title: const Text('Image View'),
        ),
        body: Center(
          child: Stack(
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: SizedBox(
                  width: double.infinity,
                  child: Image(
                    image: NetworkImage(imageUrl),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(20.0),
                child: (Column(
                  children: [
                    Text(
                      photographerName,
                      style: const TextStyle(
                          fontSize: 30, fontStyle: FontStyle.italic),
                    ),
                    Text(
                      description,
                      style: const TextStyle(fontSize: 10),
                    ),
                  ],
                )),
              ),
            ],
          ),
        ));
  }
}

Widget _buildTextFieldWithTitle(
    String title, TextEditingController controller) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Table(
      columnWidths: const {
        0: FlexColumnWidth(), // Let the first column take available width
        1: FlexColumnWidth(), // Let the second column take available width
      },
      children: [
        TableRow(
          children: [
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  title,
                  textAlign: TextAlign.left,
                  style: GoogleFonts.poppins(
                    color: const Color.fromRGBO(0, 0, 0, 1),
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter Text',
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

// class _UploadScreen extends StatefulWidget {
//   @override
//   _UploadScreenState createState() => _UploadScreenState();
// }

// class _UploadScreenState extends State<_UploadScreen> {
final TextEditingController _photographerController = TextEditingController();
final TextEditingController _photoUrlController = TextEditingController();
final TextEditingController _dateController = TextEditingController();
final TextEditingController _descriptionController = TextEditingController();

Future<void> _uploadToFirestore() async {
  try {
    await FirebaseFirestore.instance.collection('images').add({
      'photographerName': _photographerController.text,
      'photoURL': _photoUrlController.text,
      'createdTime': Timestamp.now(),
      'description': _descriptionController.text,
      'isLiked': false,
    });

    // Clear the text controllers after uploading
    _photographerController.clear();
    _photoUrlController.clear();
    _dateController.clear();
    _descriptionController.clear();
  } catch (error) {
    //print('Error uploading data: $error');
  }
}

Future<void> _showInputDialog(BuildContext context) async {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
          title: const Text('Add Photo',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              )),
          content: SizedBox(
            width: 400,
            height: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _buildTextFieldWithTitle(
                    'Photographer Name', _photographerController),
                _buildTextFieldWithTitle('Image URL', _photoUrlController),
                _buildTextFieldWithTitle('Description', _descriptionController),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: 120.0, // Set the desired width
                      height: 40.0, // Set the desired height
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              const Color.fromRGBO(246, 143, 80, 1)),
                        ),
                        child: const Text(
                          'CANCEL',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(255, 255, 255, 1),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                      width: 10,
                    ),
                    SizedBox(
                      width: 120.0, // Set the desired width
                      height: 40.0, // Set the desired height
                      child: TextButton(
                        onPressed: () {
                          _uploadToFirestore();
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              const Color.fromRGBO(246, 143, 80, 1)),
                        ),
                        child: const Text(
                          'ADD',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(255, 255, 255, 1),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ));
    },
  );
}
