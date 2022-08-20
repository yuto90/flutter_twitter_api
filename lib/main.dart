import 'package:flutter/material.dart';
import 'package:twitter_api_v2/twitter_api_v2.dart' as v2;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Twitter API',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Twitter API'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // 取得したトークンを設定
  final twitter = v2.TwitterApi(
    bearerToken: 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX',
    oauthTokens: v2.OAuthTokens(
      consumerKey: 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX',
      consumerSecret: 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX',
      accessToken: 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX',
      accessTokenSecret: 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX',
    ),
  );

  // ボタン押下フラグ
  bool isTweet = false;
  bool isFav = false;
  bool isReTweet = false;

  // 自分のユーザー情報を格納しておく用
  late v2.TwitterResponse myInfo;
  // ツイートのIDを格納しておく用
  late String tweetID;

  // ツイートする
  Future<void> tweet() async {
    // createTweet:ツイートするメソッド
    final nowTweet =
        await twitter.tweetsService.createTweet(text: 'Twitter APIからツイートしてるよ');

    // 今のツイートのIDを格納しておく
    tweetID = nowTweet.data.id;

    createNowTweetUrl();

    setState(() {
      isTweet = true;
      print('ツイート成功！');
    });
  }

  // ツイートのURLを作成
  void createNowTweetUrl() async {
    // lookupMe:自分のアカウント情報を取得するメソッド
    // 自分のユーザー情報を格納しておく
    myInfo = await twitter.usersService.lookupMe();

    print(
        'ツイートのURL:\nhttps://twitter.com/${myInfo.data.username}/status/$tweetID');
  }

  // いいねする
  Future<void> fav() async {
    // createLike:いいねするメソッド
    await twitter.tweetsService.createLike(
      userId: myInfo.data.id,
      tweetId: tweetID,
    );

    setState(() {
      isFav = true;
      print('いいね成功！');
    });
  }

  // リツイートする
  Future<void> reTweet() async {
    // createRetweet:リツイートするメソッド
    await twitter.tweetsService.createRetweet(
      userId: myInfo.data.id,
      tweetId: tweetID,
    );

    setState(() {
      isReTweet = true;
      print('リツイート成功！');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: isTweet ? Colors.green : Colors.red,
                ),
                onPressed: tweet,
                child: Text(isTweet ? 'ツイートしたよ' : '1:ツイートする'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: isTweet ? fav : null,
                child: Text(isFav ? 'いいねしたよ' : '2:いいねする'),
                style: ElevatedButton.styleFrom(
                  primary: isFav ? Colors.green : Colors.red,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: isFav ? reTweet : null,
                child: Text(isReTweet ? 'リツイートしたよ' : '3:リツイートする'),
                style: ElevatedButton.styleFrom(
                  primary: isReTweet ? Colors.green : Colors.red,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
