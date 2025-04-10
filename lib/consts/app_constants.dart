import 'package:fyp/models/start_model.dart';
import 'package:fyp/services/assets_manager.dart';


class AppConstants{
  static List<String> bannersImages = [
    AssetsManager.banner1,
    AssetsManager.banner2,
    AssetsManager.banner3,
  ];

  static List<StartModel> startList = [
    StartModel(id: AssetsManager.mood, name: "Mood Tracker", image: AssetsManager.mood,),
    StartModel(id: AssetsManager.focus, name: "Focus Mode", image: AssetsManager.focus,),
    StartModel(id: AssetsManager.community, name: "Community", image: AssetsManager.community,),
    StartModel(id: AssetsManager.calm, name: "Calm", image: AssetsManager.calm,),
  ];
}