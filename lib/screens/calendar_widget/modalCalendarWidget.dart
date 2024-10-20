import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';



class Modalcalendarwidget extends StatelessWidget {
  const Modalcalendarwidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wolt Modal Bottom Sheet Sample'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          WoltModalSheet.show(
            context: context,
            pageListBuilder: (bottomSheetContext) => [
              SliverWoltModalSheetPage(
                mainContentSliversBuilder: (context) => [
                  SliverList.builder(
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text('Index is $index'),
                        onTap: Navigator.of(bottomSheetContext).pop,
                      );
                    },
                  ),
                ],
              )
            ],
          );
        },
        label: const Text('Trigger Wolt Sheet'),
      ),
    );
  }
  }
