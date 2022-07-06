import 'package:auto_picker/components/atoms/generic_button.dart';
import 'package:auto_picker/themes/colors.dart';
import 'package:flutter/material.dart';

class OrderTile extends StatelessWidget {
  String ItemTitle;
  String itemSubTitle;
  String itemPrice;
  String orderedBy;
  String itemImgUrl;
  int itemCount;
  bool isCompleted;
  bool isConfirmed;
  int index;
  void Function() handleIsCompleted;
  void Function() handleConfirmOrder;
  void Function() makeCall;
  bool cancelled;
  void Function() cancelOrder;

  OrderTile(
      {Key key,
      this.ItemTitle,
      this.itemSubTitle,
      this.itemCount,
      this.orderedBy,
      this.itemImgUrl,
      this.itemPrice,
      this.isCompleted,
      this.index,
      this.handleIsCompleted,
      this.handleConfirmOrder,
      this.isConfirmed,
      this.makeCall,
      this.cancelled,
      this.cancelOrder})
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
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset('');
                        },
                      ))
                ],
              ),
              const Divider(
                thickness: 2,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: ListTile(
                      title: const Text(
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
                      subtitle: const Text(
                        'No Of Items',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GenericButton(
                        text: 'Call',
                        paddingHorizontal: 2,
                        paddingVertical: 2,
                        textColor: Colors.white,
                        backgroundColor: Colors.blue,
                        shadowColor: Colors.transparent,
                        onPressed: () {
                          makeCall();
                        },
                      ),
                    ],
                  )
                ],
              ),
              const Divider(
                thickness: 2,
              ),
              Row(
                children: [
                  Expanded(
                      child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        const Text(
                          'Price',
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          itemPrice,
                          style: const TextStyle(fontSize: 20),
                        ),
                      ],
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    ),
                  )),
                  Expanded(
                      child: Container(
                    decoration: const BoxDecoration(
                        border: Border(left: BorderSide(color: Colors.grey))),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      children: [
                        (!cancelled)
                            ? ListTile(
                                trailing: const Text(
                                  'Completed',
                                  style: TextStyle(fontSize: 20),
                                ),
                                leading: Checkbox(
                                  splashRadius: 20,
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.padded,
                                  value: isCompleted,
                                  onChanged: (bool value) {
                                    handleIsCompleted();
                                  },
                                ))
                            : const ListTile(
                                trailing: Text(
                                  'Cancelled',
                                  style: TextStyle(fontSize: 20),
                                ),
                                leading: Checkbox(
                                  splashRadius: 20,
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.padded,
                                  value: true,
                                )),
                        if (!isConfirmed)
                          GenericButton(
                            text: 'Confirm Order',
                            paddingVertical: 0,
                            paddingHorizontal: 8,
                            shadowColor: Colors.transparent,
                            onPressed: () {
                              handleConfirmOrder();
                            },
                          ),
                        if (!cancelled && !isCompleted)
                          GenericButton(
                            text: 'Cancel',
                            paddingVertical: 0,
                            paddingHorizontal: 8,
                            shadowColor: Colors.transparent,
                            onPressed: () {
                              cancelOrder();
                            },
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
