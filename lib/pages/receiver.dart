// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:ysf/const/constdata.dart';
// import 'package:ysf/pages/receiver_status_bar.dart';
// import '../map/map_directions.dart';

// class Receiver extends StatefulWidget {
//   @override
//   ReceiverState createState() => ReceiverState();
// }

// class ReceiverState extends State<Receiver> {
//   final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref().child("donations");

//   String? donorName;
//   int? donorAge;
//   String? donorAddress;
//   LatLng? selectedCoordinates;
//   List<Map<dynamic, dynamic>> donations = [];
//   var Id;

//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _getDonations();
//   }

//   Future<void> _getDonations() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     Id = prefs.getString('userId');

//     _databaseRef.once().then((DatabaseEvent event) {
//       DataSnapshot snapshot = event.snapshot;
//       List<Map<dynamic, dynamic>> donationList = [];

//       snapshot.children.forEach((child) {
//         Map<dynamic, dynamic> donationData = child.value as Map<dynamic, dynamic>;
//         donationData['key'] = child.key;
//         if (donationData['id'] != Id) {
//           if (donationData['acceptedBy'] == "" || donationData['acceptedBy'] == Id) {
//             donationList.add(donationData);
//           }
//         }
//       });

//       setState(() {
//         donations = donationList;
//         _isLoading = false;
//       });
//     }).catchError((error) {
//       setState(() {
//         _isLoading = false;
//       });
//       print("Error fetching donations: $error");
//     });
//   }

//   Future<void> AcceptDonation(String donationKey) async {
//     try {
//       await _databaseRef.child(donationKey).update({'acceptedBy': Id});
//       await _databaseRef.child(donationKey).update({'status': "Approved"});
//       _getDonations();
//     } catch (error) {
//       print("Error updating donation: $error");
//     }
//   }

//   Future<void> RejectDonation(String donationKey) async {
//     try {
//       await _databaseRef.child(donationKey).update({'acceptedBy': ""});
//       await _databaseRef.child(donationKey).update({'status': ""});
//       _getDonations();
//     } catch (error) {
//       print("Error updating donation: $error");
//     }
//   }

//   void _goToMap(double latitude, double longitude) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => MapDirections(latitude: latitude, longitude: longitude),
//       ),
//     );
//   }

//   void _showDonationStatus(String donationStatus) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => ReceiverStatusBar(donationStatus: donationStatus),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Receive Donations"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
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
//                         elevation: 5.0,
//                         child: Padding(
//                           padding: const EdgeInsets.all(16.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 'Donor: ${donation['name']}',
//                                 style: TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.teal,
//                                 ),
//                               ),
//                               SizedBox(height: 8),
//                               Text(
//                                 'Age: ${donation['age']}',
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   color: Colors.grey[700],
//                                 ),
//                               ),
//                               SizedBox(height: 8),
//                               Text(
//                                 'Address: ${donation['address']}',
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   color: Colors.grey[700],
//                                 ),
//                               ),
//                               SizedBox(height: 8),
//                               Text(
//                                 'Location: (${donation['latitude']}, ${donation['longitude']})',
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   color: Colors.grey[700],
//                                 ),
//                               ),
//                               SizedBox(height: 8),
//                               Text(
//                                 'Status: ${donation['status'] ?? "Pending"}',
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   color: donation['status'] == "Approved"
//                                       ? Colors.green
//                                       : Colors.orange,
//                                 ),
//                               ),
//                               SizedBox(height: 16),
//                               Wrap(
//                                 spacing: 10.0,
//                                 runSpacing: 10.0,
//                                 children: [
//                                   ElevatedButton.icon(
//                                     icon: Icon(
//                                       donation['status'] == "Approved"
//                                           ? Icons.cancel
//                                           : Icons.check_circle,
//                                       color: Colors.white,
//                                     ),
//                                     onPressed: () {
//                                       if (donation['status'] == "Approved") {
//                                         RejectDonation(donation['key']);
//                                       } else {
//                                         AcceptDonation(donation['key']);
//                                       }
//                                     },
//                                     style: ElevatedButton.styleFrom(
//                                       backgroundColor: donation['status'] == "Approved"
//                                           ? Colors.red
//                                           : Colors.green,
//                                       shape: RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.circular(10),
//                                       ),
//                                     ),
//                                     label: Text(
//                                       donation['status'] == "Approved"
//                                           ? 'Reject'
//                                           : 'Accept',
//                                     ),
//                                   ),
//                                   ElevatedButton.icon(
//                                     icon: Icon(Icons.map),
//                                     onPressed: () {
//                                       double latitude = donation['latitude'];
//                                       double longitude = donation['longitude'];
//                                       _goToMap(latitude, longitude);
//                                     },
//                                     style: ElevatedButton.styleFrom(
//                                       backgroundColor: Colors.blueAccent,
//                                       shape: RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.circular(10),
//                                       ),
//                                     ),
//                                     label: Text('Direction'),
//                                   ),
//                                   ElevatedButton.icon(
//                                     icon: Icon(Icons.info_outline),
//                                     onPressed: () {
//                                       _showDonationStatus(donation['status'] ?? "Pending");
//                                     },
//                                     style: ElevatedButton.styleFrom(
//                                       backgroundColor: Colors.purple,
//                                       shape: RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.circular(10),
//                                       ),
//                                     ),
//                                     label: Text('View Status'),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   )
//                 : Center(
//                     child: Text(
//                       'No donations found',
//                       style: TextStyle(
//                         fontSize: 18,
//                         color: Colors.grey[600],
//                       ),
//                     ),
//                   ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:ysf/const/constdata.dart';
import 'package:ysf/pages/receiver_status_bar.dart';
import '../map/map_directions.dart';
import '../screen/personalinfo.dart';

class Receiver extends StatefulWidget {
  @override
  ReceiverState createState() => ReceiverState();
}

class ReceiverState extends State<Receiver> {
  final DatabaseReference _databaseRef =
      FirebaseDatabase.instance.ref().child("donations");

  String? donorName;
  int? donorAge;
  String? donorAddress;
  LatLng? selectedCoordinates;
  List<Map<dynamic, dynamic>> donations = [];
  var Id;
  var phone;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getDonations();
     _getReceiverInfo();
  }

Future<void> _getReceiverInfo() async {
 

  SharedPreferences prefs = await SharedPreferences.getInstance();
  var userId = prefs.getString('userId');

  if (userId == null || userId.isEmpty) {
  
    return;
  }

  try {
    final DatabaseReference userRef = FirebaseDatabase.instance.ref('Personal information/users/$userId');
    DatabaseEvent event = await userRef.once();
  
      Map<dynamic, dynamic>? receiverInfo = event.snapshot.value as Map<dynamic, dynamic>?;
            
   phone = receiverInfo!['phone'];
  } catch (e) {
    print('Error fetching receiver information: ${e}');
  } 
}

  Future<void> _getDonations() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Id = prefs.getString('userId');

    _databaseRef.once().then((DatabaseEvent event) {
      DataSnapshot snapshot = event.snapshot;
      List<Map<dynamic, dynamic>> donationList = [];

      snapshot.children.forEach((child) {
        Map<dynamic, dynamic> donationData =
            child.value as Map<dynamic, dynamic>;
        donationData['key'] = child.key;
        if (donationData['id'] != Id) {
          if (donationData['acceptedBy'] == "" ||
              donationData['acceptedBy'] == Id) {
            donationList.add(donationData);
          }
        }
      });

      setState(() {
        donations = donationList;
        _isLoading = false;
      });
    }).catchError((error) {
      setState(() {
        _isLoading = false;
      });
      print("Error fetching donations: $error");
    });
  }
Future<void> AcceptDonation(String donationKey) async {
  if (phone == null || phone.isEmpty) {
  showDialog(
  context: context,
  builder: (context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
      ),
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(0.0), // Reduced padding
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8.0,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(12.0), // Reduced header padding
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12.0)),
                  gradient: LinearGradient(
                    colors: [myColor, myColor.withOpacity(0.8)],
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: Colors.white,
                      size: 28,
                    ),
                    SizedBox(width: 4.0), 
                    Text(
                      'Error',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12.0), 
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0), 
                child: Text(
                  'You need to fill in your details.',
                  style: TextStyle(
                    fontSize: 14, 
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 16.0), 
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 10.0), backgroundColor: myColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    gotopersioninfo();
                  },
                  child: Text(
                    'Ok',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12.0), 
            ],
          ),
        ),
      ),
    );
  },
);


    return; 
  }
print("-------------------$donationKey");
  try {
    await _databaseRef.child(donationKey).update({'acceptedBy': Id});
    await _databaseRef.child(donationKey).update({'status': "Approved"});
    _getDonations();
  } catch (error) {
    print("Error updating donation: $error");
  }
}

void gotopersioninfo(){
  setState(() {
    ConstData.bottomindexpage =1;
  });
   Navigator.pushReplacementNamed(context, navigate_Bottomnavigation);
}

  Future<void> RejectDonation(String donationKey) async {
    try {
      await _databaseRef.child(donationKey).update({'acceptedBy': ""});
      await _databaseRef.child(donationKey).update({'status': ""});
      _getDonations();
    } catch (error) {
      print("Error updating donation: $error");
    }
  }

  void _goToMap(double latitude, double longitude) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            MapDirections(latitude: latitude, longitude: longitude),
      ),
    );
  }

  void _showDonationStatus(String donationStatus,String donationId) {
    print("---------------$donationId");
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReceiverStatusBar(donationStatus: donationStatus,donationId :donationId ),
      ),
    );
    _getReceiverInfo();
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
                        shadowColor:
                            Colors.grey.withOpacity(0.3), 
                        child: Padding(
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
                                  
    Text(
        '${donation['status']}',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: const Color.fromARGB(255, 132, 236, 52),
        ),
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
                                      '${donation['address1']},${donation['address2']},${donation['address3']},${donation['address4']}.',
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
                              SizedBox(height: 20),
                              if(donation['status'] != "Completed")
                              Align(
                                alignment: Alignment.centerRight,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ElevatedButton(

                                      onPressed: () {
                                        double latitude = donation['latitude'];
                                        double longitude =
                                            donation['longitude'];
                                        _goToMap(latitude, longitude);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 8),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      child: donation['status'] == "Approved"
                                          ? SvgPicture.asset(
                                        'lib/assets/direction.svg',
                                        height: 24,
                                        width: 24,
                                        color: Colors.white,
                                      )
                                          : Row(
                                            children: [
                                              SvgPicture.asset(
                                        'lib/assets/direction.svg',
                                        height: 24,
                                        width: 24,
                                        color: Colors.white,
                                      ),SizedBox(width: 10,),
                                              Text(
                                                  'Direction',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                            ],
                                          ),
                                    ),
                                    if (donation['status'] == "Approved")
                                    SizedBox(width: 10),
                                    if (donation['status'] == "Approved")
                                     ElevatedButton(
  onPressed: () {
    _showDonationStatus(donation['status'],donation['key']);
  },
  style: ElevatedButton.styleFrom(
    backgroundColor: myColor,
    padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0), 
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),
  child: SvgPicture.asset(
    'lib/assets/status.svg',
    height: 24,
    width: 24,
    color: Colors.white,
  ),
),

                                    SizedBox(width: 10),
                                    ElevatedButton.icon(
                                      icon: Icon(
                                        donation['status'] == "Approved"
                                            ? Icons.cancel
                                            : Icons.check_circle,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        if (donation['status'] == "Approved") {
                                          RejectDonation(donation['key']);
                                        } else {
                                          AcceptDonation(donation['key']);
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            donation['status'] == "Approved"
                                                ? Colors.red
                                                : Colors.green,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 8),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      label: Text(
                                        donation['status'] == "Approved"
                                            ? "Cancel"
                                            : 'Accept',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : Center(
                    child: Text(
                      'No donations found',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
      ),
    );
  }
}
