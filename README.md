<h1>SWebViewImageDownload</h1>

從網頁跟HTML Body撈取所有圖片的URL網址

<h2>使用方法</h2>
<b>安裝：</b>
</br>
在podfile內新增
</br>
pod "SWebViewImageDownload"，接著pod install
</br>
<b>使用：</b>
</br>
給訂一個網址
</br>
NSString *url = @"http://xxxx.com";
</br>
初始化SWebViewImageDownload，並給stringType（StringTypeWithURL為一般網址、StringTypeWithHTML為HTML Body內文）
</br>
SWebViewImageDownload *webImageDownload = [[SWebViewImageDownload alloc] initWithHTMLString:url stringType:StringTypeWithURL];
<h2>Licence</h2>
</br>
This project uses MIT License.
