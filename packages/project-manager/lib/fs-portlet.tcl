# packages/project-manager/lib/forums-portlet.tcl
#
# 
#
# @author Malte Sussdorff (sussdorff@sussdorff.de)
# @creation-date 2005-05-26
# @arch-tag: 2e370b1e-543b-41ee-9517-f4445927a286
# @cvs-id $Id: fs-portlet.tcl,v 1.3 2005/08/26 20:59:12 miguelm Exp $

foreach required_param {folder_id} {
    if {![info exists $required_param]} {
	return -code error "$required_param is a required parameter."
    }
}

set default_layout_url [parameter::get -parameter DefaultPortletLayoutP]

set package_id [lindex [fs::get_folder_package_and_root $folder_id] 0]
set base_url [apm_package_url_from_id $package_id]
