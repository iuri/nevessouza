ad_page_contract {

    @author yon@openforce.net
    @author rob@thaum.net
    @creation-date 2002-07-01
    @cvs-id $Id: search.tcl,v 1.15 2017/08/07 23:48:11 gustafn Exp $

} -query {
    {forum_id:integer ""}
}

set page_title [_ forums.Search_Forums]
set context [list $page_title]

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
