import 'package:auto_picker/components/atoms/service_card.dart';
import 'package:auto_picker/components/organisms/footer.dart';
import 'package:flutter/material.dart';

class MechanicPage extends StatefulWidget {
  const MechanicPage({Key key}) : super(key: key);

  @override
  _MechanicPageState createState() => _MechanicPageState();
}

class _MechanicPageState extends State<MechanicPage> {
  ScrollController _controller = ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller.addListener(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 2,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text('Mechanics'),
        actions: [
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {},
                child: Icon(
                  Icons.more_horiz,
                  size: 26.0,
                ),
              )),
        ],
        actionsIconTheme:
            IconThemeData(size: 30.0, color: Colors.grey, opacity: 10.0),
      ),
      bottomNavigationBar: Footer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Center(
                child: Icon(Icons.search),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2),
              child: Center(
                child: Text('Find Nearby Garage'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Divider(
                thickness: 2,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  Expanded(
                      flex: 2,
                      child: ListTile(
                        title: Text('Sorted By'),
                        subtitle: Text(
                          'Recommended',
                          style: TextStyle(color: Colors.cyan),
                        ),
                      )),
                  IconButton(onPressed: () {}, icon: Icon(Icons.sync_rounded))
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 3 / 5,
              child: ListView.builder(
                controller: _controller,
                itemCount: 10,
                itemBuilder: (context, index) {
                  return ServiceCard();
                },
              ),
            )
          ],
        ),
      ),
    ));
  }
}
