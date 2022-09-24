import 'package:factorio_calculator/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../api.dart';
import 'itemResourcesFrame.dart';
import 'itemTreeCraftFrame.dart';

enum AssemblingMachines { asm1, asm2, asm3 }

class ItemCraft extends StatefulWidget {
  const ItemCraft({Key? key, required this.title, required this.itemName})
      : super(key: key);
  final String title;
  final String itemName;
  final String resourcesFrameTitle = 'Resources';
  final String craftTreeFrameTitle = 'Tree';

  @override
  State<ItemCraft> createState() => _ItemCraftState();
}

class _ItemCraftState extends State<ItemCraft> {
  double speed = 1;
  Map<String, dynamic>? assemblingMachines;
  Future<Map<String, dynamic>>? futureAssemblingMachines;
  String? assemblingMachine;
  bool productivity = true;
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<Widget> settings = [];

  ListTile getOption(String asmName) {
    return ListTile(
      title: Text(prettify(asmName)),
      leading: Radio<String>(
        value: asmName,
        groupValue: assemblingMachine,
        onChanged: (String? value) {
          setState(() {
            assemblingMachine = value;
          });
        },
      ),
    );
  }

  List<Widget> getOptions() {
    List<Widget> options = [];
    assemblingMachines!.forEach((key, value) => options.add(getOption(key)));
    return options;
  }

  @override
  initState() {
    super.initState();
    futureAssemblingMachines = fetchAssemblingMachines();
    _controller.text = speed.toStringAsPrecision(2);
    _controller.addListener(() => {
          if (speed !=
              double.parse(_controller.text.isEmpty ? '0' : _controller.text))
            {
              setState(() {
                speed = double.parse(
                    _controller.text.isEmpty ? '0' : _controller.text);
              })
            }
        });
  }

  @override
  Widget build(BuildContext context) {
    DateTime _now = DateTime.now();
    print(
        '${_now.hour}:${_now.minute}:${_now.second}.${_now.millisecond} - rebuilding itemCraft...');
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
            actions: [],
            bottom: TabBar(
              tabs: [
                Tab(text: widget.resourcesFrameTitle),
                Tab(text: widget.craftTreeFrameTitle),
              ],
            ),
          ),
          endDrawer: Drawer(
            child: FutureBuilder(
                future: futureAssemblingMachines,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    assemblingMachines ??= snapshot.data;
                    assemblingMachine ??= assemblingMachines!.keys.last;
                    return ListView(
                      children: [
                        DrawerHeader(
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Padding(
                                padding: EdgeInsets.only(bottom: 8.0),
                                child: Text(
                                  'Settings',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                              ),
                            ],
                          ),
                        ),
                        ...getOptions(),
                        ListTile(
                          title: const Text(
                            'Productivity',
                          ),
                          leading: Checkbox(
                            value: productivity,
                            onChanged: (bool? value) {
                              setState(() {
                                productivity = value!;
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: TextField(
                            decoration:
                                const InputDecoration(labelText: "Enter speed"),
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'(^-?\d*\.?\d*)'))
                            ],
                            controller: _controller,
                          ),
                        ),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }),
          ),
          body: TabBarView(
            children: [
              ItemResourcesFrame(itemName: widget.itemName),
              FutureBuilder(
                  future: futureAssemblingMachines,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      assemblingMachines ??= snapshot.data;
                      assemblingMachine ??= assemblingMachines!.keys.last;
                      return ItemTreeCraftFrame(
                        itemName: widget.itemName,
                        speed: speed,
                        assemblingMachine: assemblingMachine!,
                        productivity: productivity,
                      );
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }

  /// Adds scrolling and padding to the [content].
  Widget buildBodyFrame(Widget content) {
    return SingleChildScrollView(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: content,
        ),
      ),
    );
  }
}
