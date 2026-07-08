
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/enum/note_priority_enum.dart';
import 'package:todo_app/utils/color_utils.dart';
import 'package:todo_app/widget/custom_widgets.dart';
import 'package:todo_app/screen/create_note/cubit/create_note_cubit.dart';
import '../../model/category.dart';
import '../../widget/custom_text.dart';
import '../../utils/string_utils.dart';

class CreateNoteScreen extends StatefulWidget {
  const CreateNoteScreen({super.key});

  @override
  State<CreateNoteScreen> createState() => _CreateNoteScreenState();
}

class _CreateNoteScreenState extends State<CreateNoteScreen> {
  late final TextEditingController dateController;

  @override
  void initState(){
    super.initState();

    final now = DateTime.now();

    dateController = TextEditingController(
      text: DateFormat('dd/MM/yyyy').format(now),
    );

    context.read<CreateNoteCubit>().changeDate(now);
    context.read<CreateNoteCubit>().getListNoteCategory();
  }

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
        actions: [ BlocBuilder<CreateNoteCubit, CreateNoteState>(
          builder: (context, state){
            return SaveButton(
              text: StringUtils.save,
              onTap: state.title.trim().isEmpty ? null : ()async {

                await context.read<CreateNoteCubit>().saveNote();

                Navigator.pop(context, true);

              },
              color: state.title.trim().isEmpty ? Colors.red.withOpacity(0.4) : Colors.red,
            );
          }
        )
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
                onChanged: (value) {
                  context.read<CreateNoteCubit>().updateTitle(value);
                },
              ),
              SizedBox(height: 16,),
              Text(StringUtils.description, style: AppTextStyles.bodyLarge(color: Color(0xFF858076)),),
              SizedBox(height: 8,),
              CustomTextField(
                hintText: StringUtils.addDescription,
                onChanged: (value) {
                  context.read<CreateNoteCubit>().updateContent(value);
                },
                ),
              SizedBox(height: 16,),
              Text(StringUtils.day, style: AppTextStyles.bodyLarge(color: Color(0xFF858076)),),
              SizedBox(height: 8,),
              TextFormField(
                controller: dateController,
                keyboardType: TextInputType.datetime,
                decoration: InputDecoration(
                  hintText: 'dd/MM/yyyy',
                ),
                onChanged: (value){
                  try {
                    final date = DateFormat('dd/MM/yyyy').parseStrict(value);

                    context.read<CreateNoteCubit>().changeDate(date);
                  } catch (_) {
                    // Người dùng đang nhập dở, chưa phải ngày hợp lệ.
                  }
                },
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
                    Expanded(child: _priorityCard(context: context ,priority: NotePriorityEnum.high, state: state)),
                    SizedBox(width: 12,),
                    Expanded(child: _priorityCard(context: context ,priority: NotePriorityEnum.medium,state: state)),
                    SizedBox(width: 12,),
                    Expanded(child: _priorityCard(context: context ,priority: NotePriorityEnum.low,state: state)),
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
    required NotePriorityEnum priority,
    required CreateNoteState state,
}){
    final bool isSelected = state.selectedPriority == priority;

    return InkWell(
        onTap: () { context.read<CreateNoteCubit>().selectPriority(priority); },
        child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: isSelected ? priority.color.withOpacity(0.08) : Colors.white,
                border: Border.all(
                    color: isSelected ? priority.color : Colors.white,
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
                color: priority.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(priority.icon, color: priority.color,),
            ),
            SizedBox(height: 8,),
            Text(priority.label, style: AppTextStyles.bodyLarge(color: Color(0xFF858076))),
            SizedBox(height: 8,),
            Text(
              priority.description,
              style: AppTextStyles.bodyMedium(color: Colors.grey),)
          ],
        ),
      ),
    );
  }

  Widget _menuCategories(){
    return BlocBuilder<CreateNoteCubit, CreateNoteState>(
        builder: (context, state){
          return DropdownButtonFormField<NoteCategory?>(
              value: state.selectedCategory,
              isExpanded: true,
              itemHeight: null,
              isDense: false,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  )
              ),

              items: [
                DropdownMenuItem<NoteCategory?>(
                  value: null,
                  child: Row(
                    children: [
                      SizedBox(width: 10,),
                      CircleAvatar(
                        backgroundColor: Colors.grey,
                        radius: 6,
                      ),
                      SizedBox(width: 16,),
                      Text(StringUtils.noCategory, style: AppTextStyles.bodyMediumBold(color: Colors.grey),)
                    ],
                  ),
                ),
                ...state.listCategory.map<DropdownMenuItem<NoteCategory?>>((category){
                  final isSelected = state.selectedCategory?.id == category.id;

                  return DropdownMenuItem<NoteCategory?>(
                    value: category,
                    child: Row(
                      children: [
                        SizedBox(width: 10,),
                        CircleAvatar(
                          backgroundColor: parseColor(category.color),
                          radius: 6,
                        ),
                        SizedBox(width: 16,),
                        Expanded(
                          child: Text(
                            category.name,
                            style: AppTextStyles.bodyMediumBold(color: parseColor(category.color)),
                          ),
                        ),
                        if(isSelected) Icon(Icons.check, size: 18, color: parseColor(category.color)),
                      ],
                    ),
                  );
                })
              ],
              onChanged: (NoteCategory? category) {
                context.read<CreateNoteCubit>().changeCategory(category);
              }
          );
        }
    );
  }
}
