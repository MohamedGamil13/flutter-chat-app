class Message {
  final String messagecore;
  final String id;
  final DateTime createdAt;

  Message({
    required this.id,
    required this.messagecore,
    required this.createdAt,
  });

  factory Message.formjson(jsondata) {
    return Message(
      createdAt: (jsondata["CreatedAt"]).toDate(),
      id: jsondata["ID"],
      messagecore: jsondata['Message'],
    );
  }
}
