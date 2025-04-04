import 'package:flutter/material.dart';

class SessionCard extends StatelessWidget {
  final String title;
  final String description;
  final String sessionType;
  final String votesInfo;

  const SessionCard({
    Key? key,
    required this.title,
    required this.description,
    required this.sessionType,
    required this.votesInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            _SessionHeader(title: title, theme: theme),
            _SessionContent(
              description: description, 
              sessionType: sessionType, 
              votesInfo: votesInfo,
              theme: theme,
            ),
          ],
        ),
      ),
    );
  }
}

class _SessionHeader extends StatelessWidget {
  final String title;
  final ThemeData theme;

  const _SessionHeader({
    Key? key,
    required this.title,
    required this.theme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(title, style: theme.textTheme.labelLarge);
  }
}

class _SessionContent extends StatelessWidget {
  final String description;
  final String sessionType;
  final String votesInfo;
  final ThemeData theme;

  const _SessionContent({
    Key? key,
    required this.description,
    required this.sessionType,
    required this.votesInfo,
    required this.theme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SessionDescription(description: description, theme: theme),
          _SessionMetadata(
            sessionType: sessionType, 
            votesInfo: votesInfo, 
            theme: theme,
          ),
        ],
      ),
    );
  }
}

class _SessionDescription extends StatelessWidget {
  final String description;
  final ThemeData theme;

  const _SessionDescription({
    Key? key,
    required this.description,
    required this.theme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 2,
      child: Text(
        description,
        maxLines: 5,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.labelSmall,
      ),
    );
  }
}

class _SessionMetadata extends StatelessWidget {
  final String sessionType;
  final String votesInfo;
  final ThemeData theme;

  const _SessionMetadata({
    Key? key,
    required this.sessionType,
    required this.votesInfo,
    required this.theme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 1,
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.person_2_outlined),
              Expanded(
                child: Text(
                  sessionType,
                  style: theme.textTheme.labelSmall,
                  maxLines: 2,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Row(
            children: [
              const Icon(Icons.bolt,),
              Expanded(
                child: Text(
                  votesInfo,
                  style: theme.textTheme.labelSmall,
                  maxLines: 2,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
