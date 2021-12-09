# Sample Memo App
メモを保存できるWebアプリケーションのサンプルです。
Sinatraを使って作成しています。

## 構築方法
### 前提
- [Git](https://git-scm.com/) がインストールされている
- [Ruby](https://www.ruby-lang.org/) がインストールされている (`.ruby-version` に書かれているバージョン)
- [Bundler](https://bundler.io/) がインストールされている

### 手順
1. Gitを使ってリポジトリをクローンします。
```
$ git clone https://github.com/pofkuma/sample-memo-app.git
```

2. Bundler を使って必要な gem をインストールします。
```
$ cd ./sample-memo-app
$ bundle install
```

3. Bundler を使ってアプリケーションを実行します。
```
$ bundle exec ruby app.rb
```

## 使い方
ブラウザで `http://localhost:4567` にアクセスします。

- 初期画面で、保存されているメモの一覧を確認できます。
「New」ボタンで、新しいメモを作成できます。

- 新規メモの作成画面で、タイトルと内容を入力します。
「Save」ボタンで、入力した内容を保存できます。

- 初期画面で、メモのタイトルをクリックすると、メモの内容を確認できます。
「Edit」ボタンで、メモの内容を編集できます。
「Delete」ボタンで、メモが削除されます。

- メモの編集画面で、タイトルと内容を編集できます。
「Update」ボタンで、入力した内容を上書き保存できます。

## 作成されるファイル
### ログ
```
./log/sample-memo-app.log
```

## データベースの設定
PostgreSQLのデータベースを利用します。
`.env`ファイルを編集して、接続先の情報を指定してください。
(使用するデータベースをあらかじめ作成する必要があります。)
