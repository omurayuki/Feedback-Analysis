import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import { FieldValue } from '@google-cloud/firestore';
admin.initializeApp(functions.config().firebase);
const firestore = admin.firestore();

interface Post {
  readonly genre: [string];
  readonly new_things: string;
  readonly goal: [{string: string}];
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

export const onUserPostCreate = functions.firestore.document('/Users/{userId}/Goals/{postId}').onCreate(async (snapshot, context) => {
  await copyToRootWithUsersPostSnapshot(snapshot, context);
});

export const onUsersPostUpdate = functions.firestore.document('/Users/{userId}/Goals/{postId}').onUpdate(async (change, context) => {
  // await copyToRootWithUsersPostSnapshot(change.after, context);
  await createLikedCountTable(change.before, change.after, context);
});

export const onUserPostDelete = functions.firestore.document('/Users/{userId}/Goals/{postId}').onDelete(async (snapshot, _) => {
  await deleteToRootWithUsersPostSnapshot(snapshot);
});

export const onUserCommentPosted = functions.firestore.document('/Goals/{postId}/Comments/{commentId}').onCreate(async (_, context) => {
  await updateCommentdCountInGoal(context)
});

async function copyToRootWithUsersPostSnapshot(snapshot: FirebaseFirestore.DocumentSnapshot, context: functions.EventContext) {
  const postId = snapshot.id;
  const userId = context.params.userId;
  const post = snapshot.data() as RootPost;
  post.authorRef = firestore.collection('Users').doc(userId);
  await firestore.collection('Goals').doc(postId).set(post, { merge: true });
}

async function createLikedCountTable(snapshot_before: FirebaseFirestore.DocumentSnapshot, snapshot_after: FirebaseFirestore.DocumentSnapshot, context: functions.EventContext) {
  const post_before = snapshot_before.data() as RootPost;
  const post_after = snapshot_after.data() as RootPost;
  const postId = snapshot_after.id;
  const userId = context.params.userId;
  post_after.authorRef = firestore.collection('LikedGoals').doc(postId).collection('LikeUsers').doc(userId);
  if (post_before.like_count < post_after.like_count) {
    console.log("作成")
    await post_after.authorRef.set( {user_token: userId} );
  } else if (post_before.like_count > post_after.like_count) {
    console.log("削除")
    await post_after.authorRef.delete();
  } else {
    console.log("それ以外")
    return;
  }
}

async function deleteToRootWithUsersPostSnapshot(snapshot: FirebaseFirestore.DocumentSnapshot) {
  const postId = snapshot.id;
  await firestore.collection('Goals').doc(postId).delete();
}

async function updateCommentdCountInGoal(context: functions.EventContext) {
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