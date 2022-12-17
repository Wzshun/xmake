#!/bin/sh

target "xmake"
    set_kind "static"
    set_default false

    # add deps
    add_deps "sv" "tbox"
    local libs="lua_cjson lz4"
    for lib in $libs; do
        if has_config "$lib"; then
            add_options "$lib" "{public}"
        else
            add_deps "$lib"
        fi
    done
    if is_config "runtime" "luajit" && has_config "luajit"; then
        add_options "luajit" "{public}"
    elif has_config "lua"; then
        add_options "lua" "{public}"
    else
        add_deps "lua"
    fi

    # add options
    add_options "readline" "curses" "{public}"

    # add defines
    add_defines "__tb_prefix__=\"xmake\""
    if is_mode "debug"; then
        add_defines "__tb_debug__" "{public}"
    fi

    # set the auto-generated config.h
    set_configdir "${buildir}/${plat}/${arch}/${mode}"
    add_configfiles "xmake.config.h.in"

    # add includes directory
    add_includedirs ".." "{public}"
    add_includedirs "${buildir}/${plat}/${arch}/${mode}" "{public}"
    add_includedirs "../xxhash"

    # add the common source files
    add_files "*.c"
    add_files "base64/*.c"
    add_files "bloom_filter/*.c"
    add_files "curses/*.c"
    add_files "fwatcher/*.c"
    add_files "hash/*.c"
    add_files "io/*.c"
    add_files "libc/*.c"
    add_files "lz4/*.c"
    add_files "os/*.c"
    add_files "path/*.c"
    add_files "process/*.c"
    add_files "readline/*.c"
    add_files "sandbox/*.c"
    add_files "semver/*.c"
    add_files "string/*.c"
    add_files "tty/*.c"
    if is_plat "mingw"; then
        add_files "winos/*.c"
    fi

