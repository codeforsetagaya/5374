{Scraper} = require '../coffee/helper'

# 分別方法
s = new Scraper(
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

# 完了後、PhantomJSを終了
s.run -> phantom.exit()
