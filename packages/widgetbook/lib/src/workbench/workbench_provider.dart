import 'package:flutter/material.dart';
import 'package:widgetbook/src/extensions/list_extension.dart';
import 'package:widgetbook/src/state_change_notifier.dart';
import 'package:widgetbook/src/workbench/comparison_setting.dart';
import 'package:widgetbook/src/workbench/workbench_state.dart';
import 'package:widgetbook/widgetbook.dart';

class WorkbenchProvider<CustomTheme>
    extends StateChangeNotifier<WorkbenchState<CustomTheme>> {
  WorkbenchProvider({
    required List<WidgetbookTheme<CustomTheme>> themes,
    required List<Locale> locales,
    required List<Device> devices,
    required List<WidgetbookFrame> frames,
  }) : super(
          state: WorkbenchState(
            frame: frames.first,
            locale: locales.first,
            device: devices.first,
            theme: themes.first,
            themes: themes,
            locales: locales,
            devices: devices,
            frames: frames,
          ),
        );

  void hotReload({
    required List<WidgetbookTheme<CustomTheme>> themes,
    required List<Locale> locales,
    required List<Device> devices,
    required List<WidgetbookFrame> frames,
  }) {
    state = state.copyWith(
      frame: frames.firstWhere(
        (element) => element == state.frame,
        orElse: () => frames.first,
      ),
      // Due to unknown reasons the data property of `WidgetbookTheme` is not
      // comparable in all cases. Therefore, the names will be compared instead.
      theme: state.theme == null
          ? null
          : themes.firstWhere(
              (element) => element.name == state.theme!.name,
              orElse: () => themes.first,
            ),
      locale: state.locale == null
          ? null
          : locales.firstWhere(
              (element) => element == state.locale,
              orElse: () => locales.first,
            ),
      device: state.device == null
          ? null
          : devices.firstWhere(
              (element) => element == state.device,
              orElse: () => devices.first,
            ),
      themes: themes,
      locales: locales,
      devices: devices,
      frames: frames,
    );
  }

  void changedComparisonSetting(ComparisonSetting comparisonSetting) {
    if (state.comparisonSetting == comparisonSetting) {
      comparisonSetting = ComparisonSetting.none;
    }

    switch (comparisonSetting) {
      case ComparisonSetting.none:
        state = state.copyWith(
          comparisonSetting: comparisonSetting,
          locale: state.locale ?? state.locales.first,
          theme: state.theme ?? state.themes.first,
          device: state.device ?? state.devices.first,
        );
        break;
      case ComparisonSetting.themes:
        state = state.copyWith(
          comparisonSetting: comparisonSetting,
          locale: state.locale ?? state.locales.first,
          theme: null,
          device: state.device ?? state.devices.first,
        );
        break;
      case ComparisonSetting.devices:
        state = state.copyWith(
          comparisonSetting: comparisonSetting,
          locale: state.locale ?? state.locales.first,
          theme: state.theme ?? state.themes.first,
          device: null,
        );
        break;
      case ComparisonSetting.localization:
        state = state.copyWith(
          comparisonSetting: comparisonSetting,
          locale: null,
          theme: state.theme ?? state.themes.first,
          device: state.device ?? state.devices.first,
        );
        break;
    }
  }

  void changedDevice(Device? device) {
    state = state.copyWith(
      device: device,
      comparisonSetting: state.comparisonSetting == ComparisonSetting.devices
          ? ComparisonSetting.none
          : state.comparisonSetting,
    );
  }

  void changedTheme(WidgetbookTheme<CustomTheme>? widgetbookTheme) {
    state = state.copyWith(
      theme: widgetbookTheme,
      comparisonSetting: state.comparisonSetting == ComparisonSetting.themes
          ? ComparisonSetting.none
          : state.comparisonSetting,
    );
  }

  void changedLocale(Locale? locale) {
    state = state.copyWith(
      locale: locale,
      comparisonSetting:
          state.comparisonSetting == ComparisonSetting.localization
              ? ComparisonSetting.none
              : state.comparisonSetting,
    );
  }

  void changedDeviceFrame(WidgetbookFrame frame) {
    state = state.copyWith(frame: frame);
  }

  void nextLocale() {
    final nextLocale = state.locales.getNext(state.locale);
    state = state.copyWith(
      locale: nextLocale,
      comparisonSetting:
          state.comparisonSetting == ComparisonSetting.localization
              ? ComparisonSetting.none
              : state.comparisonSetting,
    );
  }

  void previousLocale() {
    final previousLocale = state.locales.getPrevious(state.locale);
    state = state.copyWith(
      locale: previousLocale,
      comparisonSetting:
          state.comparisonSetting == ComparisonSetting.localization
              ? ComparisonSetting.none
              : state.comparisonSetting,
    );
  }

  void nextTheme() {
    final nextTheme = state.themes.getNext(state.theme);
    state = state.copyWith(
      theme: nextTheme,
      comparisonSetting: state.comparisonSetting == ComparisonSetting.themes
          ? ComparisonSetting.none
          : state.comparisonSetting,
    );
  }

  void previousTheme() {
    final previousTheme = state.themes.getPrevious(state.theme);
    state = state.copyWith(
      theme: previousTheme,
      comparisonSetting: state.comparisonSetting == ComparisonSetting.themes
          ? ComparisonSetting.none
          : state.comparisonSetting,
    );
  }

  void nextDevice() {
    final nextDevice = state.devices.getNext(state.device);
    state = state.copyWith(
      device: nextDevice,
      comparisonSetting: state.comparisonSetting == ComparisonSetting.devices
          ? ComparisonSetting.none
          : state.comparisonSetting,
    );
  }

  void previousDevice() {
    final previousDevice = state.devices.getPrevious(state.device);
    state = state.copyWith(
      device: previousDevice,
      comparisonSetting: state.comparisonSetting == ComparisonSetting.devices
          ? ComparisonSetting.none
          : state.comparisonSetting,
    );
  }

  void nextDeviceFrame() {
    final nextDeviceFrame = state.frames.getNext(state.frame);
    state = state.copyWith(
      frame: nextDeviceFrame,
    );
  }

  void previousDeviceFrame() {
    final previousDevice = state.frames.getPrevious(state.frame);
    state = state.copyWith(
      frame: previousDevice,
    );
  }
}
