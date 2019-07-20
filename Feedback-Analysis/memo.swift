 //// 直近やること
 // また、クリティカルな部分のUI設計
   // interface(骨格部分)の見直し
   // notification(子 -> 複数の親), delegate(子 <-> 親), closure(親 -> 複数の子)を使って表現
   // 後々共通化できそうなviewやcontrollerをチェック
   // cellの責務を定義
   // 共通化できそうな項目を見つけて解消法を調べる

 //////////クリティカル修正点
 // limit タイムラインのみ　マイページはそこまでデータが大きくならないという(アプリの性質的に更新頻度が多くないと予想)前提でぐるぐるは一旦実装しない
 // GoalPostEditViewControllerのグローバル変数documentId
 //  cellに仕事をさせすぎている問題
 // MainTabControllerでappuserdefaultを直接読んでる
 // PublicCompleteViewControllerとPublicGoalViewControllerでuser情報fetch中にisUserEnable = false にしている問題(userのphotoをタップさせたくないだけ)
 
  //////////ゆくゆく修正点
 // reply画面から戻ってきたときに、cellが押せないときがある
 // タイムラインを読み込んだときに、最初のユーザーphotoをタップすると別の人のページに行く
 // いくつかのcontrollerで同じような記述をしている
 // 変数名を正しく
 // PaddingTextFieldとtextfieldをbuilderで作成(いろんなところで作ってるから)
 // comment, replyをぐるぐるfetch
 //  UIのコンポーネント化
 // goalDocumentIdをdocumentIdと書いているから修正
 // decodable
 // cellの共通インターフェース作成
 // providerリファクタ
 // pageViewControllerのdataSourceを切り分け
 
 //////////必須
 // push通知設定
 // follow機能
   // mypageのフォローラベルをbuttonに変更
   // follow一覧ページ作成
   // 自分のページにはいけないように
   // フォローした場合、外した場合、自分のページのフォロー数が増えるandフォローされたらフォロワー数が増える
   // フォローすれば、データベースにフォローした人の情報を記載して、そこから目標を全て取得できる
 // comment, replyをぐるぐるfetch
 // followしている人のタイムライン画面
 // チャット機能実装
 // 強み分析機能実装
 
 
 
 //// マストじゃないがゆくゆく実装するもの
//  mypageをscrollViewにする
//  detailをscrollViewにする
//  目標投稿時のimage選択(複数)
 
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
 
//// documentにまとめる項目
// databaseの構造を定義した理由
// documentにまとめることを調べてまとめる
