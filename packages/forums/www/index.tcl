ad_page_contract {

    top level list of forums

    @author Ben Adida (ben@openforce.net)
    @creation-date 2002-05-24
    @cvs-id $Id: index.tcl,v 1.13.8.1 2015/09/12 11:06:28 gustafn Exp $

}

set package_id [ad_conn package_id]
set user_id [ad_conn user_id]
set admin_p [permission::permission_p -party_id $user_id -object_id $package_id -privilege admin]
set searchbox_p [parameter::get -parameter ForumsSearchBoxP -package_id $package_id -default 1]

set context {}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
