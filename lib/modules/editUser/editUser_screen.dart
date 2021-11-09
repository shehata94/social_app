import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class EditUserScreen extends StatelessWidget {

  var nameController  = TextEditingController();
  var bioController   = TextEditingController();
  var phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state){},
      builder: (context, state){
        var cubit = HomeCubit.get(context);

        nameController.text = cubit.userModel.name;
        phoneController.text = cubit.userModel.phone;
        bioController.text = cubit.userModel.bio;

        return  Scaffold(
            appBar: appBar(
              context: context,
              title: "Edit Profile",
              actionText: "UPDATE",
              onPressed: (){
                cubit.uploadImagesAndData(
                    name: nameController.text,
                    phone: phoneController.text,
                    bio: bioController.text
                );
              }
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    state is HomeUpdateUserDataLoadingState
                    ? LinearProgressIndicator()
                        :SizedBox(height: 4,),
                    SizedBox(height: 20,),
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
                                  image: cubit.coverImage != null ? FileImage(cubit.coverImage):NetworkImage(cubit.userModel.coverImage),
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
                                      cubit.getCoverImage();
                                    },
                                    icon: Icon(IconBroken.Camera)
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Stack(
                              alignment: Alignment.topRight,
                              children: [
                                CircleAvatar(
                                  radius: 55,
                                  backgroundColor: Colors.white,
                                  child: CircleAvatar(
                                    radius: 50,
                                    backgroundImage: cubit.profileImage != null? FileImage(cubit.profileImage):NetworkImage(cubit.userModel.profileImage)
                                  ),
                                ),
                                CircleAvatar(
                                  radius: 18,
                                  child: IconButton(
                                      onPressed: (){
                                        cubit.getProfileImage();
                                      },
                                      icon: Icon(IconBroken.Camera,
                                      size: 18,)
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 30,),
                    defaultTextForm(
                        controller: nameController,
                        inputType: TextInputType.text,
                        prefix: IconBroken.User1 ,
                        label: 'Name',
                        validate: (String value){
                          if(value.isEmpty)
                            {
                              return 'Name must not be empty';
                            }
                        },
                    ),
                    SizedBox(height: 10,),
                    defaultTextForm(
                      controller: phoneController,
                      inputType: TextInputType.phone,
                      prefix: IconBroken.Call ,
                      label: 'Phone',
                      validate: (String value){
                        if(value.isEmpty)
                        {
                          return 'Phone must not be empty';
                        }
                      },
                    ),
                    SizedBox(height: 10,),
                    defaultTextForm(
                      controller: bioController,
                      inputType: TextInputType.text,
                      prefix: IconBroken.Info_Circle,
                      label: 'Bio',
                      validate: (String value){
                        if(value.isEmpty)
                        {
                          return 'Name must not be empty';
                        }
                      },
                    ),
                    SizedBox(height: 10,)

                  ],

                ),
              ),
            )
        );
      },
    );
  }
}
