import 'package:flutter/material.dart';

import 'generic_button.dart';

class ItemDialog extends StatelessWidget {
  Icon icon;
  String titleText;
  String bodyText;
  String primaryButtonText;
  String secondaryButtonText;
  bool Function(TextEditingController controller, BuildContext context)
      onPressedPrimary;
  bool Function(TextEditingController controller, BuildContext context)
      onPressedSecondary;
  TextEditingController controller = TextEditingController();
  ItemDialog(
      {Key key,
      this.icon,
      this.titleText,
      this.bodyText,
      this.primaryButtonText,
      this.secondaryButtonText,
      this.onPressedPrimary,
      this.onPressedSecondary})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(
                Icons.folder_outlined,
                color: Colors.cyan,
                size: 32,
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'No of Items',
                style: TextStyle(fontSize: 20),
              ),
              LayoutBuilder(
                builder: (context, constraints) {
                  return SizedBox(
                    width: constraints.maxWidth * 0.33,
                    child: TextField(
                      controller: controller,
                      keyboardType: TextInputType.number,
                      maxLength: 5,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      style: const TextStyle(fontSize: 20),
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Dialog has a default elevation of 24. Elevation is the z coordinate of the dialog, and that can be changed by setting the elevation property of the dialog. If you set the elevation to 0, you can see there’s no shadow, and it shows both the dialogs and the views below that are on the same surface.',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                child: GenericButton(
                  text: 'DONE',
                  onPressed: () {
                    onPressedPrimary(controller, context);
                  },
                  borderRadius: 30,
                  shadowColor: Colors.white,
                  elevation: 0,
                  backgroundColor: Colors.blue,
                  textColor: Colors.white,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              SizedBox(
                width: double.infinity,
                child: GenericButton(
                  text: 'CANCEL',
                  onPressed: () {
                    onPressedPrimary(controller, context);
                  },
                  borderColor: Colors.white,
                  textColor: Colors.blue,
                  shadowColor: Colors.white,
                  elevation: 0,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
