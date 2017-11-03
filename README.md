mqtt2tepra
====
MQTTでsubscribeしているtopicに流れてきた文字列をテプラで印刷するスクリプト。

memo
----
TEPRA SR5900Pに付属しているSPC10.exe(印刷用アプリ)は、次のようにコマンドラインから起動すると、GUIを開くことなく流し込み印刷を実行することができる。

    
    > "C:\Program Files\KING JIM\TEPRA SPC10\SPC10.exe" /pt "c:\temp\TPEファイル.tpe,c:\temp\CSVファイル.csv,1,/C -f -hn,/TW -off" "KING JIM SR5900P-NW"
    

オプション/ptの後に、カンマ区切りで次の要領でパラメータを渡す。

    tpeファイルへのフルパス,csvファイルへのフルパス,印刷部数,オプション1,オプション2,...

SPC10.exeを起動する際の引数の最後はプリンタ名。何も指定しない場合はデフォルトのプリンタが使用される。

tpeファイルはあらかじめSPC10.exeのGUIから流し込み印刷用のひながたを作成しておくこと。

CSVファイルの文字コードはShift JISなので要注意。

オプションは次の通り
  * /C -f -hn : フルカットON、ハーフカットOFFの指定
  * /TW -off : テープ幅確認ダイアログ表示のOFF

Reference
----
TEPRA SR5900P
  * http://www.kingjim.co.jp/products/tepra/detail/_id_SR5900P

SPC10
  * http://www.kingjim.co.jp/support/tepra/software/dl12

SPC10-API
  * http://www.kingjim.co.jp/support/tepra/spc10_api

Copyright and license
----
Copyright (c) 2017 yoggy

Released under the [MIT license](LICENSE)
