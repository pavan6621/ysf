
// import 'package:flutter/material.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../const/constdata.dart';
// import '../map/google_map_page.dart';

// class Donor extends StatefulWidget {
//   @override
//   DonorState createState() => DonorState();
// }

// class DonorState extends State<Donor> {
//   final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref().child("donations");

//   String? donorName;
//   String? donorPhone;
//   String? donorAddress1;
//   String? donorAddress2;
//   String? donorAddress3;
//   String? donorAddress4;
//   String? donationItem;
//   LatLng? selectedCoordinates;
//   List<Map<dynamic, dynamic>> donations = [];

//   @override
//   void initState() {
//     super.initState();
//     _getDonations();
//   }

//   Future<void> _addDonation(String name, String phone, String address1, String address2,  String address3, String address4,String item, LatLng coordinates) async {
//     String key = _databaseRef.push().key!;
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     var Id = prefs.getString('userId');
//     _databaseRef.child(key).set({
//       "id": Id,
//       "name": name,
//       "phone": phone,
//       "address1": address1,
//       "address2": address2,
//       "address3": address3,
//       "address4": address4,
//       "donationItem": item,
//       "latitude": coordinates.latitude,
//       "longitude": coordinates.longitude,
//       "acceptedBy": "",
//       "status": "",
//     }).then((_) {
//       Navigator.pushReplacementNamed(context, navigate_Home);
//     });
//   }

//   void _getDonations() {
//     _databaseRef.once().then((DatabaseEvent event) {
//       DataSnapshot snapshot = event.snapshot;
//       List<Map<dynamic, dynamic>> donationList = [];
//       snapshot.children.forEach((child) {
//         Map<dynamic, dynamic> donationData = child.value as Map<dynamic, dynamic>;
//         donationList.add(donationData);
//       });

//       setState(() {
//         donations = donationList;
//       });
//     });
//   }

//   void _navigateToMap() async {
//     final result = await Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => GoogleMapPage(),
//       ),
//     );

//     if (result != null && result is LatLng) {
//       setState(() {
//         selectedCoordinates = result;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         FocusScope.of(context).unfocus(); 
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           backgroundColor: myColor,
         
//           leading: IconButton(
//             icon: Icon(Icons.arrow_back,color: white,),
//             onPressed: () {
//               Navigator.pushReplacementNamed(context, navigate_Home);
//             },
//           ),
//         ),
//         resizeToAvoidBottomInset: true,
//         body: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     Text(
//                       'Donation Details',
//                       style: TextStyle(
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                     SizedBox(height: 10),
//                     TextField(
//                       decoration: InputDecoration(
//                         labelText: 'Name',
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                       onChanged: (value) => donorName = value,
                      
//                     ),
//                     SizedBox(height: 10),
//                     TextField(
//                       decoration: InputDecoration(
//                         labelText: 'Phone Number',
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                       keyboardType: TextInputType.phone,
//                       onChanged: (value) => donorPhone = value,
//                     ),
//                    SizedBox(height: 10),
//                     TextField(
//                       decoration: InputDecoration(
//                         labelText: 'Address1',
//                         hintText: 'Flat Number', 
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                       onChanged: (value) => donorAddress1 = value,
//                     ),SizedBox(height: 10),
//                       TextField(
//                       decoration: InputDecoration(
//                         labelText: 'Address2',
//                         hintText: 'Street/colony', 
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                       onChanged: (value) => donorAddress2 = value,
//                     ),SizedBox(height: 10),
//                       TextField(
//                       decoration: InputDecoration(
//                         labelText: 'Address3',
//                         hintText: 'City', 
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                       onChanged: (value) => donorAddress3 = value,
//                     ),SizedBox(height: 10),
//                       TextField(
//                       decoration: InputDecoration(
//                         labelText: 'Address4',
//                         hintText: 'Pin Code', 
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
                        
//                       ),
//                        keyboardType: TextInputType.phone,
//                       onChanged: (value) => donorAddress4 = value,
//                     ),SizedBox(height: 10),
//                         ElevatedButton(
//                       onPressed: _navigateToMap,
//                       child: Text('Pick Location on Map'),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: myColor,
//                         padding: EdgeInsets.symmetric(vertical: 16),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                     ),SizedBox(height: 10),
                   
//                     TextField(
//                       maxLines: null,
//                       decoration: InputDecoration(
//                         labelText: 'What do you want to donate?',
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                       onChanged: (value) => donationItem = value,
//                     ),
//                     SizedBox(height: 10),
                
                   
//                       ElevatedButton(
//                         onPressed: () {
//                           if (donorName != null && donorPhone != null && donorAddress1 != null&& donorAddress2 != null&& donorAddress3 != null&& donorAddress4 != null && donationItem != null) {
//                             _addDonation(donorName!, donorPhone!, donorAddress1!, donorAddress2!, donorAddress3!, donorAddress4!, donationItem!, selectedCoordinates!);
//                           } else {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               SnackBar(content: Text('Please complete all fields')),
//                             );
//                           }
//                         },
//                         child: Text('Save Location and Submit'),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: myColor,
//                           padding: EdgeInsets.symmetric(vertical: 16),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                         ),
//                       ),
//                     ],
//                 ),
//           ),
//         ),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../const/constdata.dart';
import '../map/google_map_page.dart';

class Donor extends StatefulWidget {
  @override
  DonorState createState() => DonorState();
}

class DonorState extends State<Donor> {
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref().child("donations");
  final _formKey = GlobalKey<FormState>(); // Form key for validation

  String? donorName;
  String? donorPhone;
  String? donorAddress1;
  String? donorAddress2;
  String? donorAddress3;
  String? donorAddress4;
  String? donationItem;
  LatLng? selectedCoordinates;
  List<Map<dynamic, dynamic>> donations = [];

  @override
  void initState() {
    super.initState();
    _getDonations();
  }

  Future<void> _addDonation(String name, String phone, String address1, String address2, String address3, String address4, String item, LatLng coordinates) async {
    String key = _databaseRef.push().key!;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var Id = prefs.getString('userId');
    _databaseRef.child(key).set({
      "id": Id,
      "name": name,
      "phone": phone,
      "address1": address1,
      "address2": address2,
      "address3": address3,
      "address4": address4,
      "donationItem": item,
      "latitude": coordinates.latitude,
      "longitude": coordinates.longitude,
      "acceptedBy": "",
      "status": "",
    }).then((_) {
      Navigator.pushReplacementNamed(context, navigate_Home);
    });
  }

  void _getDonations() {
    _databaseRef.once().then((DatabaseEvent event) {
      DataSnapshot snapshot = event.snapshot;
      List<Map<dynamic, dynamic>> donationList = [];
      snapshot.children.forEach((child) {
        Map<dynamic, dynamic> donationData = child.value as Map<dynamic, dynamic>;
        donationList.add(donationData);
      });

      setState(() {
        donations = donationList;
      });
    });
  }

  void _navigateToMap() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GoogleMapPage(),
      ),
    );

    if (result != null && result is LatLng) {
      setState(() {
        selectedCoordinates = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); 
      },
      child: Scaffold(
        appBar: AppBar(
  backgroundColor: myColor,
  leading: IconButton(
    icon: Icon(Icons.arrow_back),
    onPressed: () {
      Navigator.pushReplacementNamed(context, navigate_Bottomnavigation);
    },
  ),
  title: Text(
    'Donation Details',
    style: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
    textAlign: TextAlign.center,
  ),
  centerTitle: true,
),

        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
            
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onChanged: (value) => donorName = value,
                    validator: validateUser,
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    keyboardType: TextInputType.phone,
                    onChanged: (value) => donorPhone = value,
                    validator: validatenumber,
                    
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Address1',
                      hintText: 'Flat Number',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onChanged: (value) => donorAddress1 = value,
                    validator: validateAddress1,
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Address2',
                      hintText: 'Street/colony',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onChanged: (value) => donorAddress2 = value,
                  validator: validateAddress2,
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'City',
                      // hintText: 'City',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onChanged: (value) => donorAddress3 = value,
                    validator: validateAddress3,
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Pin Code',
                      // hintText: 'Pin Code',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => donorAddress4 = value,
                   validator: validateAddress4,
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _navigateToMap,
                    child: Text(  selectedCoordinates == null 
    ? 'Pick Location on Map' 
    : 'Pick Location on Map\nLatitude: ${selectedCoordinates!.latitude.toStringAsFixed(4)}, Longitude: ${selectedCoordinates!.longitude.toStringAsFixed(4)}',
),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: myColor,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    maxLines: null,
                    decoration: InputDecoration(
                      labelText: 'What do you want to donate?',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onChanged: (value) => donationItem = value,
                    validator: validateDonate,
                  ),
                

                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate() && selectedCoordinates != null) {
                        _addDonation(
                          donorName!,
                          donorPhone!,
                          donorAddress1!,
                          donorAddress2!,
                          donorAddress3!,
                          donorAddress4!,
                          donationItem!,
                          selectedCoordinates!,
                        );
                      }
                       if( selectedCoordinates == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Please complete all fields and pick a location')),
                        );
                      }
                    },
                    child: Text('Submit'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: myColor,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
