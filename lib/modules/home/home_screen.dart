import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/models/comment_model.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = HomeCubit.get(context);
        return cubit.posts.length > 0
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      Card(
                        elevation: 10,
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Image(
                              image: NetworkImage(
                                  'https://image.freepik.com/free-photo/cheerful-young-woman-poses-torn-yellow-paper-hole-background-emotional-expressive_155003-7248.jpg'),
                              height: 220,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Communicate with friends',
                                style: Theme.of(context).textTheme.bodyText1.copyWith(
                                      fontSize: 17,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: cubit.posts.length,
                          itemBuilder: (context, index) => postItem(context, cubit.posts[index], cubit, index)),
                      SizedBox(
                        height: 120,
                      )
                    ],
                  ),
                ),
              )
            : Center(child: CircularProgressIndicator());
      },
    );
  }

  final hasTages = List<Widget>.generate(
      8,
      (index) => InkWell(
            child: Padding(
              padding: EdgeInsetsDirectional.only(end: 5, bottom: 5),
              child: Text(
                '#WatchMe',
                style: TextStyle(color: Colors.blueAccent),
              ),
            ),
            onTap: () {},
          ));

  Widget postItem(BuildContext context, PostModel postModel, HomeCubit cubit, int index) {
    var commentController = TextEditingController();

    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(postModel.userModel.profileImage),
                ),
                SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          postModel.userModel.name,
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(
                          Icons.verified,
                          color: Colors.blue,
                          size: 18,
                        )
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      postModel.date,
                      style: Theme.of(context).textTheme.subtitle2.copyWith(color: Colors.grey),
                    ),
                  ],
                ),
                Spacer(),
                IconButton(onPressed: () {}, icon: Icon(Icons.more_horiz))
              ],
            ),
            Container(
              margin: EdgeInsets.all(12),
              height: 1,
              color: Colors.grey[200],
            ),
            Text(
              postModel.postText,
              style: Theme.of(context).textTheme.bodyText2.copyWith(fontSize: 15, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 10,
            ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(vertical:8.0),
            //   child: Wrap(
            //       children: hasTages
            //
            //   ),
            // ),
            postModel.postImage != ''
                ? Card(
                    margin: EdgeInsets.all(0),
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                    child: Image(
                      image: NetworkImage(postModel.postImage),
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  )
                : SizedBox(height: 10),
            Row(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        IconBroken.Heart,
                        color: Colors.red,
                      ),
                      iconSize: 18,
                      constraints: BoxConstraints(
                          // maxWidth: 30
                          ),
                    ),
                    Text("${cubit.likes[index]}"),
                  ],
                ),
                Spacer(),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        cubit.getComments(cubit.postId[index],index);
                        cubit.changeCommentsView(cubit.isCommentsShown[index],index);
                      },
                      icon: Icon(
                        IconBroken.Chat,
                        color: Colors.amber,
                      ),
                      iconSize: 18,
                      constraints: BoxConstraints(
                          // maxWidth: 30
                          ),
                    ),
                    Text("${cubit.comments[index] ?? 0}"),
                  ],
                ),
              ],
            ),
            cubit.isCommentsShown[index]? Container(
              margin: EdgeInsets.all(12),
              height: 1,
              color: Colors.grey[200],
            ):SizedBox(height: 0,),
            cubit.isCommentsShown[index]
                    ?cubit.commentsModel[index].length > 0 ?
            ListView.separated(
                        shrinkWrap: true,
                        itemBuilder: (context, item) => commentItem(cubit, context, cubit.commentsModel[index].elementAt(item)),
                        separatorBuilder: (context, index) => Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                        itemCount:  cubit.commentsModel[index].length)
                :Center(child: CircularProgressIndicator(strokeWidth: 2,),)
                : SizedBox(
                    height: 0,
                  ),
            Container(
              margin: EdgeInsets.all(12),
              height: 1,
              color: Colors.grey[200],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(cubit.userModel.profileImage),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: TextFormField(
                    controller: commentController,
                    onFieldSubmitted: (value) {
                      cubit.addComment(cubit.postId[index], value,DateTime.now().toString(),index).then((value) {
                        commentController.text = '';
                      });
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Write a comment ...",
                      hintMaxLines: 2,
                    ),
                  ),
                ),

                InkWell(
                  onTap: () {
                    //cubit.changeLikeState(index);
                    cubit.addLike(cubit.postId[index]);

                  },
                  child: Row(
                    children: [
                      Icon(
                       Icons.favorite_border,
                        color: Colors.red,
                      ),
                      Text('Like'),
                    ],
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                // //Share
                // InkWell(
                //   onTap: (){},
                //   child: Row(
                //     children: [
                //       Icon(IconBroken.Arrow___Up_Square,
                //         color: Colors.blueAccent,
                //       ),
                //       Text('Share'),
                //     ],
                //   ),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget commentItem(HomeCubit cubit, BuildContext context, CommentModel model) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(model.userModel.profileImage),
          ),
          SizedBox(
            width: 20,
          ),
          Flexible(
            flex: 1,
            child: Container(
             // width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      //topLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10))),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.userModel.name,
                      style: Theme.of(context).textTheme.bodyText2.copyWith(fontWeight: FontWeight.w500, fontSize: 17),
                    ),
                    Text(
                      model.commentText,
                      style: Theme.of(context).textTheme.bodyText2.copyWith(fontWeight: FontWeight.w500, fontSize: 15),
                    ),
                  ],

                ),
              ),
            ),
          )
        ],
      );
}
