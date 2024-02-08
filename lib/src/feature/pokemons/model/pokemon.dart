// ignore_for_file: public_member_api_docs

/// Pokemon model
class Pokemon {
  final int id;
  final String name;
  final String cname;
  final String jname;
  final String image;
  final Skills skills;

  /// Create a Pokemon
  Pokemon({
    required this.id,
    required this.name,
    required this.cname,
    required this.jname,
    required this.image,
    required this.skills,
  });

  /// Create a Pokemon from a JSON object
  factory Pokemon.fromJson(Map<String, dynamic> json) => Pokemon(
        id: json['id'] as int,
        name: json['name'] as String,
        cname: json['cname'] as String,
        jname: json['jname'] as String,
        image: json['image'] as String,
        skills: Skills.fromJson(json['skills'] as Map<String, Object?>),
      );

  @override
  String toString() => 'Pokemon{id: $id,'
      'name: $name, '
      'cname: $cname, '
      'jname: $jname, '
      'image: $image, '
      'skills: $skills}';
}

/// make list operations type safe
class Phases {
  final int first;
  final int second;
  final int third;

  /// Create a Phases
  Phases({
    required this.first,
    required this.second,
    required this.third,
  });

  @override
  String toString() => '$first, $second, $third';
}

/// Create a JSON object from a Pokemon
class Skills {
  final Phases egg;
  final Phases levelUp;
  final Phases tm;
  final Phases transfer;
  final Phases tutor;

  /// Create a Skills
  Skills({
    required this.egg,
    required this.levelUp,
    required this.tm,
    required this.transfer,
    required this.tutor,
  });

  /// Create a Skills from a JSON object
  factory Skills.fromJson(Map<String, Object?> json) => Skills(
        egg: _convertJsonListToPhases(json['egg']),
        levelUp: _convertJsonListToPhases(json['level_up']),
        tm: _convertJsonListToPhases(json['tm']),
        transfer: _convertJsonListToPhases(json['transfer']),
        tutor: _convertJsonListToPhases(json['tutor']),
      );
}

Phases _convertJsonListToPhases(Object? list) {
  assert(list is Iterable && list.length == 3, 'List length must be 3');

  final listOfInts =
      (list! as List<Object?>).whereType<int>().toList(growable: false);

  return Phases(
    first: listOfInts[0],
    second: listOfInts[1],
    third: listOfInts[2],
  );
}
