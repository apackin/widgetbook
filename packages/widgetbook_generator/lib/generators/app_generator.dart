import 'package:widgetbook_generator/code_generators/instances/app_info_instance.dart';
import 'package:widgetbook_generator/code_generators/instances/device_instance.dart';
import 'package:widgetbook_generator/code_generators/instances/theme_instance.dart';
import 'package:widgetbook_generator/code_generators/instances/theme_mode_instance.dart';
import 'package:widgetbook_generator/code_generators/instances/widgetbook_category_instance.dart';
import 'package:widgetbook_generator/code_generators/instances/widgetbook_instance.dart';
import 'package:widgetbook_generator/models/widgetbook_story_data.dart';
import 'package:widgetbook_generator/models/widgetbook_theme_data.dart';
import 'package:widgetbook_generator/services/tree_service.dart';
import 'package:widgetbook_models/widgetbook_models.dart';

/// Generates the code of the Widgetbook
String generateWidgetbook({
  required String name,
  required List<WidgetbookStoryData> stories,
  required List<Device> devices,
  required bool foldersExpanded,
  required bool widgetsExpanded,
  WidgetbookThemeData? lightTheme,
  WidgetbookThemeData? darkTheme,
  bool? defaultThemeIsDark,
}) {
  final category =
      _generateCategoryInstance(stories, foldersExpanded, widgetsExpanded);
  final widgetbookInstanceCode = WidgetbookInstance(
    appInfoInstance: AppInfoInstance(name: name),
    lightThemeInstance:
        lightTheme != null ? ThemeInstance(name: lightTheme.name) : null,
    darkThemeInstance:
        darkTheme != null ? ThemeInstance(name: darkTheme.name) : null,
    defaultThemeInstance: defaultThemeIsDark != null
        ? ThemeModeInstance(name: defaultThemeIsDark ? 'dark' : 'light')
        : null,
    devices: devices.map((device) => DeviceInstance(device: device)).toList(),
    categories: [
      category,
    ],
  ).toCode();

  return '''
class HotReload extends StatelessWidget {
  const HotReload({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return $widgetbookInstanceCode;
  }
}
  ''';
}

WidgetbookCategoryInstance _generateCategoryInstance(
  List<WidgetbookStoryData> stories,
  bool foldersExpanded,
  bool widgetsExpanded,
) {
  final service = TreeService(foldersExpanded, widgetsExpanded);

  for (final story in stories) {
    final folder = service.addFolderByImport(story.typeDefinition);
    service.addStoryToFolder(folder, story);
  }

  return WidgetbookCategoryInstance(
    name: 'use cases',
    folders: service.folders.values.toList(),
    widgets: service.rootFolder.widgets.values.toList(),
  );
}
