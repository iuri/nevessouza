ad_page_contract {
    
    Create a Forum

    @author Ben Adida (ben@openforce.net)
    @creation-date 2002-05-25
    @cvs-id $Id: forum-new.tcl,v 1.16 2017/08/07 23:48:11 gustafn Exp $

} -query {
    {name ""}
}

set context [list [_ forums.Create_New_Forum]]

ad_return_template

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
