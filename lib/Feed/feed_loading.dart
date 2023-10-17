
import 'package:flutter/material.dart';

class HomeLoading extends StatelessWidget{
  const HomeLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 5,
            shadowColor: Colors.black,
            surfaceTintColor: Colors.white,
            child: Container(
              padding: const EdgeInsets.all(4),
              child: const SizedBox(
                width: 500,
                height: 170,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 5,
              shadowColor: Colors.black,
              surfaceTintColor: Colors.white,
              child: Container(
                padding: const EdgeInsets.all(4),
                child: const SizedBox(
                  width: 500,
                  height: 600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}