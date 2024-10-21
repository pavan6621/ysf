import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ysf/const/constdata.dart';

class ReceiverStatusBar extends StatefulWidget {
  final String? donationStatus; 
  final String? donationId; 
  
  ReceiverStatusBar({this.donationStatus, this.donationId});

  @override
  _ReceiverStatusBarState createState() => _ReceiverStatusBarState();
}

class _ReceiverStatusBarState extends State<ReceiverStatusBar> {
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref().child("donations");
  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    _updateStepStatus(); 
    print("-------------------${widget.donationId}");
  }

  void _updateStepStatus() {
    setState(() {
      if (widget.donationStatus == null || widget.donationStatus!.isEmpty) {
        _currentStep = 0; 
      } else if (widget.donationStatus == "Approved") {
        _currentStep = 2; 
      } else if (widget.donationStatus == "Inprogress") {
        _currentStep = 2; 
      } else if (widget.donationStatus == "Completed") {
        _currentStep = 3;
      }
    });
  }

  Future<void> _onButtonPressed() async {
    try {
      await _databaseRef.child(widget.donationId!).update({'status': "Completed"});
    
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Donation status updated to Approved!'))
      );
      _updateStepStatus();
    } catch (error) {
      print("Error updating donation: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating donation: $error'))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: myColor, title: Text('Donation Status')),
      body: Column(
        children: [
          Expanded(
            child: Stepper(
              type: StepperType.vertical,
              currentStep: _currentStep,
              steps: <Step>[
                Step(
                  title: Text('Not Approved'),
                  content: Text('Donation not yet approved.'),
                  isActive: _currentStep >= 0,
                  state: _currentStep == 0 ? StepState.editing : StepState.complete,
                ),
                Step(
                  title: Text('Approved'),
                  content: Text('Donation has been approved.'),
                  isActive: _currentStep >= 1,
                  state: _currentStep == 1 ? StepState.editing : StepState.complete,
                ),
                Step(
                  title: Text('In Progress'),
                  content: Text('Donation is in progress.'),
                  isActive: _currentStep >= 2,
                  state: _currentStep == 2 ? StepState.editing : StepState.complete,
                ),
                Step(
                  title: Text('Delivered'),
                  content: Text('Donation has been delivered.'),
                  isActive: _currentStep >= 3,
                  state: _currentStep == 3 ? StepState.complete : StepState.indexed,
                ),
              ],
            ),
          ),
          if (_currentStep == 2) 
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _onButtonPressed,
                child: Text('Received Donation'),
              ),
            ),
        ],
      ),
    );
  }
}
