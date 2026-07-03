import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/screen/list_category/cubit/list_category_cubit.dart';
import 'package:todo_app/utils/custom_widgets.dart';
import 'package:todo_app/screen/create_note/cubit/create_note_cubit.dart';
import '../../utils/custom_text.dart';
import '../../utils/string_utils.dart';

class CreateNoteScreen extends StatefulWidget {
  const CreateNoteScreen({super.key});

  @override
  State<CreateNoteScreen> createState() => _CreateNoteScreenState();
}

class _CreateNoteScreenState extends State<CreateNoteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6F5F0),
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Color(0xFFF6F5F0),
        automaticallyImplyLeading: false,
        leading: backButton(),
        title: Text(StringUtils.newNote, style: AppTextStyles.heading2(),),
        actions: [
          SaveButton(
              text: StringUtils.save,
              onTap: () {},
              color: Colors.red,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16,),
              Text(StringUtils.title, style: AppTextStyles.bodyLarge(color: Color(0xFF858076)),),
              SizedBox(height: 8,),
              CustomTextField(
                hintText: StringUtils.hintTitle,
                // controller: _nameController,
              ),
              SizedBox(height: 16,),
              Text(StringUtils.description, style: AppTextStyles.bodyLarge(color: Color(0xFF858076)),),
              SizedBox(height: 8,),
              CustomTextField(
                hintText: StringUtils.addDescription,
                // controller: _nameController,
                ),
              SizedBox(height: 16,),
              Text(StringUtils.day, style: AppTextStyles.bodyLarge(color: Color(0xFF858076)),),
              SizedBox(height: 8,),
              CustomTextField(
              hintText: StringUtils.hintTitle,
              // controller: _nameController,
              ),
              SizedBox(height: 16,),
              Text(StringUtils.priority, style: AppTextStyles.bodyLarge(color: Color(0xFF858076)),),
              SizedBox(height: 8,),
              BlocBuilder<CreateNoteCubit, CreateNoteState>(
              builder: (context, state) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(child: _priorityCard(context: context ,priority: 1, state: state)),
                    SizedBox(width: 12,),
                    Expanded(child: _priorityCard(context: context ,priority: 2,state: state)),
                    SizedBox(width: 12,),
                    Expanded(child: _priorityCard(context: context ,priority: 3,state: state)),
                  ],
                );
              },
              ),
              SizedBox(height: 16,),
              Text(StringUtils.catalog2, style: AppTextStyles.bodyLarge(color: Color(0xFF858076)),),
              SizedBox(height: 8,),
              _menuCategories(),
            ],
          ),
        ),
      )
    );
  }

  Widget _priorityCard({
    required BuildContext context,
    required int priority,
    required CreateNoteState state,
}){
    final Color color = switch(priority){
      1 => Colors.red,
      2 => Colors.blueAccent,
      _ =>  Colors.grey,
    };
    final IconData icon = switch(priority){
      1 => Icons.local_fire_department_outlined,
      2 => Icons.circle_outlined,
      _ => Icons.remove,
    };
    final String label = switch(priority){
      1 => StringUtils.urgent,
      2 => StringUtils.important,
      _ => StringUtils.normal,
    };
    final bool isSelected = state.selectedPriority == priority;

    return InkWell(
        onTap: () { context.read<CreateNoteCubit>().selectPriority(priority); },
        child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: isSelected ? color.withOpacity(0.08) : Colors.white,
                border: Border.all(
                    color: isSelected ? color : Colors.white,
                    width: 2
                )
            ),
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: color,),
            ),
            SizedBox(height: 8,),
            Text('P$priority', style: AppTextStyles.bodyLarge(color: Color(0xFF858076))),
            SizedBox(height: 8,),
            Text(
              label,
              style: AppTextStyles.bodyMedium(color: Colors.grey),)
          ],
        ),
      ),
    );
  }

  Widget _menuCategories(){
    return BlocBuilder<ListCategoryCubit, ListCategoryState>(
        builder: (context, catgogyState){
          return BlocBuilder<CreateNoteCubit, CreateNoteState>(
              builder: (context, noteState){
                // return DropdownButtonFormField<Category>(
                //     value: noteState.selectedCategory,
                //
                //     decoration: InputDecoration(
                //       border: OutlineInputBorder()
                //     ),
                //
                //     items: [
                //       DropdownMenuItem<Category>(
                //           child: Text(StringUtils.noCategory, style: AppTextStyles.bodyMedium(color: Colors.grey),),
                //           value: null,
                //       ),
                //       ...
                //     ],
                //     onChanged: (category)
                // );
              }
          );
        }
    );
}
}
