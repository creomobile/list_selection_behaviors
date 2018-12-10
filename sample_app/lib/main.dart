import 'package:flutter/material.dart';
import 'package:observable/observable.dart';
import 'package:sample_app/listHelper.dart';
import 'package:sample_app/models.dart';
import 'package:sample_app/sampleListBloc.dart';

void main() => runApp(MaterialApp(home: SampleList()));

class SampleList extends StatelessWidget {
  final _bloc = SampleListBloc();

  _addingReplacingSwitcher() => StreamBuilder<bool>(
      initialData: _bloc.currentIsAdding,
      stream: _bloc.isAdding,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        var isAdding = snapshot.data;
        var color = isAdding ? Colors.green : Colors.blue;
        return SizedBox(
            width: 120,
            child: RaisedButton(
              color: color.shade100,
              onPressed: () => _bloc.adding.add(!_bloc.currentIsAdding),
              child: Row(
                children: <Widget>[
                  Icon(Icons.add, color: color),
                  Expanded(
                      child: Center(
                          child: Text(
                    isAdding ? 'Adding' : 'Replacing',
                    style: TextStyle(color: color.shade900),
                  )))
                ],
              ),
            ));
      });

  _listItemActionText(String itemType) => StreamBuilder<bool>(
      initialData: _bloc.currentIsAdding,
      stream: _bloc.isAdding,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) => Text(
          '${snapshot.data ? 'Add' : 'Replace'}\n$itemType',
          textAlign: TextAlign.center));

  _listControlPanel() => Column(children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _addingReplacingSwitcher(),
            RaisedButton(child: Text('Refresh'), onPressed: _bloc.refresh),
            RaisedButton(child: Text('Clear'), onPressed: _bloc.clear)
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(width: 32, child: TextField()),
            RaisedButton(
                child: _listItemActionText('Person'),
                onPressed: _bloc.insertUser),
            RaisedButton(
                child: _listItemActionText('Company'),
                onPressed: _bloc.insertCompany),
            RaisedButton(
                child: _listItemActionText('Separator'),
                onPressed: _bloc.insertSeparator)
          ],
        )
      ]);

  _selectionDivider() => Padding(
      padding: EdgeInsets.only(top: 8, bottom: 8),
      child: Row(children: <Widget>[
        SizedBox(width: 32, child: Divider(color: Colors.black)),
        Padding(
            padding: EdgeInsets.only(left: 8, right: 8),
            child: Text('Selection')),
        Expanded(child: Divider(color: Colors.black))
      ]));

  _keyValue(String key, String value) => Padding(
      padding: EdgeInsets.only(left: 8),
      child: Row(children: <Widget>[
        Text(key + ':'),
        Padding(padding: EdgeInsets.only(left: 4), child: Text(value))
      ]));

  _selectionControlPanel() => Row(children: <Widget>[
        new DropdownButton<String>(
          value: 'Single',
          items: <String>[
            'Multi',
            'OneOrMore',
            'OneOrMoreInit',
            'SingleOrNone',
            'SingleOrNoneInit',
            'Single',
            'SingleInit'
          ].map((String value) {
            return new DropdownMenuItem<String>(
              value: value,
              child: new Text(value),
            );
          }).toList(),
          onChanged: (_) {},
        ),
        Padding(
            padding: EdgeInsets.only(left: 8),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(children: <Widget>[
                    _keyValue('Count', '0'),
                    _keyValue('Id', '0')
                  ]),
                  _keyValue('Ids', '22, 33')
                ]))
      ]);

  Widget _listItem(Object item) {
    final removeButton = IconButton(
        icon: Icon(Icons.delete_sweep), onPressed: () => _bloc.remove(item));

    if (item is User) {
      return ListTile(
          leading: CircleAvatar(
              child: Text('${item.firstName[0]}${item.lastName[0]}')),
          title: Text('${item.firstName} ${item.lastName}'),
          trailing: removeButton);
    } else if (item is Company) {
      return ListTile(
          leading: CircleAvatar(child: Icon(Icons.people), backgroundColor: Colors.green),
          title: Text('${item.name}'),
          trailing: removeButton);
    }
    else if (item is Separator){
      return ListTile(trailing: removeButton);
    }
    return null;
  }

  _list() => ListHelper.createAnimatedObserverList(_bloc.items, _listItem);

  @override
  Widget build(BuildContext context) => Scaffold(
      body: SafeArea(
          child: Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                children: <Widget>[
                  _listControlPanel(),
                  _selectionDivider(),
                  _selectionControlPanel(),
                  Expanded(child: _list())
                ],
              ))));
}

/*

void main() {
  runApp(
    MaterialApp(
      home: AnimatedListDemo(),
    ),
  );
}

class UserModel {
  UserModel({this.firstName, this.lastName, this.profileImageUrl});
  String firstName;
  String lastName;
  String profileImageUrl;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModel &&
          runtimeType == other.runtimeType &&
          firstName == other.firstName &&
          lastName == other.lastName &&
          profileImageUrl == other.profileImageUrl;

  @override
  int get hashCode =>
      firstName.hashCode ^ lastName.hashCode ^ profileImageUrl.hashCode;
}

List<UserModel> listData = [
  UserModel(
    firstName: "Nash",
    lastName: "Ramdial",
    profileImageUrl:
        "https://avatars0.githubusercontent.com/u/25711804?s=460&v=4",
  ),
  UserModel(
    firstName: "Scott",
    lastName: "Stoll",
    profileImageUrl:
        "https://avatars0.githubusercontent.com/u/25711804?s=460&v=4",
  ),
  UserModel(
    firstName: "Simon",
    lastName: "Lightfoot",
    profileImageUrl:
        "https://avatars0.githubusercontent.com/u/25711804?s=460&v=4",
  ),
  UserModel(
    firstName: "Jay",
    lastName: "Meijer",
    profileImageUrl:
        "https://avatars0.githubusercontent.com/u/25711804?s=460&v=4",
  ),
  UserModel(
    firstName: "Mariano",
    lastName: "Zorrilla",
    profileImageUrl:
        "https://avatars0.githubusercontent.com/u/25711804?s=460&v=4",
  ),
];

class AnimatedListDemo extends StatefulWidget {
  _AnimatedListDemoState createState() => _AnimatedListDemoState();
}

class _AnimatedListDemoState extends State<AnimatedListDemo> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();

  void addUser() {
    int index = listData.length;
    listData.add(
      UserModel(
        firstName: "Norbert",
        lastName: "Kozsir",
        profileImageUrl:
            "https://avatars0.githubusercontent.com/u/25711804?s=460&v=4",
      ),
    );
    _listKey.currentState
        .insertItem(index, duration: Duration(milliseconds: 500));
  }

  void deleteUser(int index) {
    var user = listData.removeAt(index);
    _listKey.currentState.removeItem(
      index,
      (BuildContext context, Animation<double> animation) {
        return FadeTransition(
          opacity:
              CurvedAnimation(parent: animation, curve: Interval(0.5, 1.0)),
          child: SizeTransition(
            sizeFactor:
                CurvedAnimation(parent: animation, curve: Interval(0.0, 1.0)),
            axisAlignment: 0.0,
            child: _buildItem(user),
          ),
        );
      },
      duration: Duration(milliseconds: 600),
    );
  }

  Widget _buildItem(UserModel user, [int index]) {
    return ListTile(
      key: ValueKey<UserModel>(user),
      title: Text(user.firstName),
      subtitle: Text(user.lastName),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(user.profileImageUrl),
      ),
      onLongPress: index != null ? () => deleteUser(index) : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Animated List Demo"),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.add),
          onPressed: addUser,
        ),
      ),
      body: SafeArea(
        child: AnimatedList(
          key: _listKey,
          initialItemCount: listData.length,
          itemBuilder: (BuildContext context, int index, Animation animation) {
            return FadeTransition(
              opacity: animation,
              child: _buildItem(listData[index], index),
            );
          },
        ),
      ),
    );
  }
}
*/

/*
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
*/
