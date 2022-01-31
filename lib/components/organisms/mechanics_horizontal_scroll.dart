// ignore_for_file: file_names

import 'package:auto_picker/components/atoms/generic_text.dart';
import 'package:auto_picker/components/atoms/generic_text_field.dart';
import 'package:auto_picker/components/atoms/image_tile.dart';
import 'package:auto_picker/components/atoms/popup_modal_message.dart';
import 'package:auto_picker/components/pages/mechanic_profile_page.dart';
import 'package:auto_picker/models/mechanic.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MechanicsHorizontalItemScroll extends StatefulWidget {
  List<Mechanic> ImageTileList;
  double onPressOffsetChange;
  Future<List<Mechanic>> Function() onReachMax;
  ScrollController controller = ScrollController();
  MechanicsHorizontalItemScroll(
      {Key key,
      this.ImageTileList,
      this.onPressOffsetChange = 200,
      this.onReachMax})
      : super(key: key) {}

  @override
  State<MechanicsHorizontalItemScroll> createState() =>
      _MechanicsHorizontalItemScrollState();
}

class _MechanicsHorizontalItemScrollState
    extends State<MechanicsHorizontalItemScroll> {
  bool isLogged = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    setState(() {
      isLogged = _auth.currentUser != null;
    });
    widget.controller.addListener(() async {
      if (widget.controller.offset >=
              widget.controller.position.maxScrollExtent &&
          !widget.controller.position.outOfRange) {
        var newTiles = await widget.onReachMax();
        if (newTiles == null) {
          return;
        }
        setState(() {
          widget.ImageTileList.addAll(newTiles);
        });
      }
    });
  }

  void navigateToMechanicProfilePage(int index) {
    if (isLogged) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MechanicProfilePage(
              mechanic: widget.ImageTileList[index],
            ),
          ));
    } else {
      showDialog(
          context: context,
          builder: (context) => ItemDialogMessage(
                icon: 'assets/images/x-circle.svg',
                titleText: 'Need to Signup',
                bodyText:
                    "Auto picker terms & conditions without an account user's cann't see detail view",
                primaryButtonText: 'Ok',
                onPressedPrimary: () => Navigator.pop(context, 'Cancel'),
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () {
            widget.controller.animateTo(
                widget.controller.offset - widget.onPressOffsetChange,
                duration: Duration(milliseconds: 200),
                curve: Curves.ease);
          },
          icon: const Icon(Icons.arrow_left),
        ),
        Expanded(
          flex: 5,
          child: SizedBox(
              height: 100,
              child: (widget.ImageTileList.length > 0)
                  ? ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.ImageTileList.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () => navigateToMechanicProfilePage(index),
                          child: ImageTile(
                            text: widget.ImageTileList[index].specialist,
                            subText: widget.ImageTileList[index].workingCity,
                          ),
                        );
                      })
                  : GenericText(
                      text: 'No data',
                    )),
        ),
        IconButton(
            onPressed: () {
              widget.controller.animateTo(
                  widget.controller.offset + widget.onPressOffsetChange,
                  duration: Duration(milliseconds: 200),
                  curve: Curves.ease);
            },
            icon: Icon(Icons.arrow_right)),
      ],
    );
  }
}
