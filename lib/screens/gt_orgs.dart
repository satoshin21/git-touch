import 'package:flutter/material.dart';
import 'package:git_touch/models/auth.dart';
import 'package:git_touch/models/gitea.dart';
import 'package:git_touch/scaffolds/list_stateful.dart';
import 'package:git_touch/widgets/app_bar_title.dart';
import 'package:git_touch/widgets/user_item.dart';
import 'package:provider/provider.dart';

class GtOrgsScreen extends StatelessWidget {
  // final String branch; // TODO:
  Future<ListPayload<GiteaOrg, int>> _query(BuildContext context,
      [int page = 1]) async {
    final auth = Provider.of<AuthModel>(context);
    final res = await auth.fetchGiteaWithPage('/orgs?limit=20');
    return ListPayload(
      cursor: res.cursor,
      hasMore: res.hasMore,
      items: (res.data as List).map((v) => GiteaOrg.fromJson(v)).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListStatefulScaffold<GiteaOrg, int>(
      title: AppBarTitle('Organizations'),
      onRefresh: () => _query(context),
      onLoadMore: (cursor) => _query(context, cursor),
      itemBuilder: (v) {
        return UserItem(
          avatarUrl: v.avatarUrl,
          login: v.username,
          bio: Text(v.description ?? ''),
          url: '/gitea/${v.username}?org=1',
        );
      },
    );
  }
}
