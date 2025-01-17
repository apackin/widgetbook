import 'package:widgetbook_generator/code_generators/instances/instance.dart';
import 'package:widgetbook_generator/code_generators/instances/list_instance.dart';
import 'package:widgetbook_generator/code_generators/instances/widgetbook_widget_instance.dart';
import 'package:widgetbook_generator/code_generators/properties/property.dart';
import 'package:widgetbook_generator/services/tree_service.dart';

/// Defines an instance to create code for a [Folder]
class WidgetbookFolderInstance extends Instance {
  /// Creates a new instance of [WidgetbookFolderInstance]
  WidgetbookFolderInstance({required Folder folder})
      : super(
          name: 'WidgetbookFolder',
          properties: [
            Property.string(key: 'name', value: folder.name),
            Property(
              key: 'widgets',
              instance: ListInstance<WidgetbookWidgetInstance>(
                instances: folder.widgets.values
                    .map(
                      (widget) => WidgetbookWidgetInstance(
                        name: widget.name,
                        stories: widget.stories,
                        isExpanded: widget.isExpanded,
                      ),
                    )
                    .toList(),
              ),
            ),
            Property(
              key: 'folders',
              instance: ListInstance<WidgetbookFolderInstance>(
                instances: folder.subFolders.values
                    .map((folder) => WidgetbookFolderInstance(folder: folder))
                    .toList(),
              ),
            ),
            if (folder.isExpanded)
              Property.bool(key: 'isExpanded', value: true),
          ],
        );
}
