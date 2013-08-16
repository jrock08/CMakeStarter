# author jrock08@gmail.com
# Copyright (C) 2013 jrock08@gmail.com
#
# Provides some basic logging for cmake.
macro(set_log_error)
  set(MY_LOG_LEVEL 2)
endmacro(set_log_error)

macro(set_log_warning)
  set(MY_LOG_LEVEL 1)
endmacro(set_log_warning)

macro(set_log_info)
  set(MY_LOG_LEVEL 0)
endmacro(set_log_info)

function(LOGINFO m)
  LOG(1 "Info: ${m}")
endfunction(LOGINFO)

function(LOGWARNING m)
  LOG(2 "Warning: ${m}")
endfunction(LOGWARNING)

function(LOGERROR m)
  LOG(3 "Error: ${m}")
endfunction(LOGERROR)

function(LOGFATAL m)
  message(FATAL_ERROR "Fatal: ${m}")
endfunction(LOGFATAL)

function(LOG val m)
  if(${MY_LOG_LEVEL} LESS ${val})
    message(${m})
  endif(${MY_LOG_LEVEL} LESS ${val})
endfunction(LOG)

set_log_warning()

message("log level: ${MY_LOG_LEVEL}")
