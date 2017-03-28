# erl_crashdump_analyzer.sh 说明

> 官方地址：[这里](https://github.com/ferd/recon/blob/master/script/erl_crashdump_analyzer.sh)

## 使用方法

```
./erl_crashdump_analyzer.sh erl_crash.dump
```

## 使用示例

```shell
➜  pesticides git:(master) ✗ ./erl_crashdump_analyzer.sh erl_crash.dump
analyzing erl_crash.dump, generated on:  Mon Mar 27 18:07:41 2017

Slogan: abort

Memory:
===
  processes: 14 Mb
  processes_used: 14 Mb
  system: 35 Mb
  atom: 0 Mb
  atom_used: 0 Mb
  binary: 0 Mb
  code: 23 Mb
  ets: 1 Mb
  ---
  total: 50 Mb

Different message queue lengths (5 largest different):
===
 205 0

Error logger queue length:
===

File descriptors open:
===
  UDP:  0
  TCP:  6
  Files:  65
  ---
  Total:  71

Number of processes:
===
     205

Processes Heap+Stack memory sizes (words) used in the VM (5 largest different):
===
   1 196650
   1 46422
   1 17731
   1 1598
   6 987

Processes OldHeap memory sizes (words) used in the VM (5 largest different):
===
   1 376
   1 OldHeap unused: 290
 204 OldHeap unused: 0
 204 0

Process States when crashing (sum):
===
   1 Current Process Internal ACT_PRIO_NORMAL | USR_PRIO_NORMAL | PRQ_PRIO_NORMAL | ACTIVE | RUNNING | ON_HEAP_MSGQ
   1 Current Process Running
   1 Internal ACT_PRIO_HIGH | USR_PRIO_HIGH | PRQ_PRIO_HIGH | ON_HEAP_MSGQ
   4 Internal ACT_PRIO_MAX | USR_PRIO_MAX | PRQ_PRIO_MAX | ON_HEAP_MSGQ
   2 Internal ACT_PRIO_MAX | USR_PRIO_MAX | PRQ_PRIO_MAX | TRAP_EXIT | ON_HEAP_MSGQ
   1 Internal ACT_PRIO_NORMAL | USR_PRIO_NORMAL | PRQ_PRIO_NORMAL | ACTIVE | RUNNING | ON_HEAP_MSGQ
  72 Internal ACT_PRIO_NORMAL | USR_PRIO_NORMAL | PRQ_PRIO_NORMAL | ON_HEAP_MSGQ
 125 Internal ACT_PRIO_NORMAL | USR_PRIO_NORMAL | PRQ_PRIO_NORMAL | TRAP_EXIT | ON_HEAP_MSGQ
   1 Running
 204 Waiting
➜  pesticides git:(master) ✗
```
