import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/shared/styles/colors.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state){},
      builder: (context, state){
        var cubit = HomeCubit.get(context);
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Container(
                height: 240,
                child: Stack(
                  children: [
                    Container(
                      height: 200,
                      width: double.infinity,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft:Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                        image: DecorationImage(
                            image: NetworkImage(cubit.userModel.coverImage,
                            ),
                            fit: BoxFit.cover
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: CircleAvatar(
                        radius: 55,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage:NetworkImage(cubit.userModel.profileImage
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 20,),
              Text(cubit.userModel.name,
                style: Theme.of(context).textTheme.headline6,),
              SizedBox(height: 10,),
              Text(cubit.userModel.bio,
                style: Theme.of(context).textTheme.caption.copyWith(
                    fontSize: 15
                ),),
              SizedBox(height: 30,),
              Row(
                  children: List<Widget>.generate(4,(index)=>publicInfoItem(context,index))
              ),
              SizedBox(height: 30,),
              Row(
                children: [
                  Expanded(
                      flex: 3,
                      child: OutlinedButton(
                        onPressed: (){},
                        child: Text('Add Photos',
                          style: TextStyle(
                              color: primaryColor
                          ),),
                      )
                  ),
                  SizedBox(width: 10,),
                  Expanded(
                      flex: 1,
                      child: OutlinedButton(
                          onPressed: (){},
                          child: Icon(IconBroken.Edit_Square,
                            size: 20,)
                      )
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  List<String> nums = ['100','1k','200k','580'];
  List<String> items = ['Posts','Photos','Followers','Following'];

  Widget publicInfoItem(BuildContext context,int index) => Expanded(
    child: Column(
      children: [
        Text(nums[index],
          style: Theme.of(context).textTheme.bodyText1,),
        SizedBox(height: 5,),
        Text(items[index],
          style: Theme.of(context).textTheme.bodyText2,
        ),
      ],
    ),
  );
}
