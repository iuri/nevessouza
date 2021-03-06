ad_library {
    Procedures in the logger::ui namespace. Those
    procedures are used to support the building of the logger
    UI.
    
    @creation-date 21 April 2003
    @author Peter Marklund (peter@collaboraid.biz)
    @cvs-id $Id: ui-procs.tcl,v 1.9 2004/06/03 21:08:24 jader Exp $
}

namespace eval logger::ui {}

ad_proc -public logger::ui::navbar_link_selected_p {
    navbar_url
    param_list
} {
    <p>
      Return 1 if the navbar link with given URL (relative server URL) should be marked
      selected in the UI for the current request and 0 otherwise.
    </p>

    <p>
      A link is considered selected if the current page url starts with the url of the link
      and each HTML parameter in the param_list has the specified value. If the param_list
      is empty then the query string of the request must be empty for the link to be 
      considered selected.
    </p>

    @param navbar_url The url relative page root of the link
    @param param_list A list of URL parameters and their values on the format
                      [list [list param_name1 param_value1] [list param_name2 param_value2]]

    @return 1 if the navbar link should be selected and 0 otherwise

    @author Peter Marklund
} {
    # Let's remove any trailing slash and make it optional in our pattern
    regsub {(.*)/$} $navbar_url {\1} url_no_slash

    # For readability I define the pattern in curly braces which avoids a lot of backslashes
    set selected_pattern {^<url_no_slash>/?(\?[^/]*$|$)}
    regsub {<url_no_slash>} $selected_pattern $url_no_slash selected_pattern

    set page_url [ad_conn url]
    set url_matches_p [regexp $selected_pattern $page_url match]

    set params_match_p 1
    foreach {param_item} $param_list {
        set param_name [lindex $param_item 0]
        set param_value [lindex $param_item 1]

        set actual_param_value [ns_set iget [rp_getform] $param_name]

        if { ![string equal $param_value $actual_param_value] } {
            set params_match_p 0
            break
        }
    }

    if { [llength $param_list] == 0 && ![empty_string_p [ad_conn query]] } {
        # The navbar link has no url parameters but there url parameters in the
        # request. Don't consider the link selected
        set params_match_p 0
    }

    set selected_p [expr $url_matches_p && $params_match_p]

    return $selected_p
}

ad_proc -public logger::ui::variable_options {
    {-project_id:required}
} {
    Return a list suitable to be passed to the form builder
    for the select box of the variables that are mapped to
    a project.

    @param project_id The id of the project to return variable options for
    
    @return A list with variable options on the format 
         [list [list variable_label1 variable_id1] [list variable_label2 variable_value2] ...]
         Returns the empty string if project_id is an empty string.

    @author Peter Marklund
} {
    if { [empty_string_p $project_id] } {
        return {}
    }

    return [db_list_of_lists variable_options {}]
}

ad_proc -public logger::ui::variable_options_all {
} {
    Return a list suitable to be passed to the form builder
    for the select box of all variables that could be mapped to a project.

    @return A list with variable options on the format 
         [list [list variable_label1 variable_id1] [list variable_label2 variable_value2] ...]

    @author Jade Rubick
} {

    return [db_list_of_lists variable_options_all {}]
}

ad_proc -public logger::ui::project_options {} {
    Return a list suitable to be passed to the form builder
    for the select box of the projects mapped to the
    current package instance.

    @return A list with variable options on the format 
         [list [list variable_label1 variable_id1] [list variable_label2 variable_value2] ...]
    
    @author Peter Marklund
} {
    set package_id [ad_conn package_id]
    return [db_list_of_lists project_options {}]
}


ad_proc -public logger::ui::variable_select_widget {
    -project_id:required
    {-current_variable_id ""}
    -select_name:required
} {
    Returns a select widget, suitable for use in a form, that
    contains all the current variables in use for a project
    
    @author Jade Rubick (jader@bread.com)
    @creation-date 2004-05-21
    
    @param project_id

    @param current_variable_id Optionally, the currently selected 
    variable. If left blank, will be set to the default variable_id
    for that project

    @param select_name What the name of the select widget should be

    @return An HTML chunk suitable for display in a form.
    
    @error 
} {

    if {[empty_string_p $current_variable_id]} {
        set current_variable_id [logger::project::get_primary_variable \
                                     -project_id $project_id]
    }

    set variable_options [logger::ui::variable_options \
                              -project_id $project_id]


    set variable_widget "<select name=\"$select_name\">"
    foreach option $variable_options {

        set name [lindex $option 0]
        set id   [lindex $option 1]
        
        if {[string equal $id $current_variable_id]} {
            append variable_widget "<option selected value=\"$id\">$name</option>"
        } else {
            append variable_widget "<option value=\"$id\">$name</option>"
        }
    }
    append variable_widget "</select>"

    return $variable_widget
}
