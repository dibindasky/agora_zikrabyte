import 'package:agora_zikrabyte/pages/calls.dart';
import 'package:agora_zikrabyte/utils/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Agora',
          style: cabin(fontSize: 0.06, color: kWhite),
        ),
        backgroundColor: kBlue,
      ),
      body: Column(
        children: [
          StreamBuilder(
            stream: FirebaseFirestore.instance.collection('call').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData &&
                  snapshot.data!.docs.isNotEmpty &&
                  snapshot.data!.docs.last.data()['call'] != '') {
                return AlertDialog(
                    backgroundColor: kGreenDark.withOpacity(0.3),
                    title: Text(snapshot.data!.docs.last.data()['call']),
                    actions: [
                      ElevatedButton(
                          style:
                              ElevatedButton.styleFrom(backgroundColor: kRed),
                          onPressed: () async {
                            await endCall();
                          },
                          child: Text(
                            'End',
                            style: cabin(fontSize: 0.06, color: kWhite),
                          )),
                      ElevatedButton(
                          style:
                              ElevatedButton.styleFrom(backgroundColor: kGreen),
                          onPressed: () async {
                            final String channel =
                                snapshot.data!.docs.last.data()['call'];
                            await endCall().then((value) => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        CallsPage(channelName: channel))));
                          },
                          child: Text(
                            'Accept',
                            style: cabin(fontSize: 0.06, color: kWhite),
                          ))
                    ]);
              }
              return const SizedBox();
            },
          ),
          Expanded(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('chat')
                    .doc('at8vMVfhAoBno4WcdkDj')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasData) {
                    final doc = snapshot.data!.data();
                    return ListView.builder(
                        itemCount: doc!['image'].length,
                        itemBuilder: (context, index) {
                          final String image = doc['image'][index] ??
                              'https://firebasestorage.googleapis.com/v0/b/assignmentwandoor.appspot.com/o/N5EgMMxD5bbVyyHKnvPkVgNfdeY2%2FIMG-20231211-WA0012.jpg?alt=media&token=97487b3f-079b-4587-b8ae-f839cd64970b';
                          final String name = doc['name'][index] ?? 'name';
                          return Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            decoration: const BoxDecoration(
                                color: kGrey,
                                borderRadius: BorderRadius.all(kRadius20)),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(image),
                              ),
                              subtitle: Text(
                                'message',
                                style: montserrat(fontSize: 0.04),
                              ),
                              title: Text(
                                name,
                                style: cabin(fontSize: 0.05),
                              ),
                              trailing: IconButton(
                                  onPressed: () async {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CallsPage(channelName: name)));
                                  },
                                  icon: const Icon(
                                    Icons.video_call_rounded,
                                    color: kGreen,
                                  )),
                            ),
                          );
                        });
                  }
                  return const Center(
                    child: Text('No Chats'),
                  );
                }),
          ),
        ],
      ),
    );
  }
}

Future<void> endCall() async {
  await FirebaseFirestore.instance
      .collection('call')
      .doc('O8siRs59WiWAVAYL1KxL')
      .set({'call': ''});
}
