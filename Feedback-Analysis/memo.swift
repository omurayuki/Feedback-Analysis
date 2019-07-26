 //// 直近やること

 //////////クリティカル修正点
 // limit タイムラインのみ　マイページはそこまでデータが大きくならないという(アプリの性質的に更新頻度が多くないと予想)前提でぐるぐるは一旦実装しない
 // cellに仕事をさせすぎている問題
 // MainTabControllerでappuserdefaultを直接読んでる
 // PublicCompleteViewControllerとPublicGoalViewControllerでuser情報fetch中にisUserEnable = false にしている問題(userのphotoをタップさせたくないだけ)
 // detailPresenterImplでgetGoalsAuthorTokensを使ってcommentのauthorTokenを操作しているが、getCommentAuthorTokensにするべき(replyPresenterImplも)
 
  //////////ゆくゆく修正点
 // reply画面から戻ってきたときに、cellが押せないときがある (textfield出現が何かをしている)
 // いくつかのcontrollerで同じような記述をしている
 // 変数名を正しく
 // PaddingTextFieldとtextfieldをbuilderで作成(いろんなところで作ってるから)
 // comment, replyをぐるぐるfetch
 //  UIのコンポーネント化
 // goalDocumentIdをdocumentIdと書いているから修正
 // decodable
 // cellの共通インターフェース作成
 // providerリファクタ
 // firebaseのgoalsのデータを削除したときにcommentテーブルのデータも削除されない
 // firebaseRefをpresenterで普通に記述しているけど、今思ったらこのデータはpresenterが意識すべきではないと思う(というのも、エンドポイントがsqlデータベースに変わった時に、presenter層も影響を受けるから)
 // mypageやotherpageのprofileはaddsnapshotlistener
// 他の人のフォロー、フォロワーから自分のページに行けないように
// フォロー、フォロワーからページに行って、またフォロー、フォロワーに行くと上書きされて戻ってきたときにその前の人のフォロー、フォロワーがおかしくなる
 
 //////////必須
 // push通知設定
 // comment, replyをぐるぐるfetch
 // チャット機能実装
 // 強み分析機能実装
 
 
 
 //// マストじゃないがゆくゆく実装するもの
//  mypageをscrollViewにする
//  detailをscrollViewにする
//  目標投稿時のimage選択(複数)
//  変更に強いプログラムにするため、各レイヤーを依存関係逆転の原則で置き換えられるか検討
 
 ///////マイページからの投稿, タイムラインからの投稿で向き咲き分けるべき？
 //// replyのいいね機能作成 replyはデータ構造的にも、用途的にも今回は見送り


 //// 最後にすること
 // documentまとめる
 // firenaseの機能をどう使うかのベストプラクティス

 //// 開発に対して思うこと
 // アーキテクチャも大切だけど、UIやデータベースの設計も同じくらい大切
 // UI設計(presenter層)が大切
   // Viewのコンポーネント管理や、共通化をどうすべきかなど
   // 画面遷移図などを作り、ざっくりとデータの流れを書き起こすなど
 // firebaseのリージョンを正しく設定する(遠くと通信が遅くなる)
 // 設計は途中で作りかえることもよくある
 // 配列の操作は難しい(繊細)
 // 自分の肌感覚でメソッドをここに記述するべきかを考えるのではなく、実用物として処理をここに書いてどのような恩恵があるのかを考える
 
//// documentにまとめる項目
// databaseの構造を定義した理由
// documentにまとめることを調べてまとめる
