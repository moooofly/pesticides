# custom_crashdump.sh 说明

## 脚本说明

```
#!/usr/bin/env bash

help()
{
    echo "Usage: ./custom_crashdump.sh <rabbit_node_name>"
    exit 0
}

if [ "$#" -lt 1 ]
then
    help
    exit 1
fi

## 获取目标节点名
NODENAME=$1

## 编译
erlc custom_crashdump.erl

## TODO: 需要确定 nodename 对应节点的存在性 or 判定下面命令的返回值
erl -sname dbg -remsh ${NODENAME}@`hostname -s` -hidden -noshell -noinput -run custom_crashdump crash_dump -run erlang halt
```