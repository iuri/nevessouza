# packages/project-manager/lib/project-portlet.tcl
#
# Portlet for short project information
#
# @author Malte Sussdorff (sussdorff@sussdorff.de)
# @creation-date 2005-05-01
# @arch-tag: c502a3ed-d1c0-4217-832a-6ccd86256024
# @cvs-id $Id: project-portlet.tcl,v 1.21 2007/08/02 11:35:19 maltes Exp $

set user_id [auth::require_login]
# Set the link to the permissions page
set permissions_url "[site_node::closest_ancestor_package -package_key subsite]/permissions/one?[export_vars {{object_id $project_item_id}}]"

# URL to close the project
set return_url "rate-project?project_id=$project_id&project_item_id=$project_item_id"
set vars { project_item_id return_url }
set close_url "bulk-close?[export_vars $vars]"
set default_layout_url [parameter::get -parameter DefaultPortletLayoutP]

if {![exists_and_not_null package_id]} {
    set package_id [ad_conn package_id]
}

# Check if contacts is installed
set contacts_package_id [application_link::get_linked -from_package_id $package_id -to_package_key "contacts"]
if {$contacts_package_id ne ""} {
    set contacts_installed_p 1
    set contacts_url [apm_package_url_from_id $contacts_package_id]
} else {
    set contacts_installed_p 0
    set contacts_url ""
}

#URL to rate this project
set rate_url "rate-project?project_id=$project_id&project_item_id=$project_item_id"

# terminology and other parameters
set project_term       [_ project-manager.Project]
set use_goal_p         [parameter::get -parameter "UseGoalP" -default "1"]
set use_project_code_p [parameter::get -parameter "UseUserProjectCodesP" -default "1"]

db_1row project_query { } -column_array project

set richtext_list [list $project(description) $project(mime_type)]
set project(description) [template::util::richtext::get_property html_value $richtext_list]
set project_root [pm::util::get_root_folder]

if {![exists_and_not_null fmt]} {
    set fmt "%x"
}

set project(planned_start_date) [lc_time_fmt $project(planned_start_date) $fmt]
set project(planned_end_date)   [lc_time_fmt $project(planned_end_date) $fmt]
set project(estimated_finish_date) [lc_time_fmt $project(estimated_finish_date) $fmt]
set project(earliest_finish_date) [lc_time_fmt $project(earliest_finish_date) $fmt]
set project(latest_finish_date) [lc_time_fmt $project(latest_finish_date) $fmt]
set edit_url "[ad_conn package_url]add-edit?[export_url_vars project_item_id]"
set variables(customer_id) $project(customer_id)
set project(status_pretty) [pm::project::get_status_description -project_item_id $project_item_id]

if {![empty_string_p contacts_url] && $contacts_installed_p} {
    set project(customer_name) [contact::name -party_id $project(customer_id)]
} else {
    set project(customer_name) ""
}
# ------------------
# Dynamic Attributes
# ------------------

set form_attributes [list]
foreach element [dtype::form::metadata::widgets_list -object_type pm_project -exclude_static_p 1 -dform $project(dform)] {
    lappend form_attributes [lindex $element 3]
}

dtype::get_object -object_id $project_id -object_type pm_project -array dattr -exclude_static -dform project -variables [array get variables]

multirow create dynamic_attributes name value
if {[array exists dattr]} {
    foreach attr [array names dattr] {
	if {[lsearch -exact $form_attributes $attr] > -1} {
	    multirow append dynamic_attributes "[_ acs-translations.pm_project_$attr]" $dattr($attr)
	}
    }
}

# categories

set cat_trees [list]
set cat_list [category::get_mapped_categories $project_id]
foreach cat $cat_list {
    set tree_id [category::get_tree $cat]
    lappend cat_trees [list [category_tree::get_name $tree_id] [category::get_name $cat] $tree_id]
}

multirow create categories tree_id tree_name category_name
foreach cat [lsort -dictionary -index 0 $cat_trees] {
    util_unlist $cat tree_name cat_name tree_id
    multirow append categories $tree_id $tree_name $cat_name
}

set project_links ""
callback pm::project_links -project_id $project_item_id

# Admin Link  

set write_html ""
if {$project(write_p) == "t"} {
    append write_html "
    <a href=\"$edit_url\"><img border=\"0\" src=\"/resources/acs-subsite/Edit16.gif\" alt=\"#acs-kernel.common_Edit#\" /></a>"
}

if {$project(create_p) == "t"} {
    append write_html "<a href=\"$permissions_url\"><img border=\"0\" src=\"/resources/project-manager/padlock.gif\" alt=\"#project-manager.Set_permissions#\" /></a>"
}

