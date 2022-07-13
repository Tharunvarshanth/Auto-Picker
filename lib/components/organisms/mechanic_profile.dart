import 'package:auto_picker/components/atoms/details_card_description.dart';
import 'package:auto_picker/components/atoms/text_description.dart';
import 'package:auto_picker/models/mechanic.dart';
import 'package:flutter/material.dart';

class MechanicProfile extends StatefulWidget {
  final Mechanic mechanic;
  const MechanicProfile(this.mechanic);

  @override
  _MechanicProfileState createState() => _MechanicProfileState();
}

class _MechanicProfileState extends State<MechanicProfile> {
  bool isLoading = true;
  String userRole;

  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return Column(
      children: [
        DetailsCardDescription(
            title: widget.mechanic.workingTime_From,
            description: 'Work Start Time'),
        DetailsCardDescription(
            title: widget.mechanic.workingTime_To ?? '',
            description: 'Work Finish Time'),
        DetailsCardDescription(
            title: widget.mechanic.specialist, description: 'Specialist Field'),
        DetailsCardDescription(
            title: widget.mechanic.workingAddress,
            description: 'Working Address'),
        DetailsCardDescription(
            title: widget.mechanic.workingCity, description: 'Working City'),
      ],
    );
  }
}
