import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miraswift_demo/models/spk_model.dart';
import 'package:miraswift_demo/screens/spk_screen.dart';
import 'package:miraswift_demo/utils/snackbar.dart';
import 'package:miraswift_demo/widgets/list_tile_item.dart';

class ProductionScreen extends StatefulWidget {
  const ProductionScreen({super.key});

  @override
  State<ProductionScreen> createState() => _ProductionScreenState();
}

class _ProductionScreenState extends State<ProductionScreen> {
  bool _isLoading = true;
  bool _isStarted = false;
  List<SpkModel> _listItem = [];
  SpkModel? _selectedItem = null;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        for (var i = 1; i < 6; i++) {
          _listItem.add(
            SpkModel(
              idSpk: '$i',
              idProduct: '$i',
              jmlBatch: '20',
              dateSpk: '2025-04-15',
              descSpk: 'Spk $i',
              statusSpk: 'pending',
              createdAt: '2025-04-15',
              updatedAt: '2025-04-15',
            ),
          );
        }
        _isLoading = false;
        _selectedItem = null;
        _isStarted = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    int index = 0;
    return Scaffold(
      appBar: AppBar(
        title: Text('Production Screen',
            style: Theme.of(context).textTheme.titleMedium),
        actions: [
          IconButton(
            onPressed: _isLoading
                ? null
                : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) => const SpkScreen(),
                      ),
                    );
                  },
            icon: const Icon(
              CupertinoIcons.add_circled_solid,
            ),
          ),
        ],
      ),
      body: _isLoading == false
          ? _listItem.isNotEmpty
              ? Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Container(
                          margin: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(
                                width: 1, color: Colors.grey.withAlpha(75)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ReorderableListView(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            onReorder: (int oldIndex, int newIndex) {
                              if (oldIndex < newIndex) {
                                newIndex -= 1;
                              }

                              if (_isLockedItem(_listItem[oldIndex]) == true ||
                                  _isLockedItem(_listItem[newIndex]) == true) {
                                showSnackBar(
                                    context, "Failed to change list order");
                                return;
                              }

                              setState(() {
                                final SpkModel item =
                                    _listItem.removeAt(oldIndex);
                                _listItem.insert(newIndex, item);
                              });

                              List<String> arrayItem = [];
                              for (var i = 0; i < _listItem.length; i++) {
                                final item = _listItem[i];
                                arrayItem.add(item.idSpk);
                              }
                              showSnackBar(context, '$arrayItem');
                            },
                            children: _listItem.map((item) {
                              final isLastIndex =
                                  (index == (_listItem.length - 1));
                              index++;
                              return ListTileItem(
                                key: ValueKey(item),
                                isSelected: (_selectedItem != null &&
                                        _selectedItem!.idSpk == item.idSpk)
                                    ? true
                                    : false,
                                badge: '111000222',
                                title: item.descSpk,
                                border: !isLastIndex
                                    ? Border(
                                        bottom: BorderSide(
                                            width: 1,
                                            color: Colors.grey.shade300))
                                    : null,
                                description:
                                    'Execution batch 0 of ${item.jmlBatch}',
                                customLeadingIcon: _isStarted &&
                                            _isLockedItem(item) == false ||
                                        _isStarted == false
                                    ? const Icon(
                                        Icons.drag_indicator_rounded,
                                        color: Colors.black26,
                                      )
                                    : null,
                                customTrailingIcon: _isStarted &&
                                        item.statusSpk == 'done'
                                    ? IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.check_circle_rounded,
                                          color: Colors.green.shade700,
                                        ),
                                      )
                                    : _isStarted && item.statusSpk == 'running'
                                        ? IconButton(
                                            onPressed: () {
                                              int findIndex = _listItem
                                                  .indexWhere((element) =>
                                                      element.statusSpk ==
                                                      'running');
                                              if (findIndex <=
                                                  (_listItem.length - 1)) {
                                                setState(() {
                                                  _listItem[findIndex] =
                                                      _listItem[findIndex]
                                                          .copyWith(
                                                    statusSpk: 'done',
                                                  );
                                                  if (findIndex <=
                                                      (_listItem.length - 1)) {
                                                    _listItem[findIndex + 1] =
                                                        _listItem[findIndex + 1]
                                                            .copyWith(
                                                      statusSpk: 'running',
                                                    );
                                                  }
                                                });

                                                List<String> arrayItem = [];
                                                for (var i = 0;
                                                    i < _listItem.length;
                                                    i++) {
                                                  final item = _listItem[i];
                                                  arrayItem.add(item.idSpk);
                                                }
                                                showSnackBar(
                                                    context, '$arrayItem');
                                              }
                                            },
                                            icon: Icon(
                                              Icons.stop_circle_rounded,
                                              color: Colors.red.shade700,
                                            ),
                                          )
                                        : _isStarted &&
                                                item.statusSpk == 'pending'
                                            ? IconButton(
                                                onPressed: () {},
                                                icon: Icon(
                                                  Icons.timelapse_rounded,
                                                  color: Colors.yellow.shade800,
                                                ),
                                              )
                                            : IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    _listItem.remove(item);
                                                  });
                                                },
                                                icon: const Icon(
                                                  Icons.delete_rounded,
                                                ),
                                              ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 12,
                        right: 12,
                        bottom: 12,
                      ),
                      child: FilledButton(
                        onPressed: () {
                          if (_isStarted) {
                            int runningItem = _listItem.indexWhere(
                                (element) => element.statusSpk == 'running');
                            setState(() {
                              _listItem[runningItem] = _listItem[runningItem]
                                  .copyWith(statusSpk: 'pending');
                              _isStarted = false;
                            });
                          } else {
                            setState(() {
                              _listItem[0] =
                                  _listItem[0].copyWith(statusSpk: 'running');
                              _isStarted = true;
                            });
                          }

                          List<String> arrayItem = [];
                          for (var i = 0; i < _listItem.length; i++) {
                            final item = _listItem[i];
                            arrayItem.add(item.idSpk);
                          }
                          showSnackBar(context, '$arrayItem');
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: _isStarted
                              ? Colors.red.shade800
                              : Colors.green.shade800,
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          child: Text(
                            _isStarted
                                ? 'Stop All Production'
                                : 'Start Production',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: double.infinity,
                      ),
                      const Text('There is no spk for production yet.'),
                      const SizedBox(
                        height: 8,
                      ),
                      FilledButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (ctx) => const SpkScreen(),
                            ),
                          );
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24),
                          child: Text('Select Spk'),
                        ),
                      ),
                    ],
                  ),
                )
          : Container(
              width: double.infinity,
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.grey.withAlpha(75)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Loading..',
                textAlign: TextAlign.center,
              ),
            ),
    );
  }

  bool _isLockedItem(SpkModel item) {
    if (item.statusSpk == 'running' || item.statusSpk == 'done') {
      return true;
    } else {
      return false;
    }
  }
}
