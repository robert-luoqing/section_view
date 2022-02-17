## Properties
### source
The property is the data which you want to show in section view. Notice, the data is two hierarchical data. Section view will use the data to render header item and list item both. like: List<Country> and Country should have a "provinces" property. Please ref [Source example]
- type: 
```dart
List<T>
// source model example
class Country {
  Country(
      {required this.name, required this.abbreviate, required this.provinces});
  String name;
  String abbreviate;
  List<String> provinces;
}
```

### onFetchListData
Get the list to render list item. The parameter "sourceItem" is item of source.
- type
```dart
List<N> Function(T sourceItem)
// example
onFetchListData: (country) => country.provinces
```

### headerBuilder
Building header widget.
- type
``` dart
Widget Function(BuildContext context, T headerData, int headerIndex)
// example
headerBuilder: (context, headerData, headerIndex) =>
  Container(
    color: const Color(0xFFF3F4F5),
    child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: Text(
        headerData.name,
        style: const TextStyle(
            fontSize: 18, color: Color(0xFF767676)),
      ),
    ),
  ),
```
- parameter
1. headerData: The item of source
2. headerIndex: The item index in source

### itemBuilder
- type
```dart
 Widget Function(
  BuildContext context,
  N itemData,
  int itemIndex,
  T headerData,
  int headerIndex,
);
// example
itemBuilder:
    (context, itemData, itemIndex, headerData, headerIndex) =>
        ListTile(title: Text(itemData))),
```






