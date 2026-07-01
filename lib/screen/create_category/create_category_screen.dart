import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/screen/create_category/cubit/create_category_cubit.dart';
import 'package:todo_app/utils/color_utils.dart';
import 'package:todo_app/utils/custom_text.dart';
import 'package:todo_app/utils/custom_widgets.dart';
import 'package:todo_app/utils/string_utils.dart';

class CreateCategoryScreen extends StatefulWidget {
  const CreateCategoryScreen({super.key});

  @override
  State<CreateCategoryScreen> createState() => _CreateCategoryScreenState();
}

class _CreateCategoryScreenState extends State<CreateCategoryScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6F5F0),
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Color(0xFFF6F5F0),
        automaticallyImplyLeading: false,
        leading: _backButton(),
        title: Text(StringUtils.newCatalog, style: AppTextStyles.heading2(),),
        actions: [
          BlocBuilder<CreateCategoryCubit, CreateCategoryState>(
              builder: (context, state){
                return SaveButton(
                  text: StringUtils.create,
                  onTap: state.name.trim().isEmpty ? null : ()async {
                    await context.read<CreateCategoryCubit>().saveCategory();

                    Navigator.pop(context, true);
                  },
                  color: state.name.trim().isEmpty ? Colors.red.withOpacity(0.4) : Colors.red,
                );
              }
          )
        ],
      ),
      body:Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _boxPreview(),
            SizedBox(height: 16,),
            Text(StringUtils.catalogName, style: AppTextStyles.bodyLarge(color: Color(0xFF858076)),),
            SizedBox(height: 8,),
            CustomTextField(
                hintText: StringUtils.egCatalog,
                onChanged: (text) {
                  context.read<CreateCategoryCubit>().changeName(text);
                },
            ),
            SizedBox(height: 16,),
            Text(StringUtils.color, style: AppTextStyles.bodyLarge(color: Color(0xFF858076)),),
            SizedBox(height: 8,),
            _boxColors(),
          ],
        ),
      )
    );
  }
  
  Widget _backButton(){
    return Padding(
      padding: EdgeInsets.only(left: 10.0, top: 6.0, bottom: 6.0),
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey, width: 1),
        ),
        child: InkWell(
          child: Icon(Icons.arrow_back_rounded, color: Colors.black,),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
  
  Widget _boxPreview(){
    return BlocBuilder<CreateCategoryCubit, CreateCategoryState>(
      builder: (context, state) {
        return AnimatedContainer(
          duration: Duration(milliseconds: 250),
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: state.selectedColor.withOpacity(0.12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: state.selectedColor.withOpacity(0.2)
                ),
                child: Icon(Icons.local_offer_outlined, color: state.selectedColor, size: 40,),
              ),
              SizedBox(height: 8,),
              Text(
                  state.name.isEmpty ? StringUtils.catalogNameLc : state.name,
                  style: AppTextStyles.heading2(color: state.selectedColor)
              ),
            ],
          ),
        );
  },
);
  }

  Widget _boxColors(){
    return BlocBuilder<CreateCategoryCubit, CreateCategoryState>(
  builder: (context, state) {
    return Container(
      width: double.infinity,
      height: 180,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          border: Border()
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: ColorUtils.colors.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemBuilder: (context, index){
          final Color colorItem = ColorUtils.colors[index];
          final bool isSelected = colorItem == state.selectedColor;

          return Material(
            color: Colors.transparent,
            child: Ink(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: ColorUtils.colors[index],
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  context.read<CreateCategoryCubit>().selectColor(colorItem);
                },
                child: Center(
                  child: isSelected ? Icon(Icons.check, color: Colors.white,) : SizedBox.shrink(),
                ),
              ),
            ),
          );
        }
      ),
    );
  },
);
  }

}


