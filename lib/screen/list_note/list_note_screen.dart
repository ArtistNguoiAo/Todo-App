// import 'dart:math';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/enum/note_priority_enum.dart';
import 'package:todo_app/screen/list_category/cubit/list_category_cubit.dart';
import 'package:todo_app/screen/list_note/cubit/list_note_cubit.dart';
import 'package:todo_app/utils/color_utils.dart';
import 'package:todo_app/widget/dialog.dart';
import '../../model/note.dart';
import '../../utils/date_utils.dart';
import '../../widget/custom_text.dart';
import '../../utils/string_utils.dart';

class ListNoteScreen extends StatefulWidget {
  const ListNoteScreen({super.key});

  @override
  State<ListNoteScreen> createState() => ListNoteScreenState();
}

class ListNoteScreenState extends State<ListNoteScreen> {
  @override
  Widget build(BuildContext context) {
    final categories = context.watch<ListCategoryCubit>().state.categories;
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
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: SizedBox(
                        width: double.infinity,
                        height: 40,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: categories.length + 1,
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
                            final categories = context.watch<ListCategoryCubit>().state.categories;
                            final category = categories[index - 1];

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
            final dates = state.groupedNotes.keys.toList();
            return ListView.builder(
              itemCount: dates.length,
              itemBuilder: (context, index){
                final date = dates[index];
                final notes = state.groupedNotes[date]!;
                final header = getDateTitle(date);

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(header.title, style: AppTextStyles.bodyLarge(color: Colors.black),),
                          SizedBox(width: 8),
                          Text(header.date, style: AppTextStyles.bodyMedium(color: Colors.grey),),
                        ],
                      ),
                      ...notes.map((note) => _noteCard(note: note)),
                    ],
                  ),
                );
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
    final categories = context.watch<ListCategoryCubit>().state.categories;
    final category = categories.firstWhereOrNull((e) => e.id == note.categoryId);

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      color: note.isDone ? Colors.grey[200] : Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () {},
        child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Transform.scale(
                  scale: 1.3,
                  child: Checkbox(
                    fillColor: WidgetStateProperty.resolveWith((states) {
                        if (states.contains(WidgetState.selected)) {
                          return Colors.green;
                        }
                        return Colors.white;
                    }),
                    shape: CircleBorder(),
                      side: BorderSide(
                        color: Colors.grey,
                        width: 2,
                      ),
                    value: note.isDone,
                    onChanged: (value){
                      context.read<ListNoteCubit>().toggleDone(note.id, value ?? false);
                      }
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(note.title, style: AppTextStyles.bodyLarge().copyWith(
                        decoration: note.isDone ? TextDecoration.lineThrough : null,
                        color: note.isDone ? Colors.black54 : Colors.black,
                      ),),
                      if (note.content.isNotEmpty) ...[
                        SizedBox(height: 6),
                        Text(note.content, style: AppTextStyles.bodyMedium(color: Colors.black54),),
                      ],
                      SizedBox(height: 12),
                      SizedBox(
                        height: 30,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _customContainer(
                                color: note.priority.color,
                                icon: note.priority.icon,
                                text: note.priority.label,
                                size: 16
                            ),
                            if (category != null) ...[
                              const SizedBox(width: 12),
                              _customContainer(
                                color: parseColor(category.color),
                                icon: Icons.circle,
                                text: category.name,
                                size: 12,
                              ),
                            ],
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Icon(Icons.delete_outline, color: Colors.grey[700]),
                  ),
                  onTap: () {
                    AppDialog.showDeleteDialog(
                        context: context,
                        onDelete: () async{
                          context.read<ListNoteCubit>().deleteNote(note.id);
                        }
                    );
                  },
                ),
              ],
            ),
        ),
      ),
    );
  }
  Widget _customContainer({
    required Color color,
    required IconData icon,
    required String text,
    required double size,
  }){
    return Container(
      padding: EdgeInsets.only(top: 2, bottom: 2, right: 8, left: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(icon, color: color, size: size,),
          SizedBox(width: 4,),
          Text(text, style: AppTextStyles.bodyMedium(color: color),),
        ],
      ),
    );
  }
}
