ad_page_contract {
    Unsubscribes from the site

    @cvs-id $Id: unsubscribe-2.tcl,v 1.4 2018/01/27 16:19:08 gustafn Exp $
} {} -properties {
    system_name:onevalue
}

auth::require_login

set page_title "Account Closed"
set context [list [list [ad_pvt_home] [ad_pvt_home_name]] $page_title]

acs_user::delete -user_id [ad_conn user_id]

set system_name [ad_system_name]
set login_url [ad_get_login_url]

auth::verify_account_status

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
