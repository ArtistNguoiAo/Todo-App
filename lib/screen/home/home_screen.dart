import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/screen/list_category/cubit/list_category_cubit.dart';
import 'package:todo_app/utils/string_utils.dart';
import 'package:todo_app/screen/list_category/list_category_screen.dart';
import 'package:todo_app/screen/list_note/list_note_screen.dart';


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
              BlocProvider(
                  create: (_) => ListCategoryCubit()..loadCategories(),
                  child: ListCategoryScreen(),
              )
            ],
          ),
          Positioned(
            bottom: 32,
            left: screenWidth * 0.4 /2,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
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
                    label: StringUtils.catalog,
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

