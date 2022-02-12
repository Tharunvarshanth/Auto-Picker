import 'package:auto_picker/themes/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../routes.dart';

class CustomAppBar extends StatefulWidget with PreferredSizeWidget {
  final String title;
  final bool isLogged;
  final bool showBackButton;
  const CustomAppBar({this.title, this.isLogged = true, this.showBackButton});

  @override
  _AppBarState createState() => _AppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _AppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(widget.title),
      automaticallyImplyLeading: widget.showBackButton,
      elevation: 2,
      actions: <Widget>[
        if (!widget.isLogged)
          Padding(
            padding: EdgeInsets.all(15),
            child: GestureDetector(
              onTap: () =>
                  Navigator.of(context)?.pushNamed(RouteGenerator.loginPage),
              child: const Text(
                'Login',
              ),
            ),
          )
      ],
    );
  }
}
