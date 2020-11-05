# PTT Efficient Poster

![demo](https://raw.githubusercontent.com/changyuheng/ptt-efficient-poster/master/demo.gif)

PTT Efficient Poster 是為了在 PTT 發表文章能得到合理稿酬而誕生的程式。因應 PTT 計算稿酬的方式，本程式會像打字機一般，將程式中的文章，在背景自動、逐字貼到 PTT 中。

## 注意事項

本程式被 PTT 站方針對性的禁止，使用前請先確定您了解風險。詳細說明請見：[PTT 帳號被砍事件](http://changyuheng.github.io/2015/ptt-%E5%B8%B3%E8%99%9F%E8%A2%AB%E7%A0%8D%E4%BA%8B%E4%BB%B6.html)

## 特色

* 支援 BBS 控制碼。
* 支援雙色全形字（一字雙色）。
* 支援 Big-5 擴充字集（支援 Unicode 補完計畫內的日文字）。
* 支援背景貼文。
* 支援臨時暫停貼文。
* 支援顯示預估時間。

## 相容性

* 作業系統：Windows 2000/XP/Vista/7/8/10 (x86 & x64)。
* BBS 客戶端：PCMan 9.5.0

## 使用說明

### 使用前準備

修改 PTT 站台設定如下：

```
　　(U)ser         【 個人設定區 】
　　　(U)Customize    個人化設定
　　　　i. DBCS       自動偵測雙位元字集(如全型中文)　　　　：是
　　　　j. DBCS       忽略連線程式為雙位元字集送出的重複按鍵：是
　　　　k. DBCS       禁止在雙位元中使用色碼(去除一字雙色)　：否
```

### 發文步驟

1. 將欲張貼的文章內容貼到程式中。
2. 打開 PCMan 並進入發文狀態。
3. 在 PCMan 中按下 Shift + F9 開始張貼。
4. 開始張貼後，可以切換到別的視窗做其他事，唯獨不可在 PCMan 中另開新分頁。

### 操作說明

* Shift + F9 開始張貼，張貼完成後程式會自動彈出提示視窗。
* 欲暫停張貼，請按 Shift + F11。暫停後，從工作列圖示的選單中取消暫停即可繼續貼文。
* 欲取消張貼，請按 Shift + F12 重新載入本程式，或關閉本程式。

## 下載

* [PTT Efficient Poster 2.0](https://raw.githubusercontent.com/changyuheng/ptt-efficient-poster/master/bin/PTTEfficientPoster.exe)
* [PCMan 9.5.0 Beta 3 (Novus)](https://raw.githubusercontent.com/changyuheng/ptt-efficient-poster/master/bin/PCMan.exe)