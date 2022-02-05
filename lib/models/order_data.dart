class OrderData {
  String ItemTitle;
  String itemSubTitle;
  String itemPrice;
  String orderedBy;
  String itemImgUrl;
  int itemCount;

  OrderData(
      {this.ItemTitle = '',
      this.itemImgUrl = '',
      this.itemPrice = '',
      this.itemCount = 0,
      this.itemSubTitle = '',
      this.orderedBy = ''}) {}
}
