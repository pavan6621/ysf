import 'package:flutter/material.dart';
import 'package:ysf/const/constdata.dart';

class DonorStatusBar extends StatefulWidget {
  final String? donationStatus; 

  DonorStatusBar({this.donationStatus});

  @override
  DonorStatusBarState createState() => DonorStatusBarState();
}

class DonorStatusBarState extends State<DonorStatusBar> {
  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    _updateStepStatus();
  }

  void _updateStepStatus() {
    setState(() {
      if (widget.donationStatus == null || widget.donationStatus!.isEmpty) {
        _currentStep = 0;
      } else if (widget.donationStatus == "Approved") {
        _currentStep = 2; 
      } else if (widget.donationStatus == "Inprogress") {
        _currentStep = 2; 
      } else if (widget.donationStatus == "Delivered") {
        _currentStep = 3;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: myColor, title: Text('Donation Status')),
      body: Stepper(
        type: StepperType.vertical,
        currentStep: _currentStep,
        steps: <Step>[
          Step(
            title: Text('No one Accepted'),
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
            title: Text('Inprogress'),
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
    );
  }
}
