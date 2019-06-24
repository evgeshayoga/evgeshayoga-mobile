import 'package:evgeshayoga/old_files/marathons_data.dart';
import 'package:evgeshayoga/ui/programs/program_screen.dart';
import 'package:flutter/material.dart';

class MarathonCard extends StatelessWidget {
  MarathonCard(this.marathon);

  final Marathon marathon;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          ListTile(
            onTap: () {
              var router =
                  new MaterialPageRoute(builder: (BuildContext context) {
                    print(marathon.material.content);
                return null;
              });
              Navigator.of(context).push(router);
            },
            contentPadding: const EdgeInsets.all(25),
            title: Text(
              marathon.marathonName,
              textAlign: TextAlign.center,
              style: TextStyle(
                  height: 1.5,
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: Colors.blueGrey,
              ),
            ),
            subtitle: Image.network(marathon.thumbnailUrl),
            isThreeLine: true,
//          leading: Icon(
//            Icons.event_available,
//            color: Colors.blueGrey,
//          ),
          ),
          Divider(
            height: 7,
            color: Colors.blueGrey,
          ),
        ],
      ),
    );
  }
}
