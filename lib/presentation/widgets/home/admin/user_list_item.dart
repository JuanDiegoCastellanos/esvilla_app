
import 'package:flutter/material.dart';

class UserListItem extends StatelessWidget {
  final String userName;
  final String userEmail;
  final VoidCallback onDeleteTap;
  final VoidCallback onEditTap;
  const UserListItem(
    {
    required this.onEditTap,
    required this.userName,
    required this.userEmail,
    required this.onDeleteTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: Card(
        color: Colors.blue.shade100,
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.lightBlue.shade300,
            radius: 25,
            child: Text(
              userName.substring(0, 1).toUpperCase(),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
            ),
          ),
          title: Text(
            userName,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ), // replace with actual user name
          subtitle: Text(
            userEmail,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ), // replace with actual user info
          onTap: () {},
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.edit,
                  color: Colors.blue,
                  size: 30,
                ),
                onPressed: onEditTap,
              ),
              IconButton(
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                  size: 30,
                ),
                onPressed: onDeleteTap,
              ),
            ],
          ),
        ),
      ),
    );
  }
}