#!/bin/bash

# Fetch weather data with a 5-second timeout to prevent "hanging"
# Using 'm' for metric. Change to 'u' for US Imperial if needed.
WEATHER=$(curl -sf "wttr.in/?format=%c%t&m" || echo "No Data")

# If curl failed or returned empty, set a fallback
if [ -z "$WEATHER" ] || [ "$WEATHER" == "No Data" ]; then
    TEXT="󰖐 Off"
    TOOLTIP="Weather unavailable"
else
    TEXT="$WEATHER"
    TOOLTIP="Current Weather"
fi

# Output valid JSON
echo "{\"text\": \"$TEXT\", \"tooltip\": \"$TOOLTIP\"}"
