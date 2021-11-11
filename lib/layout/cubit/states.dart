
abstract class HomeStates {}

class HomeInitState extends HomeStates{}

class HomeLoadingState extends HomeStates{}

class HomeSuccessState extends HomeStates{}

class HomeErrorState extends HomeStates{}

class HomeChangeBotNavBar extends HomeStates{}

class HomeGetUserLoadingState extends HomeStates{}

class HomeGetUserSuccessState extends HomeStates{}

class HomeGetUserErrorState extends HomeStates{}

class HomeGetCoverImageSuccessState extends HomeStates{}

class HomeGetCoverImageErrorState extends HomeStates{}

class HomeGetProfileImageSuccessState extends HomeStates{}

class HomeGetProfileImageErrorState extends HomeStates{}

class HomeUpdateUserDataLoadingState extends HomeStates{}

class HomeUpdateUserDataSuccessState extends HomeStates{}

class HomeUpdateUserDataErrorState extends HomeStates{}

class HomeUploadImageSuccessState extends HomeStates{}

class HomeUploadImageErrorState extends HomeStates{}

class HomeUploadThenGetURLImageErrorState extends HomeStates{}

class HomePostsScreenState extends HomeStates{}

//Create post
class PostGetImageSuccessState extends HomeStates{}

class PostGetImageErrorState extends HomeStates{}

class PostRemoveImageState extends HomeStates{}

class PostUploadImageSuccessState extends HomeStates{}

class PostUploadImageErrorState extends HomeStates{}

class PostCreatePostSuccessState extends HomeStates{}

class PostCreatePostErrorState extends HomeStates{}

class PostCreatePostLoadingState extends HomeStates{}

//GetPosts

class HomeGetPostsSuccessState extends HomeStates{}

class HomeGetPostsErrorState extends HomeStates{}

class HomeGetPostsLoadingState extends HomeStates{}

//setPostLikes
class PostSetLikeSuccessState extends HomeStates{}

class PostSetLikeErrorState extends HomeStates{}

//CommentsShown
class ChangeCommentsView extends HomeStates{}

//comments get
class GetCommentsLoadingState extends HomeStates{}

class GetCommentsSuccessState extends HomeStates{}

class GetCommentsErrorState extends HomeStates{}

//Update userModel in posts
class UpdateUserModelInPostsSuccessState extends HomeStates{}

//Like pressed
class ChangeLikeState extends HomeStates{}




