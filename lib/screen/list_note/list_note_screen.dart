// import 'dart:math';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/enum/note_priority_enum.dart';
import 'package:todo_app/screen/list_note/cubit/list_note_cubit.dart';
import 'package:todo_app/utils/color_utils.dart';
import '../../model/note.dart';
import '../../utils/custom_text.dart';
import '../../utils/string_utils.dart';

class ListNoteScreen extends StatefulWidget {
  const ListNoteScreen({super.key});

  @override
  State<ListNoteScreen> createState() => ListNoteScreenState();
}

class ListNoteScreenState extends State<ListNoteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFF6F5F0),
        appBar: AppBar(
            toolbarHeight: 80,
            centerTitle: false,
            backgroundColor: Color(0xFFF6F5F0),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(StringUtils.note, style: AppTextStyles.heading1,),
                Text(StringUtils.completed,
                  style: AppTextStyles.bodyMedium(color: Colors.black54),),
              ],
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(50),
              child: BlocBuilder<ListNoteCubit, ListNoteState>(
                  builder: (context, state) {
                    return SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: state.categories.length + 1,
                        itemBuilder: (context, index){
                          if(index == 0){
                            return Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: _categoryChip(
                                  text: StringUtils.all,
                                  isSelected: state.selectedCategory == null,
                                  onTap: () {
                                    context.read<ListNoteCubit>().changeCategory(null);
                                  },
                                  colorText: Colors.white,
                                  backgroundColor: Colors.black,
                              ),
                            );
                          }

                          final category = state.categories[index - 1];

                          return _categoryChip(
                              text: category.name,
                              isSelected: state.selectedCategory?.id == category.id,
                              onTap: () {
                                context.read<ListNoteCubit>().changeCategory(category);
                              },
                              colorText: parseColor(category.color),
                              backgroundColor: Colors.white
                          );
                        },
                      ),
                    );
                  },
                ),
            ),
        ),
        body: BlocBuilder<ListNoteCubit, ListNoteState>(
          builder: (context, state) {
            if (state.isLoading) {
              return Center(child: CircularProgressIndicator(),);
            }

            if (state.notes.isEmpty) {
              return Center(
                child: Text(StringUtils.noNote),
              );
            }

            return ListView.builder(
              itemCount: state.notes.length,
              itemBuilder: (context, index){
                final note = state.notes[index];

                return _noteCard(note: note);
              }
            );
          }
        ),
    );
  }
  
  Widget _categoryChip({
    required String text,
    required bool isSelected,
    required VoidCallback onTap,
    required Color colorText,
    required Color backgroundColor,
  }){
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(30),
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            child: Text(
              text,
              style: AppTextStyles.buttonText(color: colorText),
            ),
          ),
        ),
      ),
    );
  }

  Widget _noteCard({required Note note}){
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),

      child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(note.title, style: AppTextStyles.bodyLarge(),),
              SizedBox(height: 6),
              Text(note.content, style: AppTextStyles.bodyMedium(),),
              SizedBox(height: 12),
              Row(
                children: [
                  Text(note.priority.label),
                  SizedBox(width: 8,),
                  Text(note.c)
                ],
              )
            ],
          ),
      ),
    );
  }
}
