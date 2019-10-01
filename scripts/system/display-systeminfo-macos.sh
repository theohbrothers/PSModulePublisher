#!/bin/bash -eu

hostname
whoami
system_profiler -detailLevel mini
top -l 1 -s 0 | grep PhysMem
df -h
pwd
