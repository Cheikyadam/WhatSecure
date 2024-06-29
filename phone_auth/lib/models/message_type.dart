import 'package:hive_flutter/hive_flutter.dart';
part 'message_type.g.dart';

@HiveType(typeId: 5)
enum MessageType {
  @HiveField(0)
  image,
  @HiveField(1)
  doc,
  @HiveField(2)
  text
}
