import 'package:animeate/Models/catagorie.dart';
import 'package:animeate/Services/categories_services.dart';
import 'package:animeate/dialog/new_category_dialog.dart';
import 'package:flutter/material.dart';

class DisplaySettingsBottomSheet extends StatefulWidget {
  final List<CategoryItem> categories;
  final int itemsPerRow;
  final bool showNames;
  final bool showClearCover;
  final void Function(int slide, bool showName, bool showClearCover) save;
  final VoidCallback refreshPage;
  final void Function({required int oldIndex, required int newIndex}) onReorder;
  final void Function(int deletedIndex) refreshPageDelete;

  const DisplaySettingsBottomSheet({
    super.key,
    required this.categories,
    required this.itemsPerRow,
    required this.showNames,
    required this.showClearCover,
    required this.save,
    required this.refreshPage,
    required this.onReorder,
    required this.refreshPageDelete,
  });

  @override
  DisplaySettingsBottomSheetState createState() =>
      DisplaySettingsBottomSheetState();
}

class DisplaySettingsBottomSheetState
    extends State<DisplaySettingsBottomSheet> {
  late List<String> _categories;
  late int _itemsPerRow;
  late bool _showNames;
  late bool _showClearCover;

  @override
  void initState() {
    super.initState();
    _categories = List.from(widget.categories.map((e) => e.name));
    _itemsPerRow = widget.itemsPerRow;
    _showNames = widget.showNames;
    _showClearCover = widget.showClearCover;
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Display Settings',
              style: TextStyle(
                fontFamily: "Quick",
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Items per row: $_itemsPerRow',
              style: const TextStyle(
                fontFamily: "Quick",
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Slider(
              value: _itemsPerRow.toDouble(),
              min: 2,
              max: 6,
              divisions: 4,
              onChanged: (value) {
                setState(() {
                  _itemsPerRow = value.round();
                  widget.save(_itemsPerRow, _showNames, _showClearCover);
                });
              },
            ),
            SwitchListTile(
              title: const Text(
                'Show Names',
                style: TextStyle(
                  fontFamily: "Quick",
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              value: _showNames,
              onChanged: (value) {
                setState(() {
                  _showNames = value;
                  widget.save(_itemsPerRow, _showNames, _showClearCover);
                });
              },
            ),
            SwitchListTile(
              title: const Text(
                'Show Clear Cover',
                style: TextStyle(
                  fontFamily: "Quick",
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              value: _showClearCover,
              onChanged: (value) {
                setState(() {
                  _showClearCover = value;
                  widget.save(_itemsPerRow, _showNames, _showClearCover);
                });
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'Categories',
              style: TextStyle(
                fontFamily: "Quick",
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
            Expanded(
              child: ReorderableListView.builder(
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    key: Key('$index'),
                    title: Text(
                      _categories[index],
                      style: const TextStyle(
                        fontFamily: "Quick",
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            showAddCategoryDialog(
                                context: context,
                                addItem: () => setState(() {
                                      _categories = List.from(
                                          widget.categories.map((e) => e.name));
                                      widget.refreshPage();
                                    }),
                                preText: _categories[index],
                                editCategoryIndex: index);
                          },
                        ),
                        IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => setState(() {
                                  deleteCategory(index);
                                  _categories = List.from(
                                      widget.categories.map((e) => e.name));
                                  widget.refreshPageDelete(index);
                                })),
                      ],
                    ),
                  );
                },
                onReorder: (oldIndex, newIndex) {
                  setState(() {
                    if (newIndex > oldIndex) {
                      newIndex -= 1;
                      //* update the library
                    }
                    widget.onReorder(newIndex: newIndex, oldIndex: oldIndex);
                    final item = _categories.removeAt(oldIndex);
                    _categories.insert(newIndex, item);
                  });
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}
