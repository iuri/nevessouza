ad_page_contract {
    Adding a user by an administrator

    @cvs-id $Id: user-add.tcl,v 1.7 2017/08/07 23:47:45 gustafn Exp $
} -query {
    {referer "/acs-admin/users"}
} -properties {
    context:onevalue
    export_vars:onevalue
}

set context [list [list "." "Users"] "Add user"]

set next_url user-add-2


set subsite_id [ad_conn subsite_id]
set user_new_template [parameter::get -parameter "UserNewTemplate" -package_id $subsite_id]

if {$user_new_template eq ""} {
    set user_new_template "/packages/acs-subsite/lib/user-new"
}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
