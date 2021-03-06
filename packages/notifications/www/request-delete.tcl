
ad_page_contract {

    Remove a notification request

    @author Ben Adida (ben@openforce.net)
    @creation-date 2002-05-24
    @cvs-id $Id: request-delete.tcl,v 1.4.2.2 2016/05/21 10:18:18 gustafn Exp $
} {
    request_id:naturalnum,notnull
    return_url:localurl
}

# Security Check
notification::security::require_admin_request -request_id $request_id

# Actually Delete
notification::request::delete -request_id $request_id

# Redirect
ad_returnredirect $return_url

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
