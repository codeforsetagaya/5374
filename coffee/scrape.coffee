###
ゴミ収集日のデータを世田谷区サイトからスクレーピングするスクリプト

[環境] PhantomJSが必要です。Macの場合は、次のコマンドでインストールできます。
$ brew update && brew install phantomjs

[使い方] プロジェクトのルートディレクトリで次のコマンドを実行します。
$ phantomjs coffee/scrape.coffee
あるいは、gulpからの呼び出しでもOKです。
$ gulp scrape

[注意] 更新するのは area_days.csv, target.csv のみです。他のファイルは手動で更新する必要があります。
###

{Scraper} = require './helper'

# 収集日
s1 = new Scraper(
  'data/area_days.csv' # 保存先
  'http://www.city.setagaya.lg.jp/kurashi/101/113/260/d00005071.html' # URL
  '.detail > table > tbody' # セレクタ
  ['地名','センター','資源','可燃ごみ','不燃ごみ','ペットボトル'] # ヘッダ
  (data) -> # 書式の変換
    for row in data.slice(1) # 1行目をスキップ
      [
        row[1] + row[2] #地名
        row[7] # センター
        row[3] # 資源
        row[4] # 可燃ごみ
        row[5] # 不燃ごみ
        row[6] # ペットボトル
      ].map (cell) ->
        cell
        .replace(/\s/g, '') # 空白文字の除去
        .replace(/^(.)曜日$/, '$1') # パターン1
        .replace(/^(.)曜日・(.)曜日$/, '$1 $2') # パターン2
        .replace(/^(\d)回目・(\d)回目の(.)曜日$/, '$3$1 $3$2') # パターン3
)

# 分別方法
s2 = new Scraper(
  'data/target.csv' # 保存先
  'http://www.city.setagaya.lg.jp/kurashi/101/113/252/1872/d00005072.html' # URL
  '.detail > table > tbody' # セレクタ
  ['type', 'name', 'notice', 'furigana'] # ヘッダ
  (data) -> # 書式の変換
    for row in data.slice(1) # 1行目をスキップ
      c0 = (row[2].match /(資源|可燃ごみ|不燃ごみ)/)?[0]\
        || (row[1].match /^ペットボトル/)?[0]\
        || 'その他' # type
      c1 = row[1] # name
      c2 = row[2]
        .replace(/\s*\n\s*/g, '<br>')
        .replace(/^(資源|可燃ごみ|不燃ごみ)　?/, '')
        .replace(/^(（|\()(.*?)(\)|）|$)/, '$2') # notice
      c3 = row[0] # furigana
      [c0, c1, c2, c3]
)

# 順番に実行して、PhantomJSを終了
s1.run -> s2.run -> phantom.exit()
