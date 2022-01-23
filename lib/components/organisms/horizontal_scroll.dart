// ignore_for_file: file_names

import 'package:auto_picker/components/atoms/image_tile.dart';
import 'package:flutter/material.dart';

class HorizontalItemScroll extends StatefulWidget {
  List<ImageTile> ImageTileList;
  double onPressOffsetChange;
  Future<List<ImageTile>> Function() onReachMax;
  ScrollController controller = ScrollController();
  HorizontalItemScroll(
      {Key key,
      this.ImageTileList,
      this.onPressOffsetChange = 200,
      this.onReachMax})
      : super(key: key) {}

  @override
  State<HorizontalItemScroll> createState() => _HorizontalItemScrollState();
}

class _HorizontalItemScrollState extends State<HorizontalItemScroll> {
  @override
  void initState() {
    super.initState();

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
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            controller: widget.controller,
            child: Row(
              children: [
                ImageTile(
                    imgUrl:
                        'https://media.istockphoto.com/vectors/male-blue-collar-worker-gesture-illustration-thumb-up-ok-vector-id1329292876?b=1&k=20&m=1329292876&s=612x612&w=0&h=OYra5uhuAFp6SBx9r0B_ACzNPs2WffjRDCKeKLnjAf4=',
                    text: 'No text '),
                ImageTile(
                    imgUrl:
                        'https://media.istockphoto.com/vectors/male-blue-collar-worker-gesture-illustration-thumb-up-ok-vector-id1329292876?b=1&k=20&m=1329292876&s=612x612&w=0&h=OYra5uhuAFp6SBx9r0B_ACzNPs2WffjRDCKeKLnjAf4=',
                    text: 'no text'),
                ImageTile(
                    imgUrl:
                        'https://media.istockphoto.com/vectors/male-blue-collar-worker-gesture-illustration-thumb-up-ok-vector-id1329292876?b=1&k=20&m=1329292876&s=612x612&w=0&h=OYra5uhuAFp6SBx9r0B_ACzNPs2WffjRDCKeKLnjAf4=',
                    text: 'no text'),
                ImageTile(
                    imgUrl:
                        'https://media.istockphoto.com/vectors/male-blue-collar-worker-gesture-illustration-thumb-up-ok-vector-id1329292876?b=1&k=20&m=1329292876&s=612x612&w=0&h=OYra5uhuAFp6SBx9r0B_ACzNPs2WffjRDCKeKLnjAf4=',
                    text: 'no text'),
              ],
            ),
          ),
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
