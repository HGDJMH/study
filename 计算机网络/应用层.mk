在浏览器中输入网址 (URL)到服务器返回消息的过程
> 应用层操作
>> + 生成HTTP请求消息
>> + 根据域名查询IP地址，通过DNS
### 1.1 生成HTTP请求消息
#### 1.1.1 探索之旅从输入网址开始
#### 1.1.2 浏览器先要解析URL
#### 1.1.3 省略文件名的情况
#### 1.1.4 HTTP的基本思路
**HTTP的主要方法**：
+ GET：获取URI指定的信息。如果URI指定的是文件，则返回文件的内容；如果URI指定的是CGI程序，则返回该程序的输出数据。使用GET，请求报文中的实体体为空。

若使用GET方法提交表单，则在所请求的URL里包含输入的数据。

URI：统一资源标识符。URI的内容是一个存放网页数据的文件名或者是一个CGI程序的文件名。不过，URI不仅限于此，也可以直接使用“http:” 开头的URL来作为URI。换句话说就是，这里可以写各种访问目标，而这些访问目标统称为URI。

+ POST：从客户端向服务器发送数据。一般用于发送表单中填写的数据等情况。POST方法使用请求报文中的实体体，包含的就是用户在表单字段中输入的内容。POST报文仍然可以向服务器请求一个web页面，但web页面的特定内容依赖于用户在表单字段中输入的内容。

**HTTP状态字**
+ 200：请求成功
+ 301：请求的对象已经被永久转移了，新的URL定义在响应报文中的location：首部行中。客户软件将自动获取新的URL。
+ 400：一个通用差错代码，指示该请求不能被服务器理解
+ 403：服务器接收到请求，但拒绝提供服务
+ 404：被请求的文档不在服务器上
+ 505：服务器不支持请求报文使用的HTTP协议版本。

### 1.2 向DNS服务器查询Web服务器的IP地址
#### 1.2.1 IP地址相关知识
+ 网络和子网
+ IP地址的表示方法
主机号和网络号，子网掩码，特殊的主机号 (主机号全为0或者全为1)
#### 1.2.2 为什么要使用DNS
#### 1.2.3 Socket库
对于DNS服务器，计算机上一定有相应的DNS客户端，而相当于DNS客户端的部分称为DNS解析器，或者简称解析器。通过DNS查询IP地址的操作称为域名解析，因此 负责执行解析（resolution）这一操作的就叫解析器（resolver）了

Socket 库是用于调用网络功能的程序组件集合，解析器就是这个库中的其中一种程序组件 

解析器的调用方法：
![](./S1_figure/解析器调用方法.JPG)
调用解析器后，解析器会向DNS服务器发送查询消息，然后DNS服务器会返回响应消息。响应消息中包含查询到的IP地址，解析器会取出IP 地址，并将其写入浏览器指定的内存地址中。只要运行图1.11中的这一行 程序，就可以完成前面所有这些工作，我们也就完成了IP地址的查询。接 下来，浏览器在向Web 服务器发送消息时，只要从该内存地址取出IP地 址，并将它与HTTP请求消息一起交给操作系统就可以了。

+ 根据域名查询 IP 地址时，浏览器会使用 Socket 库中的解析器
### 1.2.5 解析器内部原理
解析器工作流程
![](./S1_figure/解析器工作流程.JPG)

***注意***：DNS消息是二进制的，HTTP消息是文本编写的
***注意***：DNS查询消息以及响应消息都是UDP发送

DNS服务器的IP地址是作为TCP/IP的一个设置项目事先设置好的，不需要再去查询了

### 1.3.1 DNS服务器的基本工作
DNS服务器的基本工作就是接收来自客户端的查询消息，然后根据消息的内容返回响应。

客户端查询消息的类型：
> (a). 域名：服务器、邮件服务器的名称。
> (b). Class: 识别网络信息，永远为互联网的IN
> (c). 记录类型：当类型为A时，表示域名对应的是IP地址；当类型为MX时，表示域名对应的是邮件服务器。对于不同的记录类型，服务器向客户端返回的信息也会不同
DNS服务器的基本工作：
![](./S1_figure/DNS服务器的基本工作.JPG)

DNS服务器之间的查询操作：
![](./S1_figure/DNS服务器之间的查询操作.JPG)

### 1.3.2 通过缓存加快查询操作
缓存可以减少查询所需的时间。当要查询的域名不存在时，“ 不存在”这一响应结果也会被缓存。这样，当下次查询这个不存在的域名时，也可以快速响应。

***注意*** 那就是信息被缓存后，原本的注册信 息可能会发生改变，这时缓存中的信息就有可能是不正确的。DNS服务器中保存的信息都设置有一个有效期，当缓存中的信息超过有效期后，数 据就会从缓存中删除。而且，在对查询进行响应时，DNS服务器也会告知客 户端这一响应的结果是来自缓存中还是来自负责管理该域名的DNS服务器。

### 1.4 委托协议栈发送消息

### cookie
使用场景：wen站点通常希望能够识别用户，希望把内容与用户身份联系起来。
+ 用户使用某台PC首次访问一个web服务器
+ 该web网站会产生一个唯一识别码，然后web服务器用一个包含Set-cookie:首部的HTTP响应报文对该用户的PC中浏览器器进行响应。
+ 浏览器接收到响应报文，看到Set-cookie: 首部。该浏览器在它管理的特定cookie文件中添加一行。该行包括服务器的主机名以及识别码
+ 往后该浏览器对这个web服务器进行请求时，浏览器会从cookie文件中获取该识别码，并放到HTTP的请求报文包括识别码的cookie首部行中。

### SMTP
SMTP操作的过程：
+ Alice调用她的邮件代理程序并提供Bob的邮件地址，撰写报文，然后指示用户代理发送该报文。
+ Alice的用户代理把报文发给她的邮件服务器，在那里该报文被放在报文队列中
+ 运行在Alice的邮件服务器上的SMTP客户端发现了报文队列中的这个报文，它就创建一个到运行在Bob的邮件服务器上的SMTP服务器的TCP连接
+ 在Bob邮件服务器上，SMTP的服务器接收该报文。然后将该访问放入Bob的邮箱中。
+ 在Bob方便的时候，调用用户代理阅读该邮件。

### HTTPS的加密过程
1. 某网站拥有用于非对称加密的公钥A、私钥A'。
2. 浏览器像网站服务器请求，服务器把公钥A明文传输给浏览器。
3. 浏览器随机生成一个用于对称加密的密钥X, 用公钥A加密后传给服务器。
4. 服务器拿到后用私钥A'解密得到密钥X。

可能发生中间人攻击，因为浏览器无法确认自己收到的公钥是不是网站自己的。

解决这个问题：使用数据证书(CA)。

网站在使用https前，需要向‘CA机构’申请办法一份数字证书，数字证书里有证书持有者、证书持有者的公钥等信息，服务器把证书传输给浏览器，浏览器从证书里取公钥就行。

如何确定证书没有被篡改？

使用数字签名：
1. CA拥有非对称加密的公钥和私钥。
2. CA对证书明文信息进行hash
3. 对hash后的值用私钥加密，得到数字签名。

明文和数字签名共同组成了数字证书，这样一份数字证书就可以办法给网站了。

浏览器验证过程：
1. 拿到证书，得到明文T，数字签名S.
2. 用CA机构的公钥对S解密，得到S'
3. 对明文T进行hash得到T'
3. 比较S'是否等于T'.