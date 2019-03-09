# Animated Stream List

A Flutter library to easily display a list with animated changes from a ```Stream<List<E>>```.
It's like ```StreamBuilder + ListView.Builder``` with animations.
Taken inspiration from the [Animated List Sample](https://flutter.dev/docs/catalog/samples/animated-list) and [Java-diff-utils](https://github.com/KengoTODA/java-diff-utils)
```dart
// create tile view as the user is going to see it, attach any onClick callbacks etc.
Widget _createTile(String s, Animation<double> animation) {
  return SizeTransition(  
    axis: Axis.vertical,  
    sizeFactor: animation,  
    child: const Text(s),
  );
}

// what is going to be shown as the tile is being removed, usually same as above but without any 
// onClick callbacks as, most likely, you don't want the user to interact with a removed view
Widget _createRemovedTile(String s, Animation<double> animation) {
  return SizeTransition(  
    axis: Axis.vertical,  
    sizeFactor: animation,  
    child: const Text(s),
  );
}

final Stream<List<String>> list = // get list from some source, like BLOC
final animatedView = AnimatedStreamList<String>(  
  streamList: list,  
  itemBuilder: (String s, BuildContext context, Animation<double> animation) =>  
    _createTile(s, animation),  
  itemRemovedBuilder: (String s, BuildContext context, Animation<double> animation) =>  
    _createRemovedTile(s, animation),
  );  
}
```

## Getting Started
TBD
## Parameters
```dart
@required Stream<List<E>> streamList;
```
```dart
@required AnimatedStreamListItemBuilder<E> itemBuilder;  
@required AnimatedStreamListItemBuilder<E> itemRemovedBuilder;  
```
```AnimatedStreamListItemBuilder``` is just a function which builds a tile
```dart
typedef Widget AnimatedStreamListItemBuilder<T>(T item, BuildContext context, Animation<double> animation);
```
## Options 
```dart
Equalizer<E> equals; 
```
Compares items for equality, by default it uses the ```==``` operator, it's critical for this to work properly.

```Equalizer``` is function, that, given two items of the same type, returns true if they are equal, false otherwise
```dart
typedef bool Equalizer<E>(E item1, E item2);
```

You can check the [Animated List Documentation](https://docs.flutter.io/flutter/widgets/AnimatedList-class.html) for the rest:
```dart
final Axis scrollDirection;  
final bool reverse;  
final ScrollController scrollController;  
final bool primary;  
final ScrollPhysics scrollPhysics;  
final bool shrinkWrap;  
final EdgeInsetsGeometry padding;  
```

