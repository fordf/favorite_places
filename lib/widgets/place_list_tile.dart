import 'package:flutter/material.dart';
import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/screens/place_detail.dart';

class PlaceListTile extends StatelessWidget {
  const PlaceListTile(
      {super.key, required this.place, required this.onDeletePlace});

  final Place place;
  final void Function() onDeletePlace;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(place),
      background: Container(
        color: Theme.of(context).colorScheme.error,
        // margin: EdgeInsets.symmetric(
        //   horizontal: Theme.of(context).cardTheme.margin!.horizontal,
        // ),
      ),
      onDismissed: (d) {
        onDeletePlace();
      },
      child: ListTile(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (ctx) => PlaceDetail(place: place)),
          );
        },
        leading: CircleAvatar(
          radius: 26,
          backgroundImage: FileImage(place.image),
        ),
        title: Text(
          place.title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
    );
  }
}
