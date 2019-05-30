import 'package:flutter/widgets.dart';

class Marathon {
  Marathon(
      {@required this.marathonName,
      @required this.thumbnailUrl,
      @required this.startDate,
      @required this.endDate,
      @required this.isVisible,
      @required this.isPurchasable,
      @required this.isActive,
      @required this.material});

  final String marathonName;
  final String thumbnailUrl;
  final String startDate;
  final String endDate;
  final bool isVisible;
  final bool isPurchasable;
  final bool isActive;
  final MarathonMaterial material;
}
class MarathonData {
  static final List marathons = [
    Marathon(
        marathonName: "Шпагат без боли",
        thumbnailUrl:
        "https://evgeshayoga.com/images/userfiles/images/%D1%81%D0%B5%D0%BC%D0%B8%D0%BD%D0%B0%D1%80%D1%8B/IMG_4792.JPG",
        startDate: "15 мая",
        endDate: "",
        isVisible: true,
        isPurchasable: true,
        isActive: true,
        material: MarathonMaterial(content: "bla-bla", sections: [])),
    Marathon(
        marathonName: "Марафон (для начинающих)",
        thumbnailUrl:
        "https://evgeshayoga.com/images/userfiles/files/ann-5-opt.jpg",
        startDate: "4 марта",
        endDate: "",
        isVisible: true,
        isPurchasable: true,
        isActive: true,
        material: MarathonMaterial(content: "", sections: [])),
    Marathon(
        marathonName: "PowerYoga",
        thumbnailUrl:
        "https://evgeshayoga.com/images/userfiles/files/marathon_picture_3.jpg",
        startDate: "",
        endDate: "Занятия доступны до 20 июля 2019",
        isVisible: true,
        isPurchasable: true,
        isActive: true,
        material: MarathonMaterial(content: "", sections: [])),
    Marathon(
        marathonName: "",
        thumbnailUrl: "",
        startDate: "",
        endDate: "",
        isVisible: true,
        isPurchasable: true,
        isActive: true,
        material: MarathonMaterial(content: "", sections: [])),
    Marathon(
        marathonName: "Yoga & ART марафон",
        thumbnailUrl: "https://evgeshayoga.com/images/userfiles/files/2.jpg",
        startDate: "15 нояря",
        endDate: "Занятия доступны до 31 января 2019 ",
        isVisible: true,
        isPurchasable: true,
        isActive: true,
        material: MarathonMaterial(content: "", sections: [])),
  ];
}

class MarathonMaterial {
  MarathonMaterial({this.content, this.sections});

  final String content;
  final List sections;
}
