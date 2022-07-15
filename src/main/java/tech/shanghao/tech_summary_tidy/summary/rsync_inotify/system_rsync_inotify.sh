#!/bin/sh
INOTIFY_CMD="inotifywait -mrq -e modify,create,attrib,move,delete /opt/rysnc /opt/hello "
$INOTIFY_CMD | while read FILE
do
	INO_EVENT=$(echo $file | awk '{print $1}')      # 把inotify输出切割 把事件类型部分赋值给INO_EVENT
    INO_FILE=$(echo $file | awk '{print $2}')       # 把inotify输出切割 把文件路径部分赋值给INO_FILE
	rsync -vzrtopg --progress --delete --files-from='/etc/rsync/include.txt' --exclude-from='/etc/rsync/exclude.txt'  --password-file=/etc/rsync/rsync_client.password  /opt/hello hello_rsync@opposite_ip::hello
done
