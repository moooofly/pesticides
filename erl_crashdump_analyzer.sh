#!/usr/bin/env bash

help()
{
    echo "Usage: ./erl_crashdump_analyzer.sh <crashdump>"
    exit 0
}

if [ "$#" -lt 1 ]
then
    help
    exit 1
fi

DUMP=$1

## -- echo -e 表示接受 '\'' 转义；
echo -e "analyzing $DUMP, generated on: " `head -2 $DUMP | tail -1` "\n"

### SLOGAN ###
## -- 仅过滤出一条（即第一条）含有 "Slogan:" 的信息
grep Slogan: $DUMP -m 1

### MEMORY ###
## -- 内存使用情况统计
echo -e "\nMemory:\n==="
## -- 获取 "processes: " 后的数值（字节）
M=`grep -m 1 'processes' $DUMP | sed "s/processes: //"`
let "m=$M/(1024*1024)"
echo "  processes: $m Mb"
M=`grep -m 1 'processes_used' $DUMP | sed "s/processes_used: //"`
let "m=$M/(1024*1024)"
echo "  processes_used: $m Mb"
M=`grep -m 1 'system' $DUMP | sed "s/system: //"`
let "m=$M/(1024*1024)"
echo "  system: $m Mb"
M=`grep -m 1 'atom' $DUMP | sed "s/atom: //"`
let "m=$M/(1024*1024)"
echo "  atom: $m Mb"
M=`grep -m 1 'atom_used' $DUMP | sed "s/atom_used: //"`
let "m=$M/(1024*1024)"
echo "  atom_used: $m Mb"
M=`grep -m 1 'binary' $DUMP | sed "s/binary: //"`
let "m=$M/(1024*1024)"
echo "  binary: $m Mb"
M=`grep -m 1 'code' $DUMP | sed "s/code: //"`
let "m=$M/(1024*1024)"
echo "  code: $m Mb"
M=`grep -m 1 'ets' $DUMP | sed "s/ets: //"`
let "m=$M/(1024*1024)"
echo "  ets: $m Mb"
M=`grep -m 1 'total' $DUMP | sed "s/total: //"`
let "m=$M/(1024*1024)"
echo -e "  ---\n  total: $m Mb"

### PROCESS MESSAGE QUEUES LENGTHS ###
echo -e "\nDifferent message queue lengths (5 largest different):\n==="
## -- 排序所有进程的消息队列长度，取消息数最多的 5 个显示出来
grep 'Message queue len' $DUMP | sed 's/Message queue length: //g' | sort -n -r | uniq -c | head -5

### ERROR LOGGER QUEUE LENGTH ###
echo -e "\nError logger queue length:\n==="
## -- 匹配第一条 "Name: error_logger" 行，同时输出其上下各 10 行数据，从这些数据中匹配 'Message queue length: ' 获取其对应值
grep -C 10 'Name: error_logger' $DUMP -m 1| grep 'Message queue length' | sed 's/Message queue length: //g'

### PORT/FILE DESCRIPTOR INFO ###
echo -e "\nFile descriptors open:\n==="
## -- udp_inet 对应 UDP 端口使用
echo -e "  UDP: "   `grep 'Port controls linked-in driver:' $DUMP | grep 'udp_inet' | wc -l`
## -- tcp_inet 对应 TCP 端口使用
echo -e "  TCP: "   `grep 'Port controls linked-in driver:' $DUMP | grep 'tcp_inet' | wc -l`
## -- 去除 udp_inet 和 tcp_inet 对应的行，剩下的对应 FILE 相关使用（efile 或 tty_sl -c -e 等）
echo -e "  Files: " `grep 'Port controls linked-in driver:' $DUMP | grep -vi 'udp_inet' | grep -vi 'tcp_inet' | wc -l`
echo -e "  ---\n  Total: " `grep 'Port controls linked-in driver:' $DUMP | wc -l`

### NUMBER OF PROCESSES ###
echo -e "\nNumber of processes:\n==="
## -- 统计进程数量（以 "=proc:" 开头的部分对应进程信息开始）
grep '=proc:' $DUMP | wc -l

### PROC HEAPS+STACK ###
echo -e "\nProcesses Heap+Stack memory sizes (words) used in the VM (5 largest different):\n==="
## -- 获取 "Stack+heap: " 字段后的数值，排序后取前 5 
grep 'Stack+heap' $DUMP | sed "s/Stack+heap: //g" | sort -n -r | uniq -c | head -5

### PROC OLDHEAP ###
echo -e "\nProcesses OldHeap memory sizes (words) used in the VM (5 largest different):\n==="
grep 'OldHeap' $DUMP | sed "s/OldHeap: //g" | sort -n -r | uniq -c | head -5

### PROC STATES ###
echo -e "\nProcess States when crashing (sum): \n==="
## -- 获取发生 crash 时的全部进程状态（例如 Waiting 或 Running）
grep 'State: ' $DUMP | sed "s/State: //g" | sort | uniq -c