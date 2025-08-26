#!/bin/bash

workspace_id=$1
monitor_full=$(aerospace list-windows --workspace $workspace_id --format "%{monitor-appkit-nsscreen-screens-id}")
monitor_id=${monitor_full:0:1}
echo $monitor_id
