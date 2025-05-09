#!/bin/bash

echo
echo "--------------------------"
echo "Audio Configuration Script"
echo "--------------------------"
echo

# Wait briefly to ensure audio services are initialized
sleep 1

# STEP 1: SINK SELECTION
echo "🔍 Available audio sinks:"
pactl list short sinks | awk '{print " [" NR "] " $2 }'
echo

read -p "Enter the number of the sink you want to use as default output: " CHOICE

# Validate user input
TOTAL=$(pactl list short sinks | wc -l)
if ! [[ "$CHOICE" =~ ^[0-9]+$ ]] || [ "$CHOICE" -lt 1 ] || [ "$CHOICE" -gt "$TOTAL" ]; then
    echo "❌ Invalid selection. Exiting."
    exit 1
fi

# Get selected sink name
TARGET_SINK=$(pactl list short sinks | awk -v sel="$CHOICE" 'NR==sel {print $2}')
echo "✓ Selected sink: $TARGET_SINK"

# STEP 2: Set default sink
echo
echo "🔧 Setting selected sink as system default..."
pactl set-default-sink "$TARGET_SINK"

# STEP 3: Move active streams
echo
echo "🔁 Redirecting active audio streams to the selected sink..."
for stream in $(pactl list short sink-inputs | awk '{print $1}'); do
    pactl move-sink-input "$stream" "$TARGET_SINK"
done

# STEP 4: Save PulseAudio default
echo
echo "💾 Saving sink as persistent default in ~/.config/pulse/default.pa..."
mkdir -p ~/.config/pulse
DEFAULT_PA=~/.config/pulse/default.pa
if ! grep -q "$TARGET_SINK" "$DEFAULT_PA" 2>/dev/null; then
    echo "set-default-sink $TARGET_SINK" >> "$DEFAULT_PA"
    echo "✓ Sink persistence added."
else
    echo "ℹ️ Sink persistence already exists."
fi

# STEP 5: Playback test
echo
echo "🔊 Playing test sound through the selected sink..."
paplay --device="$TARGET_SINK" /usr/share/sounds/freedesktop/stereo/bell.oga

# STEP 6: Final status
echo
echo "📋 Final status:"
echo "Default sink:"
pactl get-default-sink
echo
echo "Active streams:"
pactl list sink-inputs | grep -E "application.name|Sink|Mute|Volume" --color

# STEP 7: Save ALSA volume (optional)
echo
read -p "💾 Do you want to save the current ALSA volume levels to be restored on every boot? [Y/N] " save_alsa

if [[ "$save_alsa" =~ ^[Yy]$ ]]; then
    echo "✓ Saving ALSA mixer state..."
    sudo alsactl store
    echo "✓ Volume levels saved. They will be restored automatically on future boots."
else
    echo "ℹ️ ALSA volume levels were not saved. They will reset unless saved manually later."
fi

echo
echo "✅ Audio configuration complete!"
