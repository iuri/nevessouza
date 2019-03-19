ad_proc -public -deprecated lmap {list proc_name} {
    Applies proc_name to each item of the list, appending the result of 
    each call to a new list that is the return value.
} {
    set lmap [list]
    foreach item $list {
        lappend lmap [safe_eval $proc_name $item]
    }
    return $lmap
}
