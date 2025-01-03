import 'package:permission_handler/permission_handler.dart';
import 'package:timetable/helpers/get_os_version.dart';

Future<bool> requestStoragePermission() async {
  final int androidVersion = await getAndroidVersion();
  bool status;

  if (androidVersion >= 33) {
    final photos = await Permission.photos.request();
    final videos = await Permission.videos.request();

    status = photos.isGranted && videos.isGranted;
  } else {
    final storage = await Permission.storage.request();
    status = storage.isGranted;
  }

  return status;
}
