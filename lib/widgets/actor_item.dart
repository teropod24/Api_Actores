// actor_item.dart
import 'package:flutter/material.dart';
import 'package:movies/models/actors.dart';

class ActorItem extends StatelessWidget {
  final Actor actor;

  const ActorItem({Key? key, required this.actor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          actor.profilePath.isNotEmpty
              ? ClipOval(
                  child: Image.network(
                    'https://image.tmdb.org/t/p/w500/${actor.profilePath}',
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                )
              : Icon(
                  Icons.person,
                  size: 100,
                  color: Colors.grey,
                ),
          const SizedBox(height: 8),
          Text(
            actor.name,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}