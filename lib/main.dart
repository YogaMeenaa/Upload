import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

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
      '/': (context) => MyStatefulWidget(),

      //'/upload': (context) => ImageUploadScreen(),
    }),
  );
}

class MyStatefulWidget extends StatefulWidget {
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
  void _deletePhotoItem(int index) {
    setState(() {
      _items.removeAt(index); // Remove the item from the list
    });
  }

  List<String> selectedPhotographers = [];
  late List<String> allPhotographers;

  @override
  void initState() {
    super.initState();
    // Initialize the list of all photographer names
    allPhotographers = _items.map((item) => item.desc).toSet().toList();
  }

  // ignore: prefer_final_fields
  //bool _isChecked = false;
  bool isFilter = false;

  int selectindex = 0;

  // This function is called whenever the text field changes
  // ignore: non_constant_identifier_names
  void _nameFilter(String enteredKeyword) {
    List<PhotoItem> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = _items;
    } else {
      results = _items
          .where((item) =>
              selectedPhotographers.isEmpty ||
              selectedPhotographers.contains(item.desc))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      filteredItems = results;
    });
    //print(results);
  }

  @override
  Widget build(BuildContext context) {
    List<PhotoItem> filteredItems = _items
        .where((item) =>
            selectedPhotographers.isEmpty ||
            selectedPhotographers.contains(item.desc))
        .toList();

    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(74, 76, 80, 1),
          title: const Text('Gallery'),
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
                            value: selectindex == 0,
                            onChanged: (bool? value) {
                              if (value == true) {
                                selectindex = 0;
                                innerSetState(
                                  () {
                                    _items.sort(
                                        (a, b) => b.date.compareTo(a.date));
                                  },
                                );
                                Navigator.pop(context);
                                // this.selectindex = 0;
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
                            value: selectindex == 1,
                            onChanged: (bool? value) {
                              if (value == true) {
                                selectindex = 1;
                                innerSetState(
                                  () {
                                    _items.sort(
                                        (a, b) => a.date.compareTo(b.date));
                                  },
                                );
                                Navigator.pop(context);
                                //  this.selectindex = 1;
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
                            value: selectindex == 2,
                            onChanged: (bool? value) {
                              if (value == true) {
                                selectindex = 2;
                                //  this.selectindex = 2;
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
                                      _nameFilter(photographer);
                                    } else {
                                      selectedPhotographers
                                          .remove(photographer);
                                      _nameFilter(photographer);
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
          child: Stack(children: [
            GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 0,
                mainAxisSpacing: 0,
                crossAxisCount: 3,
              ),
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                // Assuming _items[index].date is a DateTime object
                String formattedDate =
                    DateFormat('yyyy-MM-dd').format(filteredItems[index].date);
                // Now you can use formattedDate wherever a String is expected

                return Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  PhotoViewPage(photo: filteredItems[index])),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(filteredItems[index].image),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 90,
                      left: 00,
                      right: 00,
                      bottom: 00,
                      child: Container(
                        color: Colors.black.withOpacity(0.5),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              filteredItems[index].name,
                              style: const TextStyle(
                                fontSize: 10,
                                color: Color.fromRGBO(255, 255, 255, 1),

                                //fontWeight: FontWeight.bold
                              ),
                              textAlign: TextAlign.right,
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                "-by ${filteredItems[index].desc}",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 15,
                                    color: Color.fromRGBO(255, 255, 255, 1),
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Text(
                              formattedDate,
                              style: const TextStyle(
                                fontSize: 10,
                                color: Color.fromRGBO(255, 255, 255, 1),
                                //fontWeight: FontWeight.bold
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              filteredItems[index].isLiked =
                                  !filteredItems[index].isLiked;
                            });
                          },
                          child: Icon(
                            filteredItems[index].isLiked
                                ? Icons.favorite
                                : Icons.favorite,
                            color: filteredItems[index].isLiked
                                ? Colors.red
                                : Colors.white,
                            size: 25,
                          ),
                        )),
                    Padding(
                        padding: const EdgeInsets.only(
                            left: 100, top: 5, right: 5, bottom: 90),
                        child: InkWell(
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
                                            color: const Color.fromRGBO(
                                                0, 0, 0, 1),
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    content: SizedBox(
                                      width: 300,
                                      height: 70,
                                      child: Column(children: [
                                        Center(
                                          child: Text(
                                              'Sure you want to delete the selected photo?',
                                              style: GoogleFonts.poppins(
                                                  color: const Color.fromRGBO(
                                                      0, 0, 0, 1),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold)),
                                        )
                                      ]),
                                    ),
                                    contentPadding: const EdgeInsets.all(16.0),
                                    actionsPadding: const EdgeInsets.all(8.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          20.0), // Set border radius here
                                    ),
                                    actions: <Widget>[
                                      ButtonBar(
                                        alignment: MainAxisAlignment.center,
                                        children: [
                                          TextButton(
                                            child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 24.0,
                                                        vertical: 12.0),
                                                decoration: const BoxDecoration(
                                                  color: Color.fromRGBO(
                                                      246,
                                                      143,
                                                      80,
                                                      1), // Background color of the container
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(5.0),
                                                    topRight:
                                                        Radius.circular(5.0),
                                                    bottomLeft:
                                                        Radius.circular(5.0),
                                                    bottomRight:
                                                        Radius.circular(5.0),
                                                  ),
                                                ),
                                                child: Text(
                                                  'CANCEL',
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color:
                                                          const Color.fromRGBO(
                                                              255,
                                                              255,
                                                              255,
                                                              1)),
                                                )),
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pop(); // Close the dialog
                                            },
                                          ),
                                          TextButton(
                                            child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 24.0,
                                                        vertical: 12.0),
                                                decoration: const BoxDecoration(
                                                  color: Color.fromRGBO(
                                                      246,
                                                      80,
                                                      80,
                                                      1), // Background color of the container
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(5.0),
                                                    topRight:
                                                        Radius.circular(5.0),
                                                    bottomLeft:
                                                        Radius.circular(5.0),
                                                    bottomRight:
                                                        Radius.circular(5.0),
                                                  ),
                                                ),
                                                child: Text(
                                                  'DELETE',
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color:
                                                          const Color.fromRGBO(
                                                              255,
                                                              255,
                                                              255,
                                                              1)),
                                                )),
                                            onPressed: () {
                                              _deletePhotoItem(
                                                  index); // Call the delete method
                                              Navigator.of(context)
                                                  .pop(); // Close the dialog
                                            },
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16.0),
                                    ],
                                  );
                                });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            child: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          ),
                        ))
                  ],
                );
              },
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
          ]),
        ));
  }

  Future<void> _showInputDialog(BuildContext context) async {
    TextEditingController textController_1 = TextEditingController();
    TextEditingController textController_2 = TextEditingController();
    TextEditingController textController_3 = TextEditingController();
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: const Text(
              'Add Photo',
              textAlign: TextAlign.center,
            ),
            content: SizedBox(
              width: 1000,
              child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                _buildTextFieldWithTitle('Photographer Name', textController_1),
                _buildTextFieldWithTitle('Image URL', textController_2),
                _buildTextFieldWithTitle('Description', textController_3),
                //const SizedBox(height: 10),
                Center(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: 100, // Set the desired width for the button
                      height: 50, // Set the desired height for the button
                      child: TextButton(
                        onPressed: () {
                          // Handle button press
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              const Color.fromRGBO(246, 143, 80, 1)),
                        ),
                        child: Text(
                          'CANCEL',
                          style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: const Color.fromRGBO(255, 255, 255, 1)),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                      width: 20,
                    ), // Adjust the vertical spacing between buttons if needed
                    SizedBox(
                      width: 100, // Set the same width for the second button
                      height: 50, // Set the same height for the second button
                      child: TextButton(
                        onPressed: () {
                          // Handle button press
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              const Color.fromRGBO(246, 143, 80, 1)),
                        ),
                        child: Text(
                          'ADD',
                          style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: const Color.fromRGBO(255, 255, 255, 1)),
                        ),
                      ),
                    ),
                  ],
                )),
              ]),
            ));
      },
    );
  }
}

class PhotoViewPage extends StatelessWidget {
  final PhotoItem photo;
  const PhotoViewPage({Key? key, required this.photo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Image View✌️'),
        ),
        body: Center(
          child: Stack(
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: SizedBox(
                  width: double.infinity,
                  child: Image(
                    image: NetworkImage(photo.image),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(20.0),
                child: (Column(
                  children: [
                    Text(
                      photo.name,
                      style: const TextStyle(
                          fontSize: 30, fontStyle: FontStyle.italic),
                    ),
                    Text(
                      photo.desc,
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
        children: [
          TableRow(
            children: [
              TableCell(
                  verticalAlignment: TableCellVerticalAlignment.middle,
                  child: Container(
                    width: 150, // Set the desired width for the TableCell
                    height: 50, // Set the desired height for the TableCell
                    padding: const EdgeInsets.all(8.0),
                    child: Text(title,
                        textAlign: TextAlign.left,
                        style: GoogleFonts.poppins(
                          color: const Color.fromRGBO(0, 0, 0, 1),
                          fontSize: 16,
                        )),
                  )),
              TableCell(
                  verticalAlignment: TableCellVerticalAlignment.middle,
                  child: Container(
                    width: 150, // Set the same width for the second TableCell
                    height: 50, // Set the same height for the second TableCell
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: controller,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), hintText: 'Enter Text'),
                      textAlign: TextAlign.center,
                    ),
                  )),
            ],
          ),
        ],
      ));
}
