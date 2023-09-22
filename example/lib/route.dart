import 'countryList.dart';
import 'countryListWithSearch.dart';
import 'fullSectionList.dart';
import 'home.dart';

import 'package:flutter/widgets.dart';

import 'sectionControllerView.dart';
import 'simpleSectionList.dart';

class SectionViewRoute {
  static const String initialRoute = "/";
  static final Map<String, WidgetBuilder> routes = {
    "/": (context) => const Stack(
          children: [
            HomePage(
              title: "Home",
            ),
          ],
        ),
    "/CountryList": (context) => const CountryList(),
    "/CountryListWithSearch": (context) => const CountryListWithSearch(),
    "/FullSectionList": (context) => const FullSectionList(),
    "/SimpleSectionList": (context) => const SimpleSectionList(),
    "/sectionControllerView": (context) => const SectionControllerView(),
  };
}
