import 'package:greentrack/models/MyFiles.dart';
import 'package:greentrack/responsive.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../services/bottle_service.dart';
import '../../../services/production_service.dart';
import '../../../services/rack_service.dart';
import '../../../services/vente_service.dart';
import 'file_info_card.dart';

class MyFiles extends StatelessWidget {
  const MyFiles({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Mes performances",
              style: TextStyle(color: Colors.black,fontSize: 20),
            ),

          ],
        ),
        SizedBox(height: defaultPadding),
        Responsive(
          mobile: FileInfoCardGridView(
            crossAxisCount: _size.width < 650 ? 2 : 4,
            childAspectRatio: _size.width < 650 && _size.width > 350 ? 1.3 : 1,
          ),
          tablet: FileInfoCardGridView(),
          desktop: FileInfoCardGridView(
            childAspectRatio: _size.width < 1400 ? 1.1 : 1.4,
          ),
        ),
      ],
    );
  }
}

class FileInfoCardGridView extends StatefulWidget {
  const FileInfoCardGridView({
    Key? key,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1,
  }) : super(key: key);

  final int crossAxisCount;
  final double childAspectRatio;

  @override
  State<FileInfoCardGridView> createState() => _FileInfoCardGridViewState();
}

class _FileInfoCardGridViewState extends State<FileInfoCardGridView> {
  var allBottles;
  var allVentes;
  var allRacks;
  var allProductions;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //init();
  }
  init()async{
    var ventes = await VentesService().getVentes();
    var racks = RackService().getRacks();
    var productions = ProductionService().getProductions();
    var bottleData = await BouteilleService().getBottles();


    setState(() {
      allBottles = bottleData;
      allVentes = ventes;
      allRacks = racks;
      allProductions = productions;
    });
  }
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: demoMyFiles.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.crossAxisCount,
        crossAxisSpacing: defaultPadding,
        mainAxisSpacing: defaultPadding,
        childAspectRatio: widget.childAspectRatio,
      ),
      itemBuilder: (context, index) => FileInfoCard(
        info: demoMyFiles[index],
        nb_item: 1540),
    );
  }
}
