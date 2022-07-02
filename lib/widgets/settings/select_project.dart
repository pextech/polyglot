import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl_ui/providers/translation_provider.dart';
import 'package:intl_ui/services/config_handler.dart';

class SelectProject extends ConsumerWidget {
  const SelectProject({Key? key}) : super(key: key);

  Future<void> openProjectFromFolder(
      VoidCallback reloadTranslations, BuildContext context) async {
    final files = await FilePicker.platform
        .pickFiles(allowedExtensions: ['json'], type: FileType.custom);
    final result = files?.paths.first;
    if (result == null) {
      return;
    }
    _changePath(result, reloadTranslations, context);
  }

  _changePath(String newPath, VoidCallback reloadTranslations,
      BuildContext context) async {
    await ConfigHandler.instance.changePathToProjectConfigFile(newPath);
    reloadTranslations();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reloadTranslations =
        ref.read(TranslationProvider.provider.notifier).reloadTranslations;
    return Dialog(
      child: SizedBox(
        width: 800,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const Text(
                'Projects',
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Open new',
                    style: TextStyle(fontSize: 18),
                  ),
                  IconButton(
                    onPressed: () =>
                        openProjectFromFolder(reloadTranslations, context),
                    icon: const Icon(Icons.folder),
                  )
                ],
              ),
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: 1.5,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              for (final project
                  in ConfigHandler.instance.internalConfig?.projects ?? [])
                GestureDetector(
                  onTap: () =>
                      _changePath(project, reloadTranslations, context),
                  child: DecoratedBox(
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          width: 1.5,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: Text(project),
                          ),
                          IconButton(
                              onPressed: project !=
                                      ConfigHandler.instance.internalConfig
                                          ?.projectConfigPath
                                  ? () => ConfigHandler.instance
                                      .removeProjectFromInternalConfig(project)
                                  : null,
                              icon: Icon(
                                Icons.delete,
                              ))
                        ],
                      ),
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
