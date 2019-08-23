 //// 直近やること
 
 //////////クリティカル修正点
 // limit タイムラインのみ　マイページはそこまでデータが大きくならないという(アプリの性質的に更新頻度が多くないと予想)前提でぐるぐるは一旦実装しない
 // cellに仕事をさせすぎている問題
 // MainTabControllerでappuserdefaultを直接読んでる
 // PublicCompleteViewControllerとPublicGoalViewControllerでuser情報fetch中にisUserEnable = false にしている問題(userのphotoをタップさせたくないだけ)
 // detailPresenterImplでgetGoalsAuthorTokensを使ってcommentのauthorTokenを操作しているが、getCommentAuthorTokensにするべき(replyPresenterImplも)
 
 //////////ゆくゆく修正点
 // reply画面から戻ってきたときに、cellが押せないときがある (textfield出現が何かをしている)
 // 変数名を正しく
 // goalDocumentIdをdocumentIdと書いているから修正
 // decodable
 // cellの共通インターフェース作成
 // firebaseのgoalsのデータを削除したときにcommentテーブルのデータも削除されない
 // firebaseRefをpresenterで普通に記述しているけど、今思ったらこのデータはpresenterが意識すべきではないと思う(というのも、エンドポイントがsqlデータベースに変わった時に、presenter層も影響を受けるから)
 // mypageやotherpageのprofileはaddsnapshotlistener
 // 櫻井さんに教えてもらった方法でクライアントサイドジョイン解消
 // mypage detailをaddsnapshot(編集から戻ってきたときやコメント書き込みされたあとなどの理由から)
 // 他人のページの目標を編集できてしまう
 
 //////////必須
 // push通知設定
 // 強み分析機能実装
 // goalPostのdatepickerの挙動がおかしい(Analysisのstrengthmo)
 
 //// 強み結果表示までの構造
 // 強み分析post
    // GoalsのdocumentIDを紐づけて、個々のUser配下に(Goalsと同列)Completesというcollection作成
    // そこにGoalsのdocumentIDを筆頭として、目標に対するfieldを作成
    // AnalysisResultのチャート項目にはCompletesにある個々の強みを参照して表示
    // 強み項目をたっぷした時に、UserのCompletesからCompletesDocumentIDを参照して結果をみれる
    // タイムラインの項目(自分)の達成のどれかをタップしたら、自分のCompletesのマッチするGoalsDocumentIDをみて遷移する
    // タイムラインの項目(フォローユーザー)の達成をどれかタップしたら、そのユーザーのauthorTokenを使ってそのUserのCompletesのマッチするGoalsDocumentIDをみて遷移する
 
 // 配列形式でstrengthをpost 可能
 // user配下にstrengthをカウントするためだけのcollectionを作成して配列の中の要素(1~3)をカウント 可能
 // AnalysisResultの画面を構成するのはこのstrengthCollection
 // それぞれの強みをタップすると、
 // completesにpostすると、cloudfunctionで強みのデータだけその目標のfieldに追加する(強みを有している目標を取得するため)
 
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
 // firebaseQueryRefやdocumentRefは具体的すぎた quickChatみたいに抽象的なReferenceを設定すればendpointが変わっても既存のRefで対応できる
 // あらプロトコルをインターフェースにするとモデルの差し替えが行いやすい
 // deinit走らない..... lintの大切さ
 // UIも修正しやすいつくりに
 // ツールや環境は先に.....
 
 //// documentにまとめる項目
 // databaseの構造を定義した理由
 // documentにまとめることを調べてまとめる
