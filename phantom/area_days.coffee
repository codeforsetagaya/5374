{Scraper} = require '../coffee/helper'

# 収集日
s = new Scraper(
  'data/area_days.csv' # 保存先
  'http://www.city.setagaya.lg.jp/kurashi/101/113/260/d00131841.html' # URL
  '.detail table > tbody' # セレクタ
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

# 完了後、PhantomJSを終了
s.run -> phantom.exit()
