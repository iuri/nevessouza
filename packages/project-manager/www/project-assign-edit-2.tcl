#

ad_page_contract {
    
    Processes the form for assignments and removals
    
    @author Jade Rubick (jader@bread.com)
    @creation-date 2004-06-11
    @arch-tag: acef7904-fdc0-4fd7-9346-b6a1e011f604
    @cvs-id $Id: project-assign-edit-2.tcl,v 1.5 2005/09/15 22:42:41 miguelm Exp $
} {
    project_item_id:integer,notnull
    return_url:notnull
    assignee:multiple
} -properties {
} -validate {
} -errors {
}

set user_id [ad_maybe_redirect_for_registration]

# permissions
permission::require_permission -party_id $user_id -object_id $project_item_id -privilege write

# remove assignments 
set current_assignees [pm::project::assign_remove_everyone \
                           -project_item_id $project_item_id]

foreach ass $assignee {

    regexp {(.*)-(.*)} $ass match party_id role_id

    if {[lsearch $current_assignees $party_id] > -1} {
        set send_email_p f
    } else {
        set send_email_p t
    }

    # We check if the party has read privilege or not over the pm instance, if not we give them
    if { ![permission::permission_p -party_id $party_id -object_id [ad_conn package_id] -privilege read] } {
	permission::grant -party_id $party_id -object_id [ad_conn package_id] -privilege read
    }

    pm::project::assign \
        -project_item_id $project_item_id \
        -party_id $party_id \
        -role_id $role_id \
        -send_email_p $send_email_p

}

ad_returnredirect -message "[_ project-manager.Assignments_saved]" $return_url
