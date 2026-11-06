#!/usr/bin/env bash
#
# CPU temperature for waybar's custom/script#temperature module.
#
# Why a script and not waybar's native temperature module: 0.15 can only open a fixed sysfs
# path (hwmon-path / hwmon-path-abs, else /sys/class/thermal/thermal_zoneN/temp), which pins a
# machine to a board. This reads chip *names* from `sensors -j`, so one config follows the same
# dotfiles across AMD (k10temp, zenpower), Intel (coretemp) and boards exposing only acpitz.
#
# Output is waybar's JSON form: {"text": ..., "tooltip": ..., "class": ...}.
# Exits 0 with no output when nothing usable is found -- waybar hides a script module that
# produces empty output, which is preferable to an error every interval.

set -u

# Same three glyphs the native module's format-icons used, and the same critical threshold
# (80) its critical-threshold had.
readonly ICON_COOL=$'\uf76b'
readonly ICON_WARM=$'\uf2c9'
readonly ICON_HOT=$'\uf769'
readonly CRITICAL=80
readonly WARN=40

# First chip that matches wins; preference order, most specific first.
readonly CHIPS=(k10temp zenpower coretemp cpu_thermal acpitz)

# Labels worth preferring inside a chip: the package/whole-die reading rather than a per-core
# or VRM value. Falls back to whatever the chip reports first.
readonly PREFERRED_LABELS='^(Tctl|Tdie|Package id 0|Composite|Tctl\*|Physical id 0)$'

json=$(sensors -j 2>/dev/null) || exit 0
[[ -n $json ]] || exit 0

# One check up front: if lm-sensors ever prints something that is not JSON, bail quietly.
# Without this, every jq below fails once per chip, five error lines per interval.
printf '%s' "$json" | jq -e 'type == "object"' >/dev/null 2>&1 || exit 0

for chip in "${CHIPS[@]}"; do
	read -r temp label < <(printf '%s' "$json" | jq -r --arg c "$chip" --arg pref "$PREFERRED_LABELS" '
		to_entries
		| map(select(.key | startswith($c)))
		| (.[0].value // empty)
		| to_entries
		| map(select(.key != "Adapter"))
		| map({label: .key,
		        v: ([.value | if type == "object" then .[] else . end]
		            | map(select(type == "number"))
		            | .[0])})
		| map(select(.v != null))
		| (map(select(.label | test($pref))) + .)
		| (.[0] // empty)
		| "\(.v)\t\(.label)"
	' 2>/dev/null) || true

	[[ -n ${temp:-} ]] || continue

	# %f parsing is locale-dependent; temperatures always use a dot.
	degrees=$(LC_ALL=C printf '%.0f' "$temp" 2>/dev/null) || continue
	[[ -n $degrees ]] || continue

	if (( degrees >= CRITICAL )); then
		icon=$ICON_HOT
		class='critical'
	elif (( degrees >= WARN )); then
		icon=$ICON_WARM
		class=''
	else
		icon=$ICON_COOL
		class=''
	fi

	jq -cn \
		--arg text "${degrees}°C ${icon}" \
		--arg tooltip "${chip} ${label}: ${degrees}°C" \
		--arg class "$class" \
		'{text: $text, tooltip: $tooltip} + (if $class == "" then {} else {class: $class} end)'
	exit 0
done

# No recognised CPU chip: print nothing and let waybar hide the module.
exit 0
