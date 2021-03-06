ad_library {
    assessment -- callback routines
    @author eduardo.perez@uc3m.es
    @creation-date 2005-05-23
    @cvs-id $Id: as-callback-procs.tcl,v 1.9.2.2 2016/07/04 11:35:25 gustafn Exp $
}

ad_proc -public -callback lors::import -impl qti {} {
    this is the lors qti importer
} {
    if {$res_type == "imsqti_xmlv1p0" || $res_type == "imsqti_xmlv1p1" || $res_type =="imsqti_item_xmlv2p0"} {
	return [as::qti::register \
		    -tmp_dir $tmp_dir/$res_href \
		    -community_id $community_id]
    }
}

ad_proc -public -callback imsld::import -impl qti {} {
    this is the imsld qti importer
} {
	if {$res_type == "imsqti_xmlv1p0" || $res_type == "imsqti_xmlv1p1" || $res_type =="imsqti_item_xmlv2p0"} {
            set extension [string tolower [file extension $tmp_dir/$res_href]]
            if {$extension eq ".xml"} {
                return [as::qti::register_xml_object_id \
                            -xml_file $tmp_dir/$res_href \
                            -community_id $community_id \
                            -prop $prop]
            } else {
                return [as::qti::register_object_id \
                            -tmp_dir $tmp_dir/$res_href \
                            -community_id $community_id \
                            -prop $prop]
            }
	}
}


ad_proc -callback merge::MergeShowUserInfo -impl as {
    -user_id:required
} {
    Shows assessments items	
} {
    set msg "Assessment items of user $user_id"
    set result [list $msg]

    lappend result [list "Staff of sessions: [db_list sel_sessions {}] "]
    lappend result [list "Subject of sessions: [db_list sel_sessions2 {*SQL*}] "]

    lappend result [list "Subject of section data id: [db_list sel_sections {}] "]
    lappend result [list "Staff of section data id: [db_list sel_sections2 { *SQL* }] "]

    lappend result [list "Subject of item data id : [db_list sel_items {}] "]
    lappend result [list "Staff of item_data_id: [db_list sel_items2 { *SQL* }] "]
    
    return $result
}

ad_proc -callback merge::MergePackageUser -impl as {
    -from_user_id:required
    -to_user_id:required
} {
    Merge the as's of two users.
    The from_user_id is the user that will be 
    deleted and all the entries of this user 
    will be mapped to the to_user_id.
    
} {
    set msg "Merging assesment"
    set result [list $msg]
    ns_log Notice $msg
    db_transaction {
	db_dml upd_from_sessions {}
	db_dml upd_from_sessions2 { *SQL* }
	db_dml upd_from_sections {}
	db_dml upd_from_sections2 { *SQL* }
	db_dml upd_from_items {}
	db_dml upd_from_items2 { *SQL* }
	
    }
    lappend result "assessment merge is done"
    return $result
}



ad_proc -public -callback imsld::finish_object {
    -object_id:required
    -user_id
    -session_id
} {
    @param object_id  The assessment_id that has been completed by the user
    @param user_id    User identifier
    @param session_id Session identifier
} -

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
