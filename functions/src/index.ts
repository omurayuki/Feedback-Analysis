import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import { FieldValue } from '@google-cloud/firestore';
admin.initializeApp(functions.config().firebase);
const firestore = admin.firestore();

interface Post {
  readonly genre: [string];
  readonly new_things: string;
  readonly goal: [{ string: string }];
  readonly deadline: string;
  readonly achived_flag: boolean;
  readonly draft_flag: boolean;
  readonly like_count: number;
  readonly commented_count: number;
  readonly created_at: FieldValue;
  readonly updated_at: FieldValue;
}

interface RootPost extends Post {
  authorRef?: FirebaseFirestore.DocumentReference;
}

interface Comment {
  readonly goal_document_id?: string;
  readonly comment: string;
  readonly like_count: number;
  readonly replied_count: number;
  readonly created_at: FieldValue;
  readonly updated_at: FieldValue;
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
  await updateCommentdCount(context)
  await copyToRootWithUsersCommentSnapshot(snapshot, context)
});

export const onUserReplyPosted = functions.firestore.document('/Comments/{commentId}/Replies/{replyId}').onCreate(async (_, context) => {
  await updateRepliedCount(context)
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
  const post = snapshot.data() as Comment;
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
