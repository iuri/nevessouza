#/chat/www/unauthorized.tcl
ad_page_contract {
    Display unauthorized message.

    @author David Dao (ddao@arsdigita.com)
    @creation-date November 24, 2000.
    @cvs-id $Id: unauthorized.tcl,v 1.3.14.1 2019/02/14 16:15:01 gustafn Exp $
} -properties {
    context_bar:onevalue
}

set context_bar [list "[_ chat.Unauthorized_privilege]"]

ad_return_template

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
