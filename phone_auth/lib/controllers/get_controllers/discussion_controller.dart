import 'package:get/get.dart';
//import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:phone_auth/controllers/hive_controller/hive_helper.dart';
//import 'package:phone_auth/encryption/encryption.dart';
import 'package:phone_auth/models/discussions_model.dart';

class DiscussionController extends GetxController {
  var allDiscussions = <Discussion>[].obs;

  void initDiscussion() async {
    /* final constantsService = ConstantsService();
    await constantsService.initConstants();
    final privateKey = constantsService.privateKey;*/
    final allOldDiscussions = await DiscussionHelper.getAllDiscussion();
    // print(allOldDiscussions);
    /*for (var discussion in allOldDiscussions) {
      String contentt = discussion.lastMessage.content!;
      String decryptedContent = Encryption.decryptMessage(
          encodedMessage: contentt, privateKey: privateKey);
      // print("========================$contentt===========================");
      // print("TESTING*************$decryptedContent*****************TESTING\n");

      discussion.lastMessage.content = decryptedContent;
    }*/
    allDiscussions.addAll(allOldDiscussions);
  }

  DiscussionController() {
    //print(allDiscussions);
    //print("+++++++++++CALLED+++++++++");

    initDiscussion();
  }

  void addDiscussion(Discussion discussion) async {
    /*final constantsService = ConstantsService();
    await constantsService.initConstants();
    final privateKey = constantsService.privateKey;
    String? decrypt = Encryption.decryptMessage(
        encodedMessage: discussion.lastMessage.content!,
        privateKey: privateKey);

    discussion.lastMessage.content = decrypt;*/

    bool found = false;
    for (var discus in allDiscussions) {
      if (discus.senderId == discussion.senderId) {
        allDiscussions.remove(discus);
        allDiscussions.add(discussion);
        found = true;
        break;
      }
    }
    if (!found) {
      allDiscussions.add(discussion);
    }
    //allDiscussions.add(discussion);
    //allDiscussions = allDiscussions;

    // await DiscussionHelper.addDiscussion(discussion);
    /*if (allDiscussions.isNotEmpty) {
      allDiscussions.removeRange(0, allDiscussions.length);
    }*/
    // allDiscussions.clear();
    //initDiscussion();
  }
}
