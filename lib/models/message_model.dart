class MessageModel{
   String senderUid;
   String receiverUid;
   String date;
   String messageText;


  MessageModel({
    this.senderUid,
    this.receiverUid,
    this.date,
    this.messageText,
  });

  MessageModel.fromJson(Map<String, dynamic> json){
    senderUid = json['senderUid'];
    receiverUid = json['receiverUid'];
    date = json['date'];
    messageText = json['messageText'];

  }

  Map<String, dynamic> toMap(){
    return
        {
          'senderUid': senderUid,
          'receiverUid': receiverUid,
          'date': date,
          'messageText': messageText,
        };
  }



}