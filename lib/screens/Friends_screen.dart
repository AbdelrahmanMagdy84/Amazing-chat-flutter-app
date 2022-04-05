import 'package:amazing_chat/provider/user_Provider.dart';
import 'package:amazing_chat/screens/splash_screen.dart';
import 'package:amazing_chat/widgets/others/app_bar_title_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/drawer/custom_drawer.dart';
import '../widgets/friends/friend_grid_item.dart';

class FriendsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future:
          Provider.of<CurrentUserProvider>(context, listen: false).setData(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashWidget();
        }
        return 

        Scaffold(
          drawer: Consumer<CurrentUserProvider>(
            builder: ((context, currentUser, _) {
              
              return CustomDrawer(currentUser.getData["imageUrl"]!,
                  currentUser.getData["username"]!);
            }),
          ),
          appBar: AppBar(
            iconTheme:
                IconThemeData(color: Theme.of(context).colorScheme.secondary),
            centerTitle: true,
            title: AppBarTitle(null),
            actions: [
              DropdownButton(
                  dropdownColor: Theme.of(context).colorScheme.secondary,
                  underline: Container(),
                  icon: Icon(
                    Icons.more_vert,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  items: [
                    DropdownMenuItem(
                      child: Row(
                        children: [
                          Icon(Icons.exit_to_app,
                              color: Theme.of(context).colorScheme.primary),
                          Text(
                            'Logout',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary),
                          ),
                        ],
                      ),
                      value: "logout value",
                    ),
                  ],
                  onChanged: (value) {
                    if (value == "logout value") {
                      Provider.of<CurrentUserProvider>(context, listen: false)
                          .clear();
                      FirebaseAuth.instance.signOut();
                    }
                  })
            ],
          ),
          body: FutureBuilder(
            future: FirebaseFirestore.instance
                .collection("users")
                .where("email",
                    isNotEqualTo: FirebaseAuth.instance.currentUser!.email)
                .get(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshots) {
              if (snapshots.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              final users = snapshots.data!.docs;
              return Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: GridView.builder(
                  itemCount: users.length,
                  itemBuilder: ((context, index) {
                    return FriendGridItem(
                      users: users,
                      index: index,
                    );
                  }),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: 3 / 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 20),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
