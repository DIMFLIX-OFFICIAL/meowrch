#!/bin/bash

# Функция для определения доступного устройства управления яркостью
get_backlight_device() {
    local devices=$(ls /sys/class/backlight/)
    if [ -z "$devices" ]; then
        echo "none"
    else
        local name_device=$(echo $devices | awk '{print $1}') 
        local status=$(cat /sys/class/backlight/$name_device/device/enabled)

        # Проверка на включение данного устройства
        if [[ "$status" == "disabled" ]]; then
            echo "none"
        else
            echo $name_device
        fi
    fi # Добавлено закрытие условия if
}

# Функция для получения текущей яркости
get_brightness() {
    brightnessctl -d "$1" | grep -o "(.*" | tr -d "()"
}

BRIGHTNESS_DEVICE=$(get_backlight_device)
# BRIGHTNESS_ICON='%{F#61afef} %{F-}'

brightness_icon() {
	local value=$1
    local color="%{F#61afef}"
    case $value in
        9[0-9]%) icon="" ;;
        8[0-9]%) icon="" ;;
        7[0-9]%) icon="" ;;
        6[0-9]%) icon="" ;;
        5[1-9]%) icon="" ;;
        4[0-9]%) icon="" ;;
        3[0-9]%) icon="" ;;
        2[0-9]%) icon="" ;;
        1[0-9]%) icon="" ;;
        [1-9]%) icon=" " ;;
        100%) icon="";;
        50%) icon="";;
        0%) icon=" " ;;  
        *) icon=" " ;;
    esac 

    echo -n "${color}${icon}%{F-}"
}

if [ "$BRIGHTNESS_DEVICE" = "none" ]; then
    exit 1
fi

BRIGHTNESS_VALUE=$(get_brightness "$BRIGHTNESS_DEVICE")

case "$1" in
    up)
        brightnessctl -d "$BRIGHTNESS_DEVICE" set +5%
        ;;
    down)
        brightnessctl -d "$BRIGHTNESS_DEVICE" set 5%-
        ;;
    max)
        brightnessctl -d "$BRIGHTNESS_DEVICE" set 100%
        ;;
    min)
        brightnessctl -d "$BRIGHTNESS_DEVICE" set 1%
        ;;
    status)
        #echo "$BRIGHTNESS_ICON $BRIGHTNESS_VALUE"
		echo "$(brightness_icon $BRIGHTNESS_VALUE)"
        ;;
    *)
        echo "Invalid argument. Use 'up', 'down', 'max', 'min', or 'status'."
        ;;
esac
