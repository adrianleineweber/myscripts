#!/bin/bash

#################
# BASIC LOGGER #
#################

logtofile=1

_loggerLogHostname=false
if $_loggerLogHostname;
  then
    _loggerHostname=$(hostname -f)
fi

_loggerLogBasename=false
if $_loggerLogBasename;
  then
    _loggerBasename=$(basename $0)
fi

exec 3>&2 # logging stream (file descriptor 3) defaults to STDERR
verbosity=2 # default to show warnings
loglevel_silent=0
loglevel_error=1
loglevel_warn=2
loglevel_info=3
loglevel_debug=4

bold=`tput bold`
normal=`tput sgr0`
#date "+%F %T.%3N"

log_notify() { logger $loglevel_silent "$_loggerBasename $_loggerHostname ${bold}NOTIFY:${normal} $1 ($LINENO)"; } 
log_error() { logger $loglevel_error "$_loggerBasename $_loggerHostname ${bold}ERROR:${normal} $1 ($LINENO)"; }
log_warn() { logger $loglevel_warn "$_loggerBasename  $_loggerHostname ${bold}WARNING:${normal} $1 ($LINENO)"; }
log_info() { logger $loglevel_info "$_loggerBasename $_loggerHostname ${bold}INFO:${normal} $1 ($LINENO)"; }
log_debug() { logger $loglevel_debug "$_loggerBasename $_loggerHostname ${bold}DEBUG:${normal} $1 ($LINENO)"; }

logger() {
case "$1" in
        $loglevel_error)
        echo -ne "\e[0;31m";; #RED
        $loglevel_warn)
        echo -ne "\e[1;33m";; #YELLOW
        $loglevel_info)
        echo -ne "\e[1;32m";; #GREEN
        $loglevel_debug)
        echo -ne "\e[0;35m";; #RED
esac

    if [ $verbosity -ge $1 ]; then
        # Expand escaped characters, wrap at 100 chars, indent wrapped lines
        echo -ne "$2" | fold -w100 -s | sed '2~1s/^/  /' >&3
    fi
echo -e "\e[00m"
}


#EXAMPLES
log_notify "notify message"
log_error "error message"
log_warn "warning message"
log_info "info message"
#log_debug "debug message"
#log_notify "noch eine notify message"
#log_debug "noch ein debug"
#log_notify "wieder notify"
