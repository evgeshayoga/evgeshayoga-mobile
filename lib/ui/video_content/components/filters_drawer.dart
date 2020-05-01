import 'package:evgeshayoga/models/yoga_online_lesson.dart';
import 'package:evgeshayoga/utils/style.dart';
import 'package:flutter/material.dart';

class FiltersDrawer extends StatefulWidget {
  final List<YogaOnlineLesson> videos;
  final Filters filters;
  final Function onApplyFilters;
  final Function onClear;

  FiltersDrawer(
      {Key key, this.videos, this.onApplyFilters, this.filters, this.onClear})
      : super(key: key);

  @override
  _FiltersDrawerState createState() => _FiltersDrawerState();
}

class _FiltersDrawerState extends State<FiltersDrawer> {
  String _selectedLevel;
  String _selectedType;
  String _selectedTeacher;
  String _selectedCategory;
  String _selectedDuration;
  String _selectedFormat;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.filters.category;
    _selectedType = widget.filters.type;
    _selectedLevel = widget.filters.level;
    _selectedTeacher = widget.filters.teacher;
    _selectedDuration = widget.filters.duration;
    _selectedFormat = widget.filters.format;
  }

  Map<int, String> ddLevel() {
    Map<int, String> levels = {};
    widget.videos.forEach((video) {
      if (!levels.containsKey(video.level)) {
        levels[video.level] = video.levelName;
      }
    });
    return levels;
  }

  Map<int, String> ddType() {
    Map<int, String> types = {};
    widget.videos.forEach((video) {
      if (!types.containsKey(video.type.toString())) {
        types[video.type] = video.typeName.trim();
      }
    });
    return types;
  }

  Map<int, String> ddFormat() {
    Map<int, String> formats = {};
    widget.videos.forEach((video) {
      if (!formats.containsKey(video.format.toString())) {
        formats[video.format] = video.formatName.trim();
      }
    });
    return formats;
  }

  Map<int, String> ddTeachers() {
    Map<int, String> teachers = {};

    widget.videos.forEach((video) {
      video.teachers.forEach((teacher) {
        if (!teachers.containsKey(teacher["id"])) {
          teachers[teacher["id"]] = teacher["name"];
        }
      });
    });
    return teachers;
  }

  Map<int, String> ddCategories() {
    Map<int, String> categories = {};

    widget.videos.forEach((video) {
      video.categories.forEach((cat) {
        if (!categories.containsKey(cat["id"])) {
          categories[cat["id"]] = cat["title"];
        }
      });
    });
    return categories;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 40),
                ),
                Container(
                  height: 50,
                  child: Center(child: Text("Фильтры")),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      FilterRow(
                          name: "Уровень",
                          value: _selectedLevel,
                          values: ddLevel(),
                          onChanged: (value) {
                            setState(() {
                              _selectedLevel = value;
                            });
                          },
                          onClear: () => _clearOneFilter('level')
                      ),
                      FilterRow(
                        name: "Вид",
                        value: _selectedType,
                        values: ddType(),
                        onChanged: (value) {
                          setState(() {
                            _selectedType = value;
                          });
                        },
                        onClear: () => _clearOneFilter('type')
                      ),
                      FilterRow(
                        name: "Преподаватель",
                        value: _selectedTeacher,
                        values: ddTeachers(),
                        onChanged: (value) {
                          setState(() {
                            _selectedTeacher = value;
                          });
                        },
                        onClear: () => _clearOneFilter('teacher')
                      ),
                      FilterRow(
                          name: "Акцент",
                          value: _selectedCategory,
                          values: ddCategories(),
                          onChanged: (value) {
                            setState(() {
                              _selectedCategory = value;
                            });
                          },
                          onClear: () => _clearOneFilter('category')
                      ),
                      FilterRow(
                        name: "Формат",
                        value: _selectedFormat,
                        values: ddFormat(),
                        onChanged: (value) {
                          setState(() {
                            _selectedFormat = value;
                          });
                        },
                        onClear: () => _clearOneFilter('format')
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          DropdownButton(
                            items: [
                              DropdownMenuItem<String>(
                                value: '10',
                                child: Text(
                                  "10 мин",
                                ),
                              ),
                              DropdownMenuItem<String>(
                                value: '20',
                                child: Text(
                                  "20 мин",
                                ),
                              ),
                              DropdownMenuItem<String>(
                                value: '30',
                                child: Text(
                                  "30 мин",
                                ),
                              ),
                              DropdownMenuItem<String>(
                                value: '40',
                                child: Text(
                                  "40 мин",
                                ),
                              ),
                              DropdownMenuItem<String>(
                                value: '50',
                                child: Text(
                                  "50 мин",
                                ),
                              ),
                              DropdownMenuItem<String>(
                                value: '60',
                                child: Text(
                                  "60 мин",
                                ),
                              ),
                              DropdownMenuItem<String>(
                                value: '90',
                                child: Text(
                                  "90 мин",
                                ),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _selectedDuration = value;
                              });
                            },
                            hint: Text(
                              "Продолжительность",
                            ),
                            value: _selectedDuration,
                          ),
                          IconButton(
                            icon: Icon(Icons.clear),
                            color: Style.blueGrey,
                            onPressed: () => _clearOneFilter('duration'),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                ),
                Container(
                  width: 200,
                  child: RaisedButton(
                    onPressed: () {
                      widget.onApplyFilters(Filters(
                          level: _selectedLevel,
                          type: _selectedType,
                          duration: _selectedDuration,
                          teacher: _selectedTeacher,
                          category: _selectedCategory,
                          format: _selectedFormat,
                      ));
                    },
                    color: Style.pinkMain,
                    child: new Text(
                      "Применить",
                      style: Style.regularTextStyle,
                    ),
                  ),
                ),
                Container(
                  width: 200,
                  child: RaisedButton(
                    onPressed: () {
                      _clearFilters();
                    },
                    color: Style.pinkMain,
                    child: new Text(
                      "Очистить",
                      style: Style.regularTextStyle,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 40),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _clearFilters() {
    widget.onClear();
    setState(() {
      _selectedDuration = null;
      _selectedLevel = null;
      _selectedTeacher = null;
      _selectedType = null;
      _selectedCategory = null;
      _selectedFormat = null;
    });
  }

  void _clearOneFilter(filter) {
    setState(() {
      switch (filter) {
        case "level":
          {
            _selectedLevel = null;
          }
          break;
        case "duration":
          {
            _selectedDuration = null;
          }
          break;
        case "teacher":
          {
            _selectedTeacher = null;
          }
          break;
        case "type":
          {
            _selectedType = null;
          }
          break;
        case "category":
          {
            _selectedCategory = null;
          }
          break;
        case "format":
          {
            _selectedFormat = null;
          }
          break;
      }
    });
  }
}

class FilterRow extends StatelessWidget {
   String name;
   String value;
   Map <int, String> values;
   VoidCallback onClear;
   ValueChanged<String> onChanged;

  FilterRow({this.value, this.name, this.onClear, this.onChanged, this.values});

  List<DropdownMenuItem> ddItems() {
    var keys = values.keys.toList()..sort();
    return keys.map((key) => DropdownMenuItem<String>(
      value: key.toString(),
      child: Text(
        "" + values[key],
      ),
    ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        DropdownButton<String>(
          items: ddItems(),
          onChanged: onChanged,
          hint: Text(name),
          value: value,
        ),
        IconButton(
          icon: Icon(Icons.clear),
          color: Style.blueGrey,
          onPressed: onClear,
        )
      ],
    );
  }
}


class Filters {
  String level;
  String type;
  String duration;
  String teacher;
  String category;
  String format;

  Filters({this.level, this.type, this.duration, this.teacher, this.category, this.format});
}
