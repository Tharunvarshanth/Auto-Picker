import 'package:auto_picker/components/atoms/generic_button.dart';
import 'package:flutter/material.dart';

class OrderCustomerTile extends StatelessWidget {
  String ItemTitle;
  String itemSubTitle;
  String itemPrice;
  String sellerBy;
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

  OrderCustomerTile(
      {Key key,
      this.ItemTitle,
      this.itemSubTitle,
      this.itemCount,
      this.sellerBy,
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
                        title: Text(
                          sellerBy,
                          style: TextStyle(fontSize: 20),
                        ),
                        subtitle: const Text(
                          "Seller ",
                          style: TextStyle(fontSize: 24),
                        )),
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
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Row(
                      children: [
                        const Text(
                          'Price',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          itemPrice,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    ),
                  )),
                  Expanded(
                      child: Container(
                          decoration: const BoxDecoration(
                              border:
                                  Border(left: BorderSide(color: Colors.grey))),
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Column(children: [
                            Row(
                              children: [
                                const Text(
                                  'Order Status :',
                                  style: TextStyle(fontSize: 16),
                                ),
                                if (!cancelled && !isCompleted && !isConfirmed)
                                  const Text(
                                    'Pending',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                if (cancelled)
                                  const Text(
                                    'Cancelled',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                if (isCompleted)
                                  const Text(
                                    'Completed',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                if (isConfirmed)
                                  const Text(
                                    'Confirmed',
                                    style: TextStyle(fontSize: 16),
                                  ),
                              ],
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            ),
                          ]))),
                ],
              )
            ],
          ),
        ));
  }
}
