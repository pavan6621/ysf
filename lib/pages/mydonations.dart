// import 'package:flutter/material.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:ysf/map/map_directions.dart';
// import 'package:ysf/pages/donor_status_bar.dart';
// import '../const/constdata.dart';
// import '../map/google_map_page.dart';

// class MyDonations extends StatefulWidget {
//   @override
//   MyDonationsState createState() => MyDonationsState();
// }

// class MyDonationsState extends State<MyDonations> {
//   final DatabaseReference _databaseRef =
//       FirebaseDatabase.instance.ref().child("donations");
//   String? donorName;
//   int? donorAge;
//   String? donorAddress;
//   LatLng? selectedCoordinates;
//   List<Map<dynamic, dynamic>> donations = [];
//   String? _editingKey;
//   bool _isLoading = true;

//   final _formKey = GlobalKey<FormState>();
//   late TextEditingController _nameController;
//   late TextEditingController _ageController;
//   late TextEditingController _addressController;

//   @override
//   void initState() {
//     super.initState();
//     _nameController = TextEditingController();
//     _ageController = TextEditingController();
//     _addressController = TextEditingController();
//     _getDonations();
//   }

//   Future<void> _getDonations() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? userId = prefs.getString('userId');

//     if (userId != null) {
//       _databaseRef
//           .orderByChild('id')
//           .equalTo(userId)
//           .once()
//           .then((DatabaseEvent event) {
//         DataSnapshot snapshot = event.snapshot;
//         List<Map<dynamic, dynamic>> donationList = [];

//         snapshot.children.forEach((child) {
//           Map<dynamic, dynamic> donationData =
//               child.value as Map<dynamic, dynamic>;
//           donationData['key'] = child.key;
//           donationList.add(donationData);
//         });

//         setState(() {
//           donations = donationList;
//           _isLoading = false;
//         });
//       }).catchError((error) {
//         setState(() {
//           _isLoading = false;
//         });
//         _showError("Error fetching donations: $error");
//       });
//     }
//   }

//   Future<void> _saveChanges(String donationKey) async {
//     if (_formKey.currentState!.validate()) {
//       try {
//         await _databaseRef.child(donationKey).update({
//           'name': _nameController.text,
//           'phone': int.tryParse(_ageController.text),
//           'address': _addressController.text,
//           'latitude': selectedCoordinates?.latitude,
//           'longitude': selectedCoordinates?.longitude,
//         });

//         _showMessage('Donation updated successfully');
//         setState(() {
//           _editingKey = null; // Clear the editing key after saving
//           // Clear the text fields
//           _nameController.clear();
//           _ageController.clear();
//           _addressController.clear();
//           selectedCoordinates = null; // Reset selected coordinates
//         });
//         _getDonations();
//       } catch (error) {
//         _showError('Error updating donation: $error');
//       }
//     }
//   }

//   Future<void> _rejectDonation(String donationKey) async {
//     try {
//       await _databaseRef
//           .child(donationKey)
//           .update({'acceptedBy': "", 'status': ""});
//       _getDonations();
//     } catch (error) {
//       _showError("Error updating donation: $error");
//     }
//   }

//   void _showDonationStatus(String donationStatus) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => DonorStatusBar(donationStatus: donationStatus),
//       ),
//     );
//   }

//   void _showReceiverInfo(Map<dynamic, dynamic> receiverInfo) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('Receiver Information'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text('Name: ${receiverInfo['name'] ?? 'N/A'}'),
//               Text('phone: ${receiverInfo['phone'] ?? 'N/A'}'),
//              Text('Address: ${receiverInfo['address1'] ?? 'N/A'}, ${receiverInfo['address2'] ?? 'N/A'}, ${receiverInfo['address3'] ?? 'N/A'}, ${receiverInfo['address4'] ?? 'N/A'}'),

//             ],
//           ),
//           actions: [
//             Row(
//               children: [
//                 ElevatedButton.icon(
//                   icon: SvgPicture.asset(
//                     'lib/assets/direction.svg',
//                     height: 24,
//                     width: 24,
//                     color: white,
//                   ),
//                   onPressed: () {
//                     double latitude = receiverInfo['latitude'];
//                     double longitude = receiverInfo['longitude'];
//                     Navigator.of(context).pop();
//                     _goToMap(latitude, longitude);
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.blueAccent,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                   label: Text('Direction', style: TextStyle(color: white)),
//                 ),
//                 TextButton(
//                   onPressed: () => Navigator.of(context).pop(),
//                   child: Text('Close'),
//                 ),
//               ],
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _goToMap(double latitude, double longitude) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) =>
//             MapDirections(latitude: latitude, longitude: longitude),
//       ),
//     );
//   }

//   void _startEditing(Map<dynamic, dynamic> donation) {
//     setState(() {
//       _editingKey = donation['key'];
//       _nameController.text = donation['name'];
//       _ageController.text = donation['phone'].toString();
//       _addressController.text = donation['address'];
//       selectedCoordinates = LatLng(donation['latitude'], donation['longitude']);
//     });
//   }

//   void _navigateToMap() async {
//     final result = await Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => GoogleMapPage()),
//     );

//     if (result != null && result is LatLng) {
//       setState(() {
//         selectedCoordinates = result;
//       });
//     }
//   }

//   void _showMessage(String message) {
//     ScaffoldMessenger.of(context)
//         .showSnackBar(SnackBar(content: Text(message)));
//   }

//   void _showError(String message) {
//     ScaffoldMessenger.of(context)
//         .showSnackBar(SnackBar(content: Text(message)));
//   }

//   Future<void> _getReceiverInfo(String userId) async {
//     final DatabaseReference userRef = FirebaseDatabase.instance
//         .ref()
//         .child('Personal information')
//         .child('users')
//         .child(userId);

//     DatabaseEvent event = await userRef.once();
//     if (event.snapshot.exists) {
//       Map<dynamic, dynamic> receiverInfo =
//           event.snapshot.value as Map<dynamic, dynamic>;
//       _showReceiverInfo(receiverInfo);
//     } else {
//       _showError('Receiver not found');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: _isLoading
//             ? Center(child: CircularProgressIndicator())
//             : donations.isNotEmpty
//                 ? ListView.builder(
//                     itemCount: donations.length,
//                     itemBuilder: (context, index) {
//                       var donation = donations[index];
//                       return Card(
//                         margin: const EdgeInsets.symmetric(vertical: 10.0),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(15.0),
//                         ),
//                         elevation: 4.0,
//                         color: Colors.white,
//                         shadowColor: Colors.grey.withOpacity(0.3),
//                         child: _editingKey == donation['key']
//                             ? _buildEditForm(donation)
//                             : _buildDonationListTile(donation),
//                       );
//                     },
//                   )
//                 : Center(child: Text('No donations found')),
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: myColor,
//         onPressed: () {
//           Navigator.pushReplacementNamed(context, navigate_Donor);
//         },
//         child: Icon(Icons.add,color: white,),
//         tooltip: 'Add new donation',
//       ),
//     );
//   }

//   Widget _buildEditForm(Map<dynamic, dynamic> donation) {
//     return Form(
//       key: _formKey,
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Edit Donation',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             SizedBox(height: 16),
//             TextFormField(
//               controller: _nameController,
//               decoration: InputDecoration(
//                   labelText: 'Donor Name', border: OutlineInputBorder()),
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter donor name';
//                 }
//                 return null;
//               },
//             ),
//             SizedBox(height: 12),
//             TextFormField(
//               controller: _ageController,
//               decoration: InputDecoration(
//                   labelText: 'Phone No', border: OutlineInputBorder()),
//               keyboardType: TextInputType.number,
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter donor age';
//                 }
//                 return null;
//               },
//             ),
//             SizedBox(height: 12),
//             TextFormField(
//               controller: _addressController,
//               decoration: InputDecoration(
//                   labelText: 'Donor Address', border: OutlineInputBorder()),
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter donor address';
//                 }
//                 return null;
//               },
//             ),
//             SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: _navigateToMap,
//               child: Text('Pick Location on Map'),
//             ),
//             _buildEditFormActions(donation),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildEditFormActions(Map<dynamic, dynamic> donation) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         ElevatedButton(
//           onPressed: () => _saveChanges(donation['key']),
//           child: Text("save"),
//         ),
//         ElevatedButton(
//           onPressed: () {
//             setState(() {
//               _editingKey = null;
//             });
//           },
//           child: Text('Cancel'),
//           style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//         ),
//       ],
//     );
//   }

//   Widget _buildDonationListTile(Map<dynamic, dynamic> donation) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Name',
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: myColor,
//             ),
//           ),
//           SizedBox(height: 10),
//           Row(
//             children: [
//               SvgPicture.asset(
//                 'lib/assets/phone.svg',
//                 width: 16,
//                 height: 16,
//               ),
//               SizedBox(width: 16),
//               Text(
//                 ' ${donation['phone']}',
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: Colors.grey[700],
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 10),
//           Row(
//             children: [
//               SvgPicture.asset(
//                 'lib/assets/address.svg',
//                 width: 16,
//                 height: 16,
//               ),
//               SizedBox(width: 16),
//               Expanded(
//                 child: Text(
//                   '${donation['address1']},${donation['address2']},${donation['address3']},${donation['address4']}.',
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: Colors.grey[700],
//                   ),
//                   softWrap: true,
//                   maxLines: null,
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 10),
//           Row(
//             children: [
//               SvgPicture.asset(
//                 'lib/assets/food.svg',
//                 width: 16,
//                 height: 16,
//               ),
//               SizedBox(width: 16),
//               Text(
//                 '${donation['donationItem']}',
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: Colors.grey[700],
//                 ),
//                 softWrap: true,
//                 maxLines: null,
//               ),
//             ],
//           ),
//           SizedBox(height: 8),
//           Align(
//             alignment: Alignment.centerRight,
//             child: Row(
//               children: [
                
//                 ElevatedButton(
                
//                   onPressed: () => _startEditing(donation),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color.fromARGB(255, 48, 101, 248),
//                     padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                  child: Icon(
//                     Icons.edit,
//                     color: white,
//                     size: 24,
//                   ),
//                 ),SizedBox(width: 8),
//                   ElevatedButton(
                  
//                   onPressed: () => _showDonationStatus(donation['status']),
//                  style: ElevatedButton.styleFrom(
//                                             backgroundColor: myColor,
//                                             padding: EdgeInsets.symmetric(
//                                                 horizontal: 0, vertical: 0),
//                                             shape: RoundedRectangleBorder(
//                                               borderRadius:
//                                                   BorderRadius.circular(8),
//                                             ),
//                                           ),
//                                         child:  SvgPicture.asset(
//                                             'lib/assets/status.svg',
//                                             height: 24,
//                                             width: 24,
//                                             color: Colors.white,
//                                           ),
//                 ),SizedBox(width: 8),
//                  if (donation['status'] != "")
//                   ElevatedButton(
//                      style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color.fromARGB(255, 110, 251, 188),
//                        padding: EdgeInsets.symmetric(
//                                                 horizontal: 7, vertical: 0),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(6),
//                       ),
//                     ),
//                     onPressed: () => _getReceiverInfo(donation['acceptedBy']),
//                    child: Icon(Icons.person),
                   
//                   ),SizedBox(width: 8),
//               donation['status'] == "Approved" ?
//                  ElevatedButton(
//                     onPressed: () => _rejectDonation(donation['key']),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.red,
//                        padding: EdgeInsets.symmetric(
//                                                 horizontal: 7, vertical: 0),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(6),
//                       ),
//                     ),
//                     child: Row(
//                       children: [
//                         Icon(
//                       Icons.cancel,
//                       color: Colors.white,
//                     ),
//                         Text(
//                           'Reject',
//                           style: TextStyle(color: Colors.white),
//                         ),
//                       ],
//                     ),
//                   ): SizedBox.shrink(),
               
              
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }





import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ysf/map/map_directions.dart';
import 'package:ysf/pages/donor_status_bar.dart';
import '../const/constdata.dart';
import '../map/google_map_page.dart';

class MyDonations extends StatefulWidget {
  @override
  MyDonationsState createState() => MyDonationsState();
}

class MyDonationsState extends State<MyDonations> {
  final DatabaseReference _databaseRef =
      FirebaseDatabase.instance.ref().child("donations");
  String? donorName;
  int? donorAge;
  String? donorAddress;
  LatLng? selectedCoordinates;
  List<Map<dynamic, dynamic>> donations = [];
  String? _editingKey;
  bool _isLoading = true;

  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _address1Controller;
  late TextEditingController _address2Controller;
  late TextEditingController _address3Controller;
  late TextEditingController _address4Controller;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _ageController = TextEditingController();
    _address1Controller = TextEditingController();
     _address2Controller = TextEditingController();
      _address3Controller = TextEditingController();
       _address4Controller = TextEditingController();
    _getDonations();
  }

  Future<void> _getDonations() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    if (userId != null) {
      _databaseRef
          .orderByChild('id')
          .equalTo(userId)
          .once()
          .then((DatabaseEvent event) {
        DataSnapshot snapshot = event.snapshot;
        List<Map<dynamic, dynamic>> donationList = [];

        snapshot.children.forEach((child) {
          Map<dynamic, dynamic> donationData =
              child.value as Map<dynamic, dynamic>;
          donationData['key'] = child.key;
          donationList.add(donationData);
        });

        setState(() {
          donations = donationList;
          _isLoading = false;
        });
      }).catchError((error) {
        setState(() {
          _isLoading = false;
        });
        _showError("Error fetching donations: $error");
      });
    }
  }

  Future<void> _saveChanges(String donationKey) async {
    if (_formKey.currentState!.validate()) {
      try {
        await _databaseRef.child(donationKey).update({
          'name': _nameController.text,
          'phone': int.tryParse(_ageController.text),
          'address1': _address1Controller.text,
          'address2': _address2Controller.text,
          'address3': _address3Controller.text,
          'address4': _address4Controller.text,
          'latitude': selectedCoordinates?.latitude,
          'longitude': selectedCoordinates?.longitude,
        });

        _showMessage('Donation updated successfully');
        setState(() {
          _editingKey = null; 
          _nameController.clear();
          _ageController.clear();
          _address1Controller.clear();
          _address2Controller.clear();
          _address3Controller.clear();
          _address4Controller.clear();
          selectedCoordinates = null; 
        });
        _getDonations();
      } catch (error) {
        _showError('Error updating donation: $error');
      }
    }
  }

  Future<void> _rejectDonation(String donationKey) async {
    try {
      await _databaseRef
          .child(donationKey)
          .update({'acceptedBy': "", 'status': ""});
      _getDonations();
    } catch (error) {
      _showError("Error updating donation: $error");
    }
  }

  void _showDonationStatus(String donationStatus) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DonorStatusBar(donationStatus: donationStatus),
      ),
    );
  }
void _showReceiverInfo(Map<dynamic, dynamic> receiverInfo) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
                    color: myColor,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Receiver Information',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Name: ${receiverInfo['name'] ?? 'N/A'}'),
                      Text('Phone: ${receiverInfo['phone'] ?? 'N/A'}'),
                      Text('Address: ${receiverInfo['address1'] ?? 'N/A'}, ${receiverInfo['address2'] ?? 'N/A'}, ${receiverInfo['address3'] ?? 'N/A'}, ${receiverInfo['address4'] ?? 'N/A'}'),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
                        icon: SvgPicture.asset(
                          'lib/assets/direction.svg',
                          height: 24,
                          width: 24,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          double latitude = receiverInfo['latitude'];
                          double longitude = receiverInfo['longitude'];
                          Navigator.of(context).pop();
                          _goToMap(latitude, longitude);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        label: Text('Direction', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}


void _goToMap(double latitude, double longitude) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => MapDirections(latitude: latitude, longitude: longitude),
    ),
  );
}

    void _startEditing(Map<dynamic, dynamic> donation) {
    setState(() {
      _editingKey = donation['key'];
      _nameController.text = donation['name'];
      _ageController.text = donation['phone'].toString();
      _address1Controller.text = donation['address1'];
      _address2Controller.text = donation['address2'];
      _address3Controller.text = donation['address3'];
      _address4Controller.text = donation['address4'];
      selectedCoordinates = LatLng(donation['latitude'], donation['longitude']);
    });
    _showEditForm();
  }

void _showEditForm() {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      var screenSize = MediaQuery.of(context).size;
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: SingleChildScrollView(
          child: Container(
            width: screenSize.width * 0.7, // Adjust for responsive scaling
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Full-width top section with myColor like AppBar
                Container(
                  width: double.infinity,  // Full width
                  padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
                    color: myColor, // Set your color here
                  ),
                  alignment: Alignment.center, // Center the text
                  child: Text(
                    'Edit Details',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,  // Text color for contrast
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: 'Donor Name',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter donor name';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 12),
                        TextFormField(
                          controller: _ageController,
                          decoration: InputDecoration(
                            labelText: 'Phone No',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter phone number';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 12),
                        TextFormField(
                          controller: _address1Controller,
                          decoration: InputDecoration(
                            labelText: 'Address Line 1',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter address line 1';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 12),
                        TextFormField(
                          controller: _address2Controller,
                          decoration: InputDecoration(
                            labelText: 'Address Line 2',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 12),
                        TextFormField(
                          controller: _address3Controller,
                          decoration: InputDecoration(
                            labelText: 'City',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 12),
                        TextFormField(
                          controller: _address4Controller,
                          decoration: InputDecoration(
                            labelText: 'Pin Code',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 12),
                        ElevatedButton.icon(
                          icon: Icon(Icons.location_on,color: white,),
                          onPressed: () => _navigateToMap(),
                          label: Text(selectedCoordinates == null
                              ? 'Select Location'
                              : 'Location Selected',style :TextStyle(color: white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    Row(
                      children: [
                        SizedBox(width: 6,),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _saveChanges(_editingKey!);
                              Navigator.of(context).pop(); // Close the dialog
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text('Save', style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _editingKey = null;
                        });
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      child: Text('Cancel', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}



  void _navigateToMap() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GoogleMapPage()),
    );

    if (result != null && result is LatLng) {
      setState(() {
        selectedCoordinates = result;
      });
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _getReceiverInfo(String userId) async {
    final DatabaseReference userRef = FirebaseDatabase.instance
        .ref()
        .child('Personal information')
        .child('users')
        .child(userId);

    DatabaseEvent event = await userRef.once();
    if (event.snapshot.exists) {
      Map<dynamic, dynamic> receiverInfo =
          event.snapshot.value as Map<dynamic, dynamic>;
      _showReceiverInfo(receiverInfo);
    } else {
      _showError('Receiver not found');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : donations.isNotEmpty
                ? ListView.builder(
                    itemCount: donations.length,
                    itemBuilder: (context, index) {
                      var donation = donations[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 10.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        elevation: 4.0,
                        color: Colors.white,
                        shadowColor: Colors.grey.withOpacity(0.3),
                        child: _buildDonationListTile(donation),
                      );
                    },
                  )
                : Center(child: Text('No donations found')),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: myColor,
        onPressed: () {
          Navigator.pushReplacementNamed(context, navigate_Bottomnavigation);
        },
        child: Icon(Icons.add, color: white),
        tooltip: 'Add new donation',
      ),
    );
  }

  Widget _buildDonationListTile(Map<dynamic, dynamic> donation) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${donation['name']}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: myColor,
                ),
              ),
              if(donation['status'] != "Completed")
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert),
                onSelected: (String value) {
                  if (value == 'edit') {
                    _startEditing(donation);
                  }  if (value == 'view') {
                    _showDonationStatus(donation['status']);
                  } if (value == 'info' && donation['status'] == "Approved") {
                   _getReceiverInfo(donation['acceptedBy']);
                  } if (value == 'reject' && donation['status'] == "Approved") {
                    _rejectDonation(donation['key']);
                  }
                },
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem<String>(
                      value: 'edit',
                      child: Text('Edit'),
                    ),
                    PopupMenuItem<String>(
                      value: 'view',
                      child: Text('View Status'),
                    ),
                     if (donation['status'] == "Approved")
                      PopupMenuItem<String>(
                        value: 'info',
                        child: Text('Receiver Info'),
                      ),
                    if (donation['status'] == "Approved")
                      PopupMenuItem<String>(
                        value: 'reject',
                        child: Text('Reject'),
                      ),
                  ];
                },
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              SvgPicture.asset(
                'lib/assets/phone.svg',
                width: 16,
                height: 16,
              ),
              SizedBox(width: 16),
              Text(
                ' ${donation['phone']}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              SvgPicture.asset(
                'lib/assets/address.svg',
                width: 16,
                height: 16,
              ),
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  '${donation['address1']}, ${donation['address2']}, ${donation['address3']}, ${donation['address4']}.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                  softWrap: true,
                  maxLines: null,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              SvgPicture.asset(
                'lib/assets/food.svg',
                width: 16,
                height: 16,
              ),
              SizedBox(width: 16),
              Text(
                '${donation['donationItem']}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
                softWrap: true,
                maxLines: null,
              ),
            ],
          ),
           SizedBox(height: 8),
           
            Align(
              alignment: Alignment.centerRight,
              child:donation['status'] == "Approved" || donation['status'] == "Completed" 
    ? Text(
        donation['status'] == "Approved" 
            ? 'Accepted' 
            : 'Delivered',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: const Color.fromARGB(255, 132, 236, 52),
        ),
      )
    : SizedBox.shrink(), 

            ),
       SizedBox(height: 8),
        ],
      ),
    );
  }
}

