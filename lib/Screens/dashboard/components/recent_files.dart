import 'package:greentrack/models/RecentFile.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../constants.dart';

class RecentFiles extends StatelessWidget {
  const RecentFiles({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Activités récentes",
            style: TextStyle(color: Colors.black),
          ),
          SizedBox(
            width: double.infinity,
            child: DataTable(
              columnSpacing: defaultPadding,
              // minWidth: 600,
              columns: [
                DataColumn(
                  label: Text("Libellé",style:TextStyle(color: Colors.black)),
                ),
                DataColumn(
                  label: Text("Date",style:TextStyle(color: Colors.black)),
                ),
                DataColumn(
                  label: Text("Quantité",style:TextStyle(color: Colors.black)),
                ),
              ],
              rows: List.generate(
                demoRecentFiles.length,
                (index) => recentFileDataRow(demoRecentFiles[index]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

DataRow recentFileDataRow(RecentFile fileInfo) {
  return DataRow(
    cells: [
      DataCell(
        Row(
          children: [
            SvgPicture.asset(
              fileInfo.icon!,
              height: 30,
              width: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Text(fileInfo.title!,style:TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
      DataCell(Text(fileInfo.date!,style:TextStyle(color: Colors.black))),
      DataCell(Text(fileInfo.size!,style:TextStyle(color: Colors.black))),
    ],
  );
}
