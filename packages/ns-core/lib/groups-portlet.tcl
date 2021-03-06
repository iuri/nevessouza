ad_page_contract {}

set admin_p [permission::permission_p -object_id [ad_conn package_id] -privilege admin]


set group_type "application_group"

set package_id [ad_conn package_id]

set user_id [ad_conn user_id]

set groups_html ""


set reg_users_total [llength [group::get_members -group_id -2 ]]


db_foreach groups_select { } {

    set members_total [llength [group::get_members -group_id $group_id ]]

    if {$members_total eq 0} {
	set members_total 0.01
    }


    
    append groups_html "\['$group_name' , $members_total\],"


}

set groups_html [string trimright $groups_html ","]

