_abbrFile="$XDG_DATA_HOME/zsh/abbr"

# check if the last word is in command and replace it
abbr_expand() {
	local words=(${(z)LBUFFER})
	local lastWord=$words[-1]
	local secondLastWord=${words[-2]}
	local -i word_count=${#words}
	local match=$(grep "^$lastWord=" "$_abbrFile" | cut -f 2- -d '=')

	[ -n "$match" ] || { abbr_space; return }

	if [ "$word_count" = 1 ]; then
		LBUFFER="$match "
	elif [ -n "$secondLastWord" ]; then
		# todo: ( - is in same word
		[ "${secondLastWord%[|&;]}" ] && return
		words[-1]="$match"
		LBUFFER="$words "
	fi

}

# expand and run command
abbr_enter() {
	abbr_expand
	zle accept-line
}

# appand space to LBUFFER
abbr_space() {
	LBUFFER="$LBUFFER "
}

# todo: fix keybinding
# run command without expanding
# abbr_enter_do_nothing() {
# 	zle accept-line
# }

zle -N abbr_expand
zle -N abbr_space
zle -N abbr_enter
# zle -N abbr_enter_do_nothing

bindkey ' ' abbr_expand
bindkey '^ ' abbr_space
bindkey '^M' abbr_enter
# bindkey '^[M' abbr_enter_do_nothing
