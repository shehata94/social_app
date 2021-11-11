import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/styles/colors.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class PostsScreen extends StatelessWidget {
  var postController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit,HomeStates>(
      listener: (context, state){},
      builder: (context, state){
        var cubit = HomeCubit.get(context);
        return Scaffold(
          appBar: appBar(
            context: context,
            title: "Add Post",
            actionText: "Post",
            onPressed: (){
              cubit.createPost(
                postText: postController.text,
                userModel: cubit.userModel,
                date: DateTime.now().toString()
              ).then((value) => Navigator.pop(context));
            },
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                state is PostCreatePostLoadingState
                ? LinearProgressIndicator()
                :SizedBox(height: 4,),
                SizedBox(height: 10,),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(
                         cubit.userModel.profileImage
                      ),
                    ),
                    SizedBox(width: 20,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(cubit.userModel.name,
                          style: Theme.of(context).textTheme.bodyText1,),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20,),
                Expanded(
                  child: TextFormField(
                    controller: postController,
                    maxLines: 10,
                    decoration: InputDecoration(
                      hintText: 'What is in your mind ...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                cubit.postImage != null
                    ? Stack(
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
                            image: FileImage(cubit.postImage),
                            fit: BoxFit.cover
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: CircleAvatar(
                          radius: 20,
                          child: IconButton(
                              onPressed: (){
                                cubit.removePostImage();
                              },
                              icon: Icon(IconBroken.Close_Square)
                          ),
                        ),
                      ),
                    ),

                  ],
                )
                    : SizedBox(height: 20,),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: (){
                          cubit.getPostImage();
                        },
                        child: Row(
                          children: [
                            Icon(IconBroken.Camera,
                              color: primaryColor,),
                            SizedBox(width: 10,),
                            Text('Add Photo',
                              style: TextStyle(
                                  color: primaryColor
                              ),)
                          ],
                          mainAxisAlignment: MainAxisAlignment.center,
                        ),

                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: (){},
                        child: Text('#Tags',
                          style: TextStyle(
                              color: primaryColor
                          ),),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),

        );
      },
    );
  }
}
