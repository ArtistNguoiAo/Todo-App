import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/screen/create_note/create_note_screen.dart';
import 'package:todo_app/screen/create_note/cubit/create_note_cubit.dart';
import 'package:todo_app/screen/list_category/cubit/list_category_cubit.dart';
import 'package:todo_app/screen/list_note/cubit/list_note_cubit.dart';
import 'package:todo_app/utils/string_utils.dart';
import 'package:todo_app/screen/list_category/list_category_screen.dart';
import 'package:todo_app/screen/list_note/list_note_screen.dart';

import '../../database/firebase_auth.dart';
import '../../widget/dialog.dart';
import '../create_category/create_category_screen.dart';
import '../create_category/cubit/create_category_cubit.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        body: Stack(
        children: [
          IndexedStack(
            index: _selectedIndex,
            children: [
              ListNoteScreen(),
              ListCategoryScreen(),
            ],
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 12, // Tránh tai thỏ/camera nốt ruồi
            right: 8,
            child: IconButton(
              icon: const Icon(Icons.logout_rounded, color: Colors.black54, size: 28),
              onPressed: () {
                AppDialog.showConfirmDialog(
                  context: context,
                  onDelete: () async{
                    await AuthService().signOut();
                  },
                  text: StringUtils.logout,
                  content: StringUtils.confirmLogout,
                );
              },
            ),
          ),
          Positioned(
            bottom: 32,
            left: screenWidth * 0.4 /2,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.grey[300]!,
                    width: 1,
                  )
              ),
              width: screenWidth*0.6,
              margin: EdgeInsets.only(bottom: 24),
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildTabItem(
                    index: 0,
                    icon: Icons.fact_check_outlined,
                    label: StringUtils.note,
                    onTap: () {
                      setState(() {
                        _selectedIndex = 0;
                      });
                    }
                  ),
                  _buildTabItem(
                    index: 1,
                    icon: Icons.local_offer_outlined,
                    label: StringUtils.catalog1,
                    onTap: () {
                      setState(() {
                        _selectedIndex = 1;
                      });
                    }
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
        floatingActionButton: Container(
          margin: EdgeInsets.only(bottom: 120, right: 20),
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child: FloatingActionButton(
          onPressed: () async {
            if(_selectedIndex == 0){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => BlocProvider(
                        create: (_) => CreateNoteCubit(),
                        child: CreateNoteScreen(),
                      )
                  ),
              ).then((result) {
                if (result == true) {
                  context.read<ListNoteCubit>().loadNotes();
                }
              });
            }
            else{
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider(
                    create: (_) => CreateCategoryCubit(),
                    child: const CreateCategoryScreen(),
                  ),
                ),
              ).then((result) {
                if (result == true) {
                  context.read<ListCategoryCubit>().loadCategories();
                }
              });
            }
          },
          backgroundColor: Colors.red,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 6,
          child: const Icon(Icons.add, color: Colors.white, size: 60),
          ),
        ),
);
  }

  Widget _buildTabItem({
    required int index,
    required IconData icon,
    required String label,
    required Function() onTap,
  }){
    final Color itemColor = _selectedIndex == index ? Colors.black : Colors.grey ;
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: itemColor,),
          SizedBox(height: 4,),
          Text(label, style: TextStyle(color: itemColor),),
          _selectedIndex == index
              ? Container(
                height: 4,
                width: 4,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red,
                ),
              )
              : Container()
        ],
      ),
    );
}
}

