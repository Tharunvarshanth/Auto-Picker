import 'package:auto_picker/components/atoms/generic_button.dart';
import 'package:flutter/material.dart';

class OrderTile extends StatelessWidget {
  String ItemTitle;
  String itemSubTitle;
  String itemPrice;
  String orderedBy;
  String itemImgUrl;
  int itemCount;
  OrderTile(
      {Key key,
      this.ItemTitle,
      this.itemSubTitle,
      this.itemCount,
      this.orderedBy,
      this.itemImgUrl,
      this.itemPrice})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 2,
                    child: ListTile(
                      title: Text(
                        ItemTitle,
                        style: TextStyle(fontSize: 24),
                      ),
                      subtitle: Text(
                        itemSubTitle,
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: Image.network(
                        itemImgUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset('');
                        },
                      ))
                ],
              ),
              Divider(
                thickness: 2,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: ListTile(
                      title: Text(
                        "Ordered By",
                        style: TextStyle(fontSize: 24),
                      ),
                      subtitle: Text(
                        orderedBy,
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: ListTile(
                      title: Text(
                        itemCount.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 24),
                      ),
                      subtitle: Text(
                        'No Of Items',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GenericButton(
                        text: 'CALL',
                        paddingHorizontal: 2,
                        paddingVertical: 2,
                        textColor: Colors.white,
                        backgroundColor: Colors.blue,
                        shadowColor: Colors.transparent,
                        onPressed: () {},
                      ),
                      GenericButton(
                        text: 'CHAT',
                        paddingHorizontal: 2,
                        paddingVertical: 2,
                        shadowColor: Colors.transparent,
                        onPressed: () {},
                      ),
                    ],
                  )
                ],
              ),
              Divider(
                thickness: 2,
              ),
              Row(
                children: [
                  Expanded(
                      child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Text(
                          'PRICE',
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          itemPrice,
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    ),
                  )),
                  Expanded(
                      child: Container(
                    decoration: BoxDecoration(
                        border: Border(left: BorderSide(color: Colors.grey))),
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      children: [
                        ListTile(
                          trailing: Text(
                            'Completed',
                            style: TextStyle(fontSize: 20),
                          ),
                          leading: Radio(
                              value: true,
                              groupValue: true,
                              onChanged: (value) {}),
                        ),
                        GenericButton(
                          text: 'CONFIRM ORDER',
                          paddingVertical: 0,
                          paddingHorizontal: 8,
                          shadowColor: Colors.transparent,
                          onPressed: () {},
                        )
                      ],
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    ),
                  )),
                ],
              )
            ],
          ),
        ));
  }
}
