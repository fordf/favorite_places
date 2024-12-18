import 'package:uuid/uuid.dart';

const uuid = Uuid();

class FavoritePlace {
  final String title;
  final String id;

  FavoritePlace({required this.title}) : id = uuid.v4();
}
