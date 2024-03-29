import 'package:auto_picker/components/atoms/generic_text.dart';
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
                titleText: 'Need to Signin',
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
        Expanded(
          flex: 3,
          child: SizedBox(
              height: 90,
              child: (widget.ImageTileList.length > 0)
                  ? ListView.separated(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      separatorBuilder: (context, index) => SizedBox(width: 0),
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.ImageTileList.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () => navigateToMechanicProfilePage(index),
                          child: ImageTile(
                            index: index,
                            text: widget.ImageTileList[index].name ?? '',
                            subText:
                                widget.ImageTileList[index].workingCity ?? '',
                          ),
                        );
                      })
                  : GenericText(
                      text: 'No data',
                    )),
        ),
      ],
    );
  }
}
