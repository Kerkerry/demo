import 'package:demo/src/authentication/presentation/cubit/authentication_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class AddUserDialog extends StatelessWidget {
  const AddUserDialog({super.key, required this.nameController});
  final TextEditingController nameController;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "username",
                ),
              ),
              const SizedBox(height: 10,),
              ElevatedButton(onPressed: (){
                final name=nameController.text.trim();
                const avatar="https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/1087.jpg";
                context.read<AuthenticationCubit>().createUser(name: name, avatar: avatar, createdAt: DateTime.now().toString());
                nameController.clear();
                Navigator.of(context).pop();
              }, child: const Text("Create User"))
            ],
          ),
        ),
      ),
    );
  }
}