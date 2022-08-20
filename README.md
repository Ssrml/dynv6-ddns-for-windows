# dynv6-ddns-for-windows
[这个脚本](https://github.com/pd12bbf7608ae1/dynv6-zone-ddns)的powershell重置版。

**但是用法有区别**

- 本脚本仅支持配置文件！！
- 出于安全性（其实是懒）考虑，本脚本仅支持key登录
- 除非主机类型为linux，否则默认使用wget获取公网ip（还是懒）
- 原脚本置文件中的 [common] 配置节 被换为 [zone] （少打字）
***

<br>
本脚本保存时使用的utf16-le格式，另外还涉及少量中文字符。使用时请**注意一下编码**，当然你也可以自己修改一下。


（懒*3） 脚本从[这个网站](ip.sb)直接获取公网ip地址。（因此一台主机只能上报一个ip）

配置文件支持的参数请看仓库中的示例
参数解释请参考[原脚本](https://github.com/pd12bbf7608ae1/dynv6-zone-ddns)。

<br>
  
***

<br>

