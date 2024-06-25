import 'package:get/get.dart';
import 'package:phone_auth/controllers/hive_controller/hive_helper.dart';
import 'package:phone_auth/models/chat_model.dart';
import 'package:phone_auth/models/discussions_model.dart';

class DiscussionController extends GetxController {
  RxMap<String, Discussion> allDiscussions = <String, Discussion>{}.obs;
  RxMap<String, Discussion> allDiscussionsUnread = <String, Discussion>{}.obs;

  @override
  void onInit() {
    super.onInit();
    initDiscussion();
    iniAllDiscussionUnread();
  }

  void initDiscussion() async {
    final allOldDiscussions = await DiscussionHelper.getAllDiscussion();
    allDiscussions.addAll(allOldDiscussions);
  }

  Future<void> addMessageToDiscussionController(
      ChatMessage message, String discussionId) async {
    // print("Adding To Controller CALLED\n");
//
    //String discussionId = DiscussionHelper.getDiscussionId(message);
    // if (allDiscussions.keys.contains(discussionId)) {
    //   Discussion newDis = allDiscussions[discussionId]!;
    //   newDis.messages.add(message);
    //   allDiscussions[discussionId] = newDis;
    // } else {
    //   KeyController keyController = Get.find<KeyController>();

    //   allDiscussions[discussionId] = (Discussion(
    //       discussionId: discussionId,
    //       messages: [message],
    //       unread: 1,
    //       displayName: keyController.getDisplayName(discussionId)));
    // }
    // await DiscussionHelper.addMessageToDiscussion(message, discussionId);
    // allDiscussions.refresh();
    // Discussion newDis;

    // if (allDiscussions.keys.contains(discussionId)) {
    //   print('modification');
    //   newDis = allDiscussions[discussionId]!;
    //   newDis.messages.add(message);
    // } else {
    //   print('creation');
    //   KeyController keyController = Get.find<KeyController>();

    //   newDis = Discussion(
    //       discussionId: discussionId,
    //       messages: [message],
    //       unread: 1,
    //       displayName: keyController.getDisplayName(discussionId));
    // }

    // allDiscussions[discussionId] = newDis;

    await DiscussionHelper.addMessageToDiscussion(message, discussionId);
    iniAllDiscussionUnread();
    allDiscussions.refresh();
    // if (allDiscussions[discussionId] == null) {
    //   // allDiscussions.firstRebuild;
    //   await DiscussionHelper.addMessageToDiscussion(
    //       message, DiscussionHelper.getDiscussionId(message));
    //   allDiscussions[discussionId] = Discussion(
    //       discussionId: discussionId,
    //       messages: [message],
    //       unread: 1,
    //       displayName: Get.find<KeyController>().getDisplayName(discussionId));
    // } else {
    //   //allDiscussions.refresh();
    //   await DiscussionHelper.addMessageToDiscussion(
    //       message, DiscussionHelper.getDiscussionId(message));
    //   Discussion newDiscussion = Discussion(
    //       discussionId: discussionId,
    //       messages: allDiscussions[discussionId]!.messages.add(message),
    //       unread: allDiscussions[discussionId]!.unread++,
    //       displayName: allDiscussions[discussionId]!.displayName);
    //   allDiscussions[discussionId] =
    //       allDiscussions[discussionId]!.messages.add(message);
    // }
  }

  Future<void> reinitUnreadController(String discussionId) async {
    allDiscussions.refresh();
    await DiscussionHelper.reinitUnread(discussionId);
    iniAllDiscussionUnread();
  }

  void iniAllDiscussionUnread() {
    for (Discussion discussion in allDiscussions.values) {
      if (discussion.unread != 0) {
        allDiscussionsUnread[discussion.discussionId] = (discussion);
      }
    }
    for (Discussion discussion in allDiscussionsUnread.values) {
      if (discussion.unread == 0) {
        //enlever la discussion dans le dico
        allDiscussionsUnread.remove(discussion
            .discussionId); //[discussion.discussionId] = (discussion);
      }
    }
  }

  /*void addDiscussion(Discussion discussion) async {
    bool found = false;
    for (var discus in allDiscussions) {
      if (discus.discussionId == discussion.discussionId) {
        allDiscussions.remove(discus);
        allDiscussions.add(discussion);
        found = true;
        break;
      }
    }
    if (!found) {
      allDiscussions.add(discussion);
    }
  }*/

  List<ChatMessage> getDiscussionMessages(String discussionId) {
    if (allDiscussions.keys.contains(discussionId)) {
      return allDiscussions[discussionId]!.messages;
    }

    return [];
  }
}
