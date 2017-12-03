
#--------------------------------------------------------------------#
# Widget Helpers                                                     #
#--------------------------------------------------------------------#

_zsh_autosuggest_incr_bind_count() {
	if ((${+_ZSH_AUTOSUGGEST_BIND_COUNTS[$1]})); then
		((_ZSH_AUTOSUGGEST_BIND_COUNTS[$1]++))
	else
		_ZSH_AUTOSUGGEST_BIND_COUNTS[$1]=1
	fi

	bind_count=$_ZSH_AUTOSUGGEST_BIND_COUNTS[$1]
}

_zsh_autosuggest_get_bind_count() {
	if ((${+_ZSH_AUTOSUGGEST_BIND_COUNTS[$1]})); then
		bind_count=$_ZSH_AUTOSUGGEST_BIND_COUNTS[$1]
	else
		bind_count=0
	fi
}

# Bind a single widget to an autosuggest widget, saving a reference to the original widget
_zsh_autosuggest_bind_widget() {
	typeset -gA _ZSH_AUTOSUGGEST_BIND_COUNTS

	local widget=$1
	local autosuggest_action=$2
	local prefix=$ZSH_AUTOSUGGEST_ORIGINAL_WIDGET_PREFIX

	local -i bind_count

	# Save a reference to the original widget
	case $widgets[$widget] in
		# Already bound
		user:_zsh_autosuggest_(bound|orig)_*);;

		# User-defined widget
		user:*)
			_zsh_autosuggest_incr_bind_count $widget
			zle -N $prefix${bind_count}-$widget ${widgets[$widget]#*:}
			;;

		# Built-in widget
		builtin)
			_zsh_autosuggest_incr_bind_count $widget
			eval "_zsh_autosuggest_orig_${(q)widget}() { zle .${(q)widget} }"
			zle -N $prefix${bind_count}-$widget _zsh_autosuggest_orig_$widget
			;;

		# Completion widget
		completion:*)
			_zsh_autosuggest_incr_bind_count $widget
			eval "zle -C $prefix${bind_count}-${(q)widget} ${${(s.:.)widgets[$widget]}[2,3]}"
			;;
	esac

	_zsh_autosuggest_get_bind_count $widget

	# Pass the original widget's name explicitly into the autosuggest
	# function. Use this passed in widget name to call the original
	# widget instead of relying on the $WIDGET variable being set
	# correctly. $WIDGET cannot be trusted because other plugins call
	# zle without the `-w` flag (e.g. `zle self-insert` instead of
	# `zle self-insert -w`).
	eval "_zsh_autosuggest_bound_${bind_count}_${(q)widget}() {
		_zsh_autosuggest_widget_$autosuggest_action $prefix$bind_count-${(q)widget} \$@
	}"

	# Create the bound widget
	zle -N $widget _zsh_autosuggest_bound_${bind_count}_$widget
}

# Map all configured widgets to the right autosuggest widgets
_zsh_autosuggest_bind_widgets() {
	local widget
	local ignore_widgets

	ignore_widgets=(
		.\*
		_\*
		zle-\*
		autosuggest-\*
		$ZSH_AUTOSUGGEST_ORIGINAL_WIDGET_PREFIX\*
		$ZSH_AUTOSUGGEST_IGNORE_WIDGETS
	)

	# Find every widget we might want to bind and bind it appropriately
	for widget in ${${(f)"$(builtin zle -la)"}:#${(j:|:)~ignore_widgets}}; do
		if [ ${ZSH_AUTOSUGGEST_CLEAR_WIDGETS[(r)$widget]} ]; then
			_zsh_autosuggest_bind_widget $widget clear
		elif [ ${ZSH_AUTOSUGGEST_ACCEPT_WIDGETS[(r)$widget]} ]; then
			_zsh_autosuggest_bind_widget $widget accept
		elif [ ${ZSH_AUTOSUGGEST_EXECUTE_WIDGETS[(r)$widget]} ]; then
			_zsh_autosuggest_bind_widget $widget execute
		elif [ ${ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS[(r)$widget]} ]; then
			_zsh_autosuggest_bind_widget $widget partial_accept
		else
			# Assume any unspecified widget might modify the buffer
			_zsh_autosuggest_bind_widget $widget modify
		fi
	done
}

# Given the name of an original widget and args, invoke it, if it exists
_zsh_autosuggest_invoke_original_widget() {
	# Do nothing unless called with at least one arg
	[ $# -gt 0 ] || return

	local original_widget_name="$1"

	shift

	if [ $widgets[$original_widget_name] ]; then
		zle $original_widget_name -- $@
	fi
}
