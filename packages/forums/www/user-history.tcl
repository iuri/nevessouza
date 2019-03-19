ad_page_contract {
    
    Posting History for a User

    @author Ben Adida (ben@openforce.net)
    @creation-date 2002-05-29
    @cvs-id $Id: user-history.tcl,v 1.16 2018/06/28 08:26:35 antoniop Exp $

} {
    user_id:naturalnum,notnull
    {view:word "date"}
    {groupby "forum_name"}
} -validate {
    valid_user -requires user_id {
        if {$user_id == 0 || ![person::person_p -party_id $user_id]} {
            ad_complain "Invalid user_id"
        }
    }
}

# Get user name
set user_name [person::name -person_id $user_id]

set context [list [_ forums.Posting_History]]

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
