# 

ad_page_contract {
    
    Sends out a process status update
    
    @author  (jader-ibr@bread.com)
    @creation-date 2004-11-18
    @arch-tag: 1a2152ed-1746-4d03-b191-b00c3fb32731
    @cvs-id $Id: process-reminder.tcl,v 1.3 2005/05/26 09:34:29 maltes Exp $
} {
    instance_id:integer,notnull
    project_item_id:integer,notnull
    return_url:notnull
} -properties {
} -validate {
} -errors {
}

pm::process::email_alert \
    -process_instance_id $instance_id \
    -project_item_id $project_item_id \
    -new_p f

ad_returnredirect -message "[_ project-manager.Status_update_sent]" $return_url
