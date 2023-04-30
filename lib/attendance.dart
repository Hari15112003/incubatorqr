import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:ui' as ui;
import 'dart:math' as math;

class Attendance extends StatefulWidget {
  const Attendance({super.key});

  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  //FirebaseFirestore
  var collection =
      FirebaseFirestore.instance.collection('batches').doc('rhcsa2002a1');

  //search Contoller
  TextEditingController editingController = TextEditingController();

  //colors for checkbox
  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return Colors.green;
  }

  //colors for the containers
  List items = [
    [Color.fromARGB(255, 117, 191, 226), Color(0xff73A1F9)],
    [Color(0xffFFB157), Color(0xffFFA057)],
    [Color(0xffD76895), Color(0xff8F7AFE)],
    [Colors.pink, Colors.red],
    [
      Color(0xff42E695),
      Color(0xff388288),
    ],
  ];

//
  var a;

  //boolean for attendance
  bool? attenbool;

  void dispose() {
    super.dispose();
    editingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //phone ratio by using mediaquery
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Attendance".toUpperCase()),
          centerTitle: true,
        ),
        body: Column(children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              "Total no of students Absent: 13",
              style: TextStyle(fontSize: 21),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Padding(
                  padding:
                      EdgeInsets.only(left: 12, top: 8, bottom: 10, right: 12),
                  child: TextField(
                    controller: editingController,
                    onChanged: (value) {
                      String date = editingController.text.trim();
                      editingController.clear();
                      collection.update({'your_field_name': value});
                    },
                    decoration: InputDecoration(
                      hintText: 'Search',
                      labelText: 'Search',
                      suffixIcon: IconButton(

                          // Icon to
                          icon: Icon(Icons.clear), // clear text
                          onPressed: () {
                            setState(() {
                              editingController.clear();
                            });
                          }),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: StreamBuilder(
              stream: collection.get().asStream(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  a = snapshot.data!
                      .data()!['attendence']['22/04/2003']!
                      .values!
                      .toList();
                  print(a);
                  var b = snapshot.data!.data()!['attendence']['22/04/2003'];
                  return ListView.builder(
                      itemCount: a.length,
                      itemBuilder: (context, index) {
                        final attenbool = a[index].values.toList()[0];
                        var name = a[index].keys.toList()[0];
                        int indexOfList = index;
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Stack(
                            children: [
                              Container(
                                height: height * 0.15,
                                width: width,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: items[indexOfList],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: items[indexOfList][1],
                                      blurRadius: 12,
                                      offset: Offset(0, 6),
                                    )
                                  ],
                                  borderRadius: BorderRadius.circular(19),
                                ),
                              ),
                              Positioned(
                                right: 0,
                                bottom: 0,
                                top: height * 0.0001,
                                child: CustomPaint(
                                  size: Size(100, 150),
                                  painter: Custompaint(
                                      12,
                                      items[indexOfList][0],
                                      items[indexOfList][1]),
                                ),
                              ),
                              Positioned(
                                left: width * 0.02,
                                top: height * 0.03,
                                child: CircleAvatar(
                                  radius: 40,
                                ),
                              ),
                              Positioned(
                                top: 10,
                                left: width * 0.20,
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text(
                                    name.toUpperCase(),
                                    style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 10,
                                bottom: 10,
                                right: 20,
                                child: Checkbox(
                                  checkColor: Colors.white,
                                  splashRadius: 25,
                                  fillColor: MaterialStateProperty.resolveWith(
                                      getColor),
                                  value: attenbool,
                                  onChanged: (bool? value) {},
                                ),
                              ),
                              Positioned(
                                bottom: width * 0.08,
                                left: height * 0.14,
                                child: Text("23"),
                              ),
                              Positioned(
                                bottom: height * 0.01,
                                left: width * 0.20,
                                child: const Text(
                                  "Absent count",
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ],
                          ),
                        );
                      });
                } else {
                  return SizedBox();
                }
              },
            ),
          ),
        ]),
      ),
    );
  }
}

class PlaceInfo {
  PlaceInfo(this.startColor, this.endColor);
  final Color startColor;
  final Color endColor;
}

class Custompaint extends CustomPainter {
  final double radius;
  final Color startColor;
  final Color endColor;
  Custompaint(this.radius, this.startColor, this.endColor);
  @override
  void paint(Canvas canvas, Size size) {
    var radius = 24.0;
    var paint = Paint();
    paint.shader = ui.Gradient.linear(
        Offset(0, 0), Offset(size.width, size.height), [
      HSLColor.fromColor(startColor).withLightness(0.8).toColor(),
      endColor
    ]);
    var path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width - radius, size.height)
      ..quadraticBezierTo(
          size.width, size.height, size.width, size.height - radius)
      ..lineTo(size.width, radius)
      ..quadraticBezierTo(size.width, 0, size.width - radius, 0)
      ..lineTo(size.width - 1.5 * radius, 0)
      ..quadraticBezierTo(-radius, 2 * radius, 0, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}


// //attendance [ helper method]
// Widget atten(width, height, name, attendbool) {
//   return Padding(
//       padding: EdgeInsets.all(12),
//       child: Container(
//         padding: EdgeInsets.all(12),
//         height: height * 0.14,
//         width: width,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(15),
//           color: Color.fromARGB(255, 207, 178, 176),
//         ),
//         child: Stack(
//           children: [
//             Align(
//               alignment: Alignment.centerLeft,
//               child: CircleAvatar(
//                 radius: 40,
//               ),
//             ),
//             Positioned(
//               left: width * 0.2,
//               child: Padding(
//                 padding: const EdgeInsets.all(12.0),
//                 child: Text(
//                   name.toUpperCase(),
//                   style: TextStyle(
//                       fontSize: 20,
//                       color: Colors.white,
//                       fontWeight: FontWeight.w600),
//                 ),
//               ),
//             ),
//             Align(
//               alignment: Alignment(1.0, 0.2),
//               child: Checkbox(
//                 checkColor: Colors.white,
//                 splashRadius: 25,
//                 fillColor: MaterialStateProperty.resolveWith(getColor),
//                 value: attenbool,
//                 onChanged: (bool? value) {
//                   setState(() {
//                     attenbool = value!;
//                     print(attenbool);
//                   });
//                 },
//               ),
//             ),
//             Positioned(
//               bottom: width * 0.08,
//               left: height * 0.14,
//               child: Text("23"),
//             ),
//             Positioned(
//               bottom: height * 0.01,
//               left: width * 0.2,
//               child: Text(
//                 "Absent count:",
//                 style: TextStyle(
//                     fontSize: 18,
//                     color: Colors.white,
//                     fontWeight: FontWeight.w400),
//               ),
//             ),
//           ],
//         ),
//       ));

// import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';

// //attendance page
// class page1 extends StatefulWidget {
//   const page1({super.key});

//   @override
//   State<page1> createState() => _page1State();
// }

// class _page1State extends State<page1> {
//   var Batch = "BAtch1";
//   final TextEditingController editingController = TextEditingController();
//   var fieldText = TextEditingController();

//   int absent = 12;
//   int a = 1;

//   List names = [
//     ["Harshani", false],
//     ["Shivni", false],
//     ["Sibisurya The Boss", true],
//     ["Vimalaj", false],
//     ["Bharathraj", false],
//     ["Haisharajan", true],
//     ["ShivaPrasth", false],
//     ["Harsharjan N", true],
//     ["ShivPrasath ", false],
//     ["Sibiurya", false],
//     ["Vimaaj", false],
//     ["Bharthraj", false],
//     ["Harsharjan N", true],
//     ["ShivPrasath ", false],
//     ["Sibiurya", false],
//     ["Vimaaj", false],
//     ["Bharthraj", false],
//   ];

//   //  List <Colors> c = [Colors.pink[200],"Colors.blue","Colors.red","Colors.green"];

// void checkboxchange(bool? value, index) {
//   setState(() {
//     names[index][1] = !names[index][1];
//   });
// }

//   Color getColor(Set<MaterialState> states) {
//     const Set<MaterialState> interactiveStates = <MaterialState>{
//       MaterialState.pressed,
//       MaterialState.hovered,
//       MaterialState.focused,
//     };
//     if (states.any(interactiveStates.contains)) {
//       return Colors.blue;
//     }
//     return Colors.red;
//   }

//   List attandance = [];
//   @override
//   void initState() {
//     // TODO: implement initState
//     //at beginning all are displayed
//     attandance = names;
//     super.initState();
//   }

//   void _runFilter(String enteredKeyword) {
    // List results = [];
//     if (enteredKeyword.isEmpty) {
//       // if the search field is empty or only contains white-space, we'll display all users
//       results = names;
//     }
//     // else if (a == 0) {
//     //   results = names; //[CHECK IT ERROR]
//     // }
//     else {
//       results = names
//           .where((user) =>
//               user[0].toLowerCase().contains(enteredKeyword.toLowerCase()))
//           .toList();
//       // we use the toLowerCase() method to make it case-insensitive
//     }
//     //refreshing it
//     setState(() {
//       attandance = results;
//     });
//   }

//   Widget build(BuildContext context) {
//     // var height = MediaQuery.of(context).size.height;
//     // var width = MediaQuery.of(context).size.width;

//     //sorting
//     names.sort((a, b) => a[0].compareTo(b[0]));

//     return SafeArea(
//       child: Scaffold(
//         body: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(12.0),
//               child: Text(
//                 "Total no of students Absent: 13",
//                 style: TextStyle(fontSize: 21),
//               ),
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 Expanded(
//                   child: Padding(
//                     padding: EdgeInsets.only(
//                         left: 12, top: 8, bottom: 10, right: 12),
//                     child: TextField(
//                       onChanged: (value) => _runFilter(value),
//                       controller: editingController,
//                       decoration: InputDecoration(
//                         hintText: 'Search',
//                         labelText: 'Search',
//                         suffixIcon: IconButton(
//                             // Icon to
//                             icon: Icon(Icons.clear), // clear text
//                             onPressed: () {
//                               editingController.clear();
//                               setState(() {
//                                 a = 0;
//                                 print(a);
//                                 FocusScope.of(context) //  to dispose the  focus
//                                     .requestFocus(FocusNode());
//                               });
//                             }),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.all(Radius.circular(12)),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             Expanded(
//                 child: attandance.isNotEmpty || a == 0
//                     ? ListView.builder(
//                         shrinkWrap: true,
//                         itemCount: attandance.length,
//                         // names.length,
//                         itemBuilder: (BuildContext context, int index) {
//                           return Padding(
//                             padding: EdgeInsets.all(10.0),
//                             child: Container(
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Text(
//                                     // names[index][0],
//                                     attandance[index][0],
//                                     style: TextStyle(
//                                       fontSize: 18,
//                                     ),
//                                   ),
//                                   Checkbox(
//                                       checkColor: Colors.white,
//                                       fillColor:
//                                           MaterialStateProperty.resolveWith(
//                                               getColor),
//                                       value: names[index][1],
//                                       onChanged: (value) {
//                                         setState(() {
//                                           checkboxchange(value, index);
//                                         });
//                                       }),
//                                 ],
//                               ),
//                               padding: EdgeInsets.all(10),
//                               // alignment: AlignmentDirectional(-0.5, 0.6),
//                               height: 120,
//                               width: 220,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(12),
//                                 color: Colors.amber,
//                                 // color: Colors.white
//                               ),
//                             ),
//                           );
//                         },
//                       )
//                     : Column(
//                         children: [
//                           Expanded(
//                             flex: 2,
//                             child: Lottie.asset(
//                               "lib/assets/73061-search-not-found.json",
//                             ),
//                           ),
//                           Expanded(
//                             flex: 1,
//                             child: Text(
//                               "No Results found",
//                               style: TextStyle(fontSize: 24),
//                             ),
//                           ),
//                         ],
//                       )),
//           ],
//         ),
//       ),
//     );
//   }
// }
