#!/bin/bash

# 设置环境变量
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
export LANG=zh_CN.UTF-8

# 脚本名称和配置项
THIS_SCRIPT="sysinfo"
MOTD_DISABLE=""

# 显示IP地址的匹配模式
SHOW_IP_PATTERN="^[ewr].*|^br.*|^lt.*|^umts.*"

# 数据存储路径
DATA_STORAGE=/userdisk/data
MEDIA_STORAGE=/userdisk/snail

# 不要编辑以下内容
function display()
{
    # 函数：显示系统信息
    # $1=name $2=value $3=red_limit $4=minimal_show_limit $5=unit $6=after
    if [[ -n "$2" && "$2" -ge "$4" ]]; then
        printf "%-14s%s" "$1:"
        if (( "$2" > "$3" )); then
            echo -ne "\e[0;91m $2";
        else
            echo -ne "\e[0;92m $2";
        fi
        printf "%-1s%s\x1B[0m" "$5"
        printf "%-11s%s\t" "$6"
        return 1
    fi
}

function get_ip_addresses()
{
    # 函数：获取系统中符合条件的IP地址
    local ips=()
    for f in /sys/class/net/*; do
        local intf=$(basename $f)
        # 匹配以 e、br、lt、umts 开头的接口名称
        if [[ $intf =~ $SHOW_IP_PATTERN ]]; then
            local tmp=$(ip -4 addr show dev $intf | awk '/inet/ {print $2}' | cut -d'/' -f1)
            [[ -n $tmp ]] && ips+=("$tmp")
        fi
    done
    echo "${ips[@]}"
}

function storage_info()
{
    # 函数：获取系统根分区的存储信息
    RootInfo=$(df -h /)
    root_usage=$(awk '/\// {print $(NF-1)}' <<<${RootInfo} | sed 's/%//g')
    root_total=$(awk '/\// {print $(NF-4)}' <<<${RootInfo})
}

# 获取系统CPU核心数并计算关键负载
storage_info
critical_load=$(( 1 + $(grep -c processor /proc/cpuinfo) / 2 ))

# 获取系统运行时间、负载和其他信息
UptimeString=$(uptime | tr -d ',')
time=$(awk -F" " '{print $3" "$4}' <<<"${UptimeString}")
load_percent=$(awk -F"average: " '{print $2}'<<<"${UptimeString}" | awk '{print $1 * 100}')
case ${time} in
    1:*) # 1-2小时
        time=$(awk -F" " '{print $3" 小时"}' <<<"${UptimeString}")
        ;;
    *:*) # 2-24小时
        time=$(awk -F" " '{print $3" 小时"}' <<<"${UptimeString}")
        ;;
    *day) # 天数
        days=$(awk -F" " '{print $3"天"}' <<<"${UptimeString}")
        time=$(awk -F" " '{print $5}' <<<"${UptimeString}")
        time="$days "$(awk -F":" '{print $1"小时 "$2"分钟"}' <<<"${time}")
        ;;
esac

# 获取内存和交换空间使用情况
mem_info=$(LC_ALL=C free -w 2>/dev/null | grep "^Mem" || LC_ALL=C free | grep "^Mem")
memory_usage=$(awk '{printf("%.0f",(($2-($4+$6))/$2) * 100)}' <<<${mem_info})
memory_total=$(awk '{printf("%d",$2/1024)}' <<<${mem_info})
swap_info=$(LC_ALL=C free -m | grep "^Swap")
swap_usage=$( (awk '/Swap/ { printf("%3.0f", $3/$2*100) }' <<<${swap_info} 2>/dev/null || echo 0) | tr -c -d '[:digit:]')
swap_total=$(awk '{print $(2)}' <<<${swap_info})

# 获取CPU温度和频率
THERMAL_PATH="/sys/class/thermal"
CPUFREQ_PATH="/sys/devices/system/cpu/cpufreq"
cpu_freq="$(awk '{printf("%.fMHz", $0 / 1000)}' "$CPUFREQ_PATH/policy0/cpuinfo_cur_freq")"
cpu_temp="$(awk '{printf("%.1f°C", $0 / 1000)}' "$THERMAL_PATH/thermal_zone0/temp")"

# 尝试多次获取IP地址，最多4次，间隔1秒
c=0
while [ ! -n "$(get_ip_addresses)" ]; do
    [ $c -eq 4 ] && break || let c++
    sleep 1
done
ip_address="$(get_ip_addresses)"

# 显示信息
display "系统负载" "${load_percent%% *}" "70" "0" " %" "${load#* }"
printf "运行时间:  \x1B[92m%s\x1B[0m\t\t" "$time"
echo ""

display "内存已用" "$memory_usage" "70" "0" " %" " of ${memory_total}MB"
display "交换内存" "$swap_usage" "0" "0" " %" " of $swap_total""Mb"
printf "IP  地址:  \x1B[92m%s\x1B[0m" "$ip_address"
echo ""

printf "CPU 频率:  \x1B[92m%s\x1B[0m\t\t" "${cpu_freq}"
printf "CPU 温度:  \x1B[92m%s\x1B[0m\t\t" "${cpu_temp}"
echo ""

display "系统存储" "$root_usage" "90" "1" "%" " of $root_total"
if [ -x /sbin/cpuinfo ]; then
    printf "CPU 信息: \x1B[92m%s\x1B[0m\t" "$(echo `/sbin/cpuinfo | cut -d ' ' -f -4`)"
fi
echo ""
echo ""

