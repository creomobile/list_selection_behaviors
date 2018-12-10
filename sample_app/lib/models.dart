import 'dart:math';

import 'package:english_words/english_words.dart';
import 'package:meta/meta.dart';

class ModelBase {
  static int _lastId = 0;
  final int id;
  ModelBase({@required this.id});

  static _getNextId() => ++_lastId;
}

class User extends ModelBase {
  final String firstName, lastName;
  User._({@required int id, @required this.firstName, @required this.lastName})
      : super(id: id);
  User.create()
      : this._(
            id: ModelBase._getNextId(),
            firstName: _getFirstName(),
            lastName: _getLastName());

  static _getFirstName() => names[_random.nextInt(names.length)];
  static _getLastName() => familyNames[_random.nextInt(familyNames.length)];

  static final _random = Random();
  static const names = [
    'Abigail',
    'Alexander',
    'Amelia',
    'Ava',
    'Barbara',
    'Bethany',
    'Callum',
    'Charles',
    'Charlie',
    'Charlotte',
    'Connor',
    'Damian',
    'Daniel',
    'David',
    'Elizabeth',
    'Emily',
    'Emma',
    'Ethan',
    'George',
    'Harry',
    'Isabella',
    'Isla',
    'Jack',
    'Jacob',
    'Jake',
    'James',
    'Jennifer',
    'Jessica',
    'Joanne',
    'Joe',
    'John',
    'Joseph',
    'Kyle',
    'Lauren',
    'Liam',
    'Lily',
    'Linda',
    'Madison',
    'Margaret',
    'Mary',
    'Mason',
    'Megan',
    'Mia',
    'Michael',
    'Michelle',
    'Noah',
    'Olivia',
    'Oscar',
    'Patricia',
    'Poppy',
    'Reece',
    'Rhys',
    'Richard',
    'Robert',
    'Samantha',
    'Sarah',
    'Sophie',
    'Susan',
    'Thomas',
    'Tracy',
    'Victoria',
    'William'
  ];
  static const familyNames = [
    "Anderson",
    "Brown",
    "Byrne",
    "Davies",
    "Davis",
    "Evans",
    "Gagnon",
    "Garcia",
    "Gelbero",
    "Johnson",
    "Jones",
    "Lam",
    "Lee",
    "Li",
    "Martin",
    "Miller",
    "Morton",
    "Murphy",
    "O'Brien",
    "O'Connor",
    "O'Kelly",
    "O'Neill",
    "O'Ryan",
    "O'Sullivan",
    "Roberts",
    "Rodriguez",
    "Roy",
    "Singh",
    "Smith",
    "Taylor",
    "Thomas",
    "Tremblay",
    "Walsh",
    "Wang",
    "White",
    "Williams",
    "Wilson"
  ];
}

class Company extends ModelBase {
  final String name;
  Company._({@required int id, @required this.name}) : super(id: id);
  Company.create()
      : this._(
            id: ModelBase._getNextId(), name: WordPair.random().asPascalCase);
}

class Separator {}
