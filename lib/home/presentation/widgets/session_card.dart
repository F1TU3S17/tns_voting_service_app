import 'package:flutter/material.dart';
import 'package:tns_voting_service_app/core/utils/parse_date.dart';

class SessionCard extends StatelessWidget {
  final String title;
  final String description;
  final String sessionType;
  final String votesInfo;
  final DateTime date;

  const SessionCard({
    super.key,
    required this.title,
    required this.description,
    required this.sessionType,
    required this.votesInfo,
    required this.date
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
              child: _SessionHeader(title: title, theme: theme, endDate: date,),
            ),
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
  final DateTime endDate;

  const _SessionHeader({
    Key? key,
    required this.title,
    required this.theme,
    required this.endDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: theme.textTheme.labelLarge), 
        Text(parseDate(endDate), style: theme.textTheme.labelSmall),
      ]
    );
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
    return Container(
      alignment: Alignment.centerRight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.person_2_outlined),
              SizedBox(width: 4),
              Text(
                sessionType,
                style: theme.textTheme.labelSmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.bolt),
              SizedBox(width: 4),
              Text(
                votesInfo,
                style: theme.textTheme.labelSmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
