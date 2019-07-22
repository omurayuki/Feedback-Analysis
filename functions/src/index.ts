import * as functions from 'firebase-functions';
import { FieldValue } from '@google-cloud/firestore';
import * as admin from 'firebase-admin';
import goal = require('./goal');
import comment = require('./comment');
admin.initializeApp(functions.config().firebase);
const firestore = admin.firestore();

interface RootPost extends goal.Goal {
  authorRef?: FirebaseFirestore.DocumentReference;
}

export const onUserPostCreate = functions.firestore.document('/Users/{userId}/Goals/{postId}').onCreate(async (snapshot, context) => {
  await copyToRootWithUsersPostSnapshot(snapshot, context);
});

export const onUsersPostUpdate = functions.firestore.document('/Users/{userId}/Goals/{postId}').onUpdate(async (change, context) => {
  await copyToRootWithUsersPostSnapshot(change.after, context);
});

export const onUserPostDelete = functions.firestore.document('/Users/{userId}/Goals/{postId}').onDelete(async (snapshot, _) => {
  await deleteToRootWithUsersPostSnapshot(snapshot);
});

export const onUserCommentPosted = functions.firestore.document('/Goals/{postId}/Comments/{commentId}').onCreate(async (snapshot, context) => {
  await updateCommentdCount(context);
  await copyToRootWithUsersCommentSnapshot(snapshot, context);
});

export const onUserCommentUpdate = functions.firestore.document('/Goals/{postId}/Comments/{commentId}').onUpdate(async (change, context) => {
  await copyToRootWithUsersCommentSnapshot(change.after, context);
})

export const onUserReplyPosted = functions.firestore.document('/Comments/{commentId}/Replies/{replyId}').onCreate(async (_, context) => {
  await updateRepliedCount(context);
});

export const onUserFollowCreated = functions.firestore.document('/Follows/{subjectUserId}/Following/{objectUserId}').onCreate(async (snapshot, context) => {
  await createFollowerSnapshot(snapshot, context);
  await updateFollowCount(context);
  await updateFollowerCount(context);
});

export const onUserFollowDeleted = functions.firestore.document('/Follows/{subjectUserId}/Following/{objectUserId}').onDelete(async (snapshot, context) => {
  await deleteFollowerSnapshot(snapshot, context);
});

async function copyToRootWithUsersPostSnapshot(snapshot: FirebaseFirestore.DocumentSnapshot, context: functions.EventContext) {
  const postId = snapshot.id;
  const userId = context.params.userId;
  const post = snapshot.data() as RootPost;
  post.authorRef = firestore.collection('Users').doc(userId);
  await firestore.collection('Goals').doc(postId).set(post, { merge: true });
}

async function copyToRootWithUsersCommentSnapshot(snapshot: FirebaseFirestore.DocumentSnapshot, context: functions.EventContext) {
  const commentId = snapshot.id;
  const post = snapshot.data() as comment.Comment;
  await firestore.collection('Comments').doc(commentId).set(post, { merge: true });
}

async function deleteToRootWithUsersPostSnapshot(snapshot: FirebaseFirestore.DocumentSnapshot) {
  const postId = snapshot.id;
  await firestore.collection('Goals').doc(postId).delete();
  await firestore.collection('Goals').doc(postId).collection('Comments').get().then((shot) => {
    shot.forEach(async ds => {
      await ds.ref.delete();
    });
  });
  await firestore.collection('Goals').doc(postId).collection('likeUsers').get().then((shot) => {
    shot.forEach(async ds => {
      await ds.ref.delete();
    });
  });
}

async function updateCommentdCount(context: functions.EventContext) {
  const postId = context.params.postId;
  let index = 0;
  let author_token = '';
  await firestore.collection('Goals').doc(postId).collection('Comments').get()
    .then(async snapshot => {
      snapshot.forEach(doc => {
        index++;
      });
    }).catch(err => {
      console.log(err.log);
    });
  await firestore.collection('Goals').doc(postId).get()
    .then(async snapshot => {
      const data = snapshot.data();
      if (data != undefined) {
        author_token = data.author_token;
      }
    }).catch(err => {
      console.log(err.log);
    });
  await firestore.collection('Goals').doc(postId).set({ commented_count: index }, { merge: true });
  await firestore.collection('Users').doc(author_token).collection('Goals').doc(postId).set({ commented_count: index }, { merge: true });
}

async function updateRepliedCount(context: functions.EventContext) {
  const commentId = context.params.commentId;
  let index = 0;
  let goal_document_id = '';
  await firestore.collection('Comments').doc(commentId).collection('Replies').get()
    .then(async snapshot => {
      snapshot.forEach(doc => {
        index++;
      });
    }).catch(err => {
      console.log(err.log);
    });
  await firestore.collection('Comments').doc(commentId).get()
    .then(async snapshot => {
      const data = snapshot.data();
      if (data != undefined) {
        goal_document_id = data.goal_document_id;
      }
    }).catch(err => {
      console.log(err.log);
    });
  await firestore.collection('Comments').doc(commentId).set({ replied_count: index }, { merge: true });
  await firestore.collection('Goals').doc(goal_document_id).collection('Comments').doc(commentId).set({ replied_count: index }, { merge: true });
}

async function createFollowerSnapshot(snapshot: FirebaseFirestore.DocumentSnapshot, context: functions.EventContext) {
  const subjectUserId = snapshot.id;
  const followerId = context.params.subjectUserId;
  await firestore.collection('Follows').doc(subjectUserId).collection('Follower').doc(followerId).set({
    following_user_token: followerId,
    created_at: FieldValue.serverTimestamp()
  }, { merge: true });
}

async function deleteFollowerSnapshot(snapshot: FirebaseFirestore.DocumentSnapshot, context: functions.EventContext) {
  const subjectUserId = snapshot.id;
  const followerId = context.params.subjectUserId;
  await firestore.collection('Follows').doc(subjectUserId).collection('Follower').doc(followerId).delete();
}

async function updateFollowCount(context: functions.EventContext) {
  const subjectUserId = context.params.subjectUserId;
  let index = 0;
  await firestore.collection('Follows').doc(subjectUserId).collection('Following').get()
    .then(async snapshot => {
      snapshot.forEach(doc => {
        index++;
      });
    }).catch(err => {
      console.log(err.log);
    });
  await firestore.collection('Users').doc(subjectUserId).set({ follow: index }, { merge: true });
}

async function updateFollowerCount(context: functions.EventContext) {
  const objectUserId = context.params.objectUserId;
  let index = 0;
  await firestore.collection('Follows').doc(objectUserId).collection('Follower').get()
    .then(async snapshot => {
      snapshot.forEach(doc => {
        index++;
      });
    }).catch(err => {
      console.log(err.log);
    });
  await firestore.collection('Users').doc(objectUserId).set({ follower: index }, { merge: true });
}