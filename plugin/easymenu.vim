if exists('easymenu_vim') || !has('menu')
    finish
endif
let easymenu_vim = 1


function! g:LoadMenu( menu )
    call s:LoadSubMenu( a:menu, '', '', '' )
endfunction
"TODO - I failed to get this to work, so the function is global.
"       The error says: 'E714: List required'
"command! -nargs=1 LoadMenu :call <SID>LoadMenu(<q-args>)


function! s:Escape( name )
    let escaped = substitute( a:name, ' ', '\\ ', 'g' )
    let escaped = substitute( escaped, '\t', '\\\t', 'g' )
    let escaped = substitute( escaped, '\.', '\\.', 'g' )
    return escaped
endfunction


function! s:LoadSubMenu( menu, key, priority, able )

    let itemlist = a:menu
    for Item in itemlist

        " escaped, fully-qualified name
        let name = a:key.s:Escape( Item['text'] )
        " mode
        if( has_key( Item, 'mode' ) )
            let mode = Item['mode']
        else
            let mode = 'a' " default to all
        endif
        " priority
        if( has_key( Item, 'priority' ) )
            if( !empty( a:priority ) )
                let priority = a:priority.'.'.Item['priority']
            else
                let priority = Item['priority']
            endif
        else
            let priority = a:priority.'.0'
        endif
        " enable/disable determination
        if( has_key( Item, 'able' ) )
            let able = Item['able']
        else
            let able = a:able
        endif
        " command
        if( has_key( Item, 'command' ) )
            let command = Item['command']
        else
            let command = ''
        endif

        if( has_key( Item, 'children' ) )
            " has children
            call s:LoadSubMenu( Item['children'], name.'.', priority, able )
        else
            " no children (leaf node)
            execute mode.'menu <silent> '.priority.' '.name.' '.command.'<CR>'
            if( !empty( able ) )
                execute mode.'menu <silent> '.priority.' '.able.' '.name
            endif
        endif

    endfor
endfunction

