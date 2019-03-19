ad_page_contract {
    
    Disable a Forum

    @author Ben Adida (ben@openforce.net)
    @creation-date 2002-05-28
    @cvs-id $Id: forum-enable.tcl,v 1.9 2018/01/19 14:20:33 gustafn Exp $

} {
    forum_id:naturalnum,notnull
}

forum::enable -forum_id $forum_id

ad_returnredirect "."
ad_script_abort

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
