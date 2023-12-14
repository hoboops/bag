function infobar --description="Shows various information in one line and updates periodically"
    set external_ip $(curl -s -4 icanhazip.com)
    
    while true
        # reference https://unix.stackexchange.com/questions/119126/command-to-display-memory-usage-disk-usage-and-cpu-load        
        set memory_usage $(free -m | awk 'NR==2{printf "%s/%sMB (%.2d%%)\n", $3,$2,$3*100/$2 }')
        set disk_usage $(df -h | awk '$NF=="/"{printf "%d/%dGB (%s)\n", $3,$2,$5}')
        set cpu_load $(top -bn1 | grep load | awk '{printf "%.2d%\n", $(NF-2)}')

        printf "\r" # set cursor to start

        set_color normal;       echo -n " $(whoami)"
        set_color -o yellow;    echo -n "@"
        set_color normal;       echo -n "$(hostname)"    
        set_color grey;         echo -n " |"

        if test ! -z "$external_ip"
            set_color -o yellow;    echo -n " IP"
            set_color normal;       echo -n " $external_ip"
            set_color grey;         echo -n " |"
        end

        set_color -o yellow;    echo -n " MEM"
        set_color normal;       echo -n " $memory_usage"
        set_color grey;         echo -n " |"

        set_color -o yellow;    echo -n " DISK"
        set_color normal;       echo -n " $disk_usage"
        set_color grey;         echo -n " |"

        set_color -o yellow;    echo -n " CPU"
        set_color normal;       echo -n " $cpu_load"
        set_color grey;         echo -n " |"

        set_color -o yellow;    echo -n " $(date +%d.%m.%y)"
        set_color normal;       echo -n " $(date +%H:%M:%S)"

        sleep 1
    end
end
