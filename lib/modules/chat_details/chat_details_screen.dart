import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/models/message_model.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/shared/styles/colors.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class ChatDetailsScreen extends StatelessWidget {
  final UserModel model;
  final ScrollController _scrollController = ScrollController();
    ChatDetailsScreen({Key key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var messageController = TextEditingController();
    var cubit = HomeCubit.get(context);


    return Builder(
      builder: (context) {

        cubit.getMessages(receiverUid: model.uid);
        return BlocConsumer<HomeCubit, HomeStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return Scaffold(
                appBar: AppBar(
                  titleSpacing: 0,
                  toolbarHeight: 80,
                  title: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(model.profileImage),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        model.name,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ],
                  ),
                ),
                body: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            Expanded(
                              child: ListView.separated(
                                reverse: true,
                                controller: _scrollController,
                                shrinkWrap: true,
                                itemBuilder: (context, index){
                                  var message = cubit.messages[index];

                                  if(cubit.userModel.uid == message.senderUid)
                                    return senderMessage(context,message);

                                  return receiverMessage(context,message);
                                },
                                separatorBuilder: (context, index) => SizedBox(
                                  height: 10,
                                ),
                                itemCount: cubit.messages.length,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: EdgeInsets.all(0),
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(20)),
                                border: Border.all(color: Colors.grey[300]),
                              ),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      controller: messageController,
                                      maxLines: 2,
                                      minLines: 1,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Write a message ...",
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      _scrollController.animateTo(
                                          _scrollController.position.minScrollExtent,
                                          duration: Duration(milliseconds: 200),
                                          curve: Curves.easeInOut
                                      );
                                           cubit.createMessage(
                                              senderUid: cubit.userModel.uid,
                                              receiverUid: model.uid,
                                              date: DateTime.now().toString(),
                                              messageText: messageController.text);
                                      messageController.text = '';
                                    },
                                    child: Container(
                                      height: 60,
                                      width: 60,
                                      color: primaryColor.shade500,
                                      child: Icon(
                                        IconBroken.Send,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      )

            );
          },
        );
      },
    );
  }

  Widget receiverMessage(context, MessageModel message) => Row(
        children: [
          Flexible(
            flex: 3,
            child: Align(
              alignment: AlignmentDirectional.topStart,
              child: Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      topLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                    color: Colors.grey[300]),
                child: Text(
                  message.messageText,
                  style: Theme.of(context).textTheme.bodyText2.copyWith(fontSize: 16),
                ),
              ),
            ),
          ),
          Spacer(
            flex: 1,
          )
        ],
      );

  Widget senderMessage(context, MessageModel message) => Row(
        children: [
          Spacer(
            flex: 1,
          ),
          Flexible(
            flex: 3,
            child: Align(
              alignment: AlignmentDirectional.centerEnd,
              child: Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                    color: primaryColor.shade200),
                child: Text(
                  message.messageText,
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  style: Theme.of(context).textTheme.bodyText2.copyWith(fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      );

  void scrollToBottom() {

  }

}
