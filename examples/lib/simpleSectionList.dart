import 'package:flutter/material.dart';
import 'package:section_view/section_view.dart';

class ItemModel {
  ItemModel({required this.name});
  String name;
}

class GroupModel {
  GroupModel({required this.name, required this.items});
  String name;
  List<ItemModel> items;
}

class SimpleSectionList extends StatefulWidget {
  const SimpleSectionList({Key? key}) : super(key: key);

  @override
  _SimpleSectionListState createState() => _SimpleSectionListState();
}

class _SimpleSectionListState extends State<SimpleSectionList> {
  List<GroupModel> data = [
    GroupModel(name: "Group 1", items: [
      ItemModel(name: "Item 1-1"),
      ItemModel(name: "Item 1-2"),
      ItemModel(name: "Item 1-3"),
      ItemModel(name: "Item 1-4"),
      ItemModel(name: "Item 1-5"),
    ]),
    GroupModel(name: "Group 2", items: [
      ItemModel(name: "Item 2-1"),
      ItemModel(name: "Item 2-2"),
      ItemModel(name: "Item 2-3"),
      ItemModel(name: "Item 2-4"),
      ItemModel(name: "Item 2-5"),
    ]),
    GroupModel(name: "Group 3", items: [
      ItemModel(name: "Item 3-1"),
      ItemModel(name: "Item 3-2"),
      ItemModel(name: "Item 3-3"),
      ItemModel(name: "Item 3-4"),
      ItemModel(name: "Item 3-5"),
    ]),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Example")),
        body: Column(
          children: [
            Expanded(
              flex: 1,
              child: SectionView<GroupModel, ItemModel>(
                  source: data,
                  onFetchListData: (header) => header.items,
                  headerBuilder: getDefaultHeaderBuilder((d) => d.name,
                      bkColor: Colors.green,
                      style:
                          const TextStyle(fontSize: 18, color: Colors.white)),
                  itemBuilder:
                      (context, itemData, itemIndex, headerData, headerIndex) =>
                          ListTile(
                            title: Text(itemData.name),
                          )),
            ),
          ],
        ));
  }
}
