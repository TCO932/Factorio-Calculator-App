import 'package:factorio_calculator/classes/protoItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_simple_treeview/flutter_simple_treeview.dart';

import '../api.dart';
import '../classes/detailedCraft.dart';
import '../widgets/itemCard.dart';

class ItemTreeCraftFrame extends StatefulWidget {
  const ItemTreeCraftFrame({
    Key? key,
    required this.itemName,
    this.speed = 1,
    this.assemblingMachine = 'assembling-machine-3',
    this.productivity = false,
  }) : super(key: key);
  final String itemName;
  final double speed;
  final String assemblingMachine;
  final bool productivity;

  @override
  _ItemTreeCraftFrameState createState() => _ItemTreeCraftFrameState();
}

class _ItemTreeCraftFrameState extends State<ItemTreeCraftFrame> {
  final TreeController _controller = TreeController(allNodesExpanded: false);

  late Future<Map<String, dynamic>> futureCraftTree;

  // @override
  // void initState() {
  //   super.initState();
  //   futureCraftTree = fetchCraftTree(widget.itemName, widget.speed,
  //       widget.assemblingMachine, widget.productivity);
  // }

  @override
  Widget build(BuildContext context) {
    DateTime _now = DateTime.now();
    print(
        '${_now.hour}:${_now.minute}:${_now.second}.${_now.millisecond} - rebuilding itemTreeCraftFrame...');
    print('${widget.productivity}');
    futureCraftTree = fetchCraftTree(widget.itemName, widget.speed,
        widget.assemblingMachine, widget.productivity);
    return FutureBuilder(
      future: futureCraftTree,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          DetailedCraft detailedCraft = DetailedCraft.FromJson(snapshot.data);
          return Scrollbar(
            child: SingleChildScrollView(
              child: TreeView(
                indent: 5,
                treeController: _controller,
                nodes: [
                  craftNode(detailedCraft, widget.speed),
                ],
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  TreeNode craftNode(DetailedCraft detailedCraft, double speed) {
    // Key key = UniqueKey();
    List<TreeNode> components = [];
    if (!detailedCraft.elementary) {
      for (var entry in detailedCraft.components!) {
        DetailedCraft detailedComponent = DetailedCraft.FromJson(entry);
        components.add(craftNode(detailedComponent, detailedComponent.speed));
      }
    }
    return TreeNode(
      content: Container(
        width: 300,
        child: ItemCard(
            item: ProtoItem(
                name: detailedCraft.itemName,
                quantity: detailedCraft.speed,
                elementary: detailedCraft.elementary),
            amAmount: detailedCraft.assemblingMachinesAmount),
      ),
      children: components,
    );
  }
}
