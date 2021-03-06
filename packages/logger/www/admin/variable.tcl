ad_page_contract {
    Add/edit/display a variable.
    
    @author Peter marklund (peter@collaboraid.biz)
    @creation-date 2003-04-15
    @cvs-id $Id: variable.tcl,v 1.7 2004/01/04 17:24:38 lars Exp $
} {
    variable_id:optional
    project_id:optional
}

set package_id [ad_conn package_id]

if { [string equal [form get_action variable_form] "done"] } {
    # User is done editing - redirect back to index page
    ad_returnredirect .
    ad_script_abort
}

if { [exists_and_not_null variable_id] } {
    # Initial request in display or edit mode or a submit of the form
    set page_title "One variable"
    set ad_form_mode display
} else {
    # Initial request in add mode
    set page_title "Add a variable"
    set ad_form_mode edit
}

set context [list $page_title]

set actions_list [list [list Edit "edit"] [list Done done]]
ad_form -name variable_form -cancel_url index -export { project_id } -mode $ad_form_mode -actions $actions_list -form {
    variable_id:key(acs_object_id_seq)

    {name:text
        {html {size 50}}
        {label "Name"}
    }

    {unit:text
        {html {size 50}}
        {label "Unit"}
    }

    {type:text(radio)
        {options {{Additive additive} {Non-Additive non-additive}}}
        {label "Type"}
    }

} -select_query_name select_variable -validate {
    {
        name
        { ![empty_string_p [string trim $name]] }
        { A name with only spaces is not allowed }
    }

} -new_data {
    set variable_id [logger::variable::new \
                         -variable_id $variable_id \
                         -name $name \
                         -unit $unit \
                         -type $type]

    if { [exists_and_not_null project_id] } {
        logger::project::map_variable \
            -project_id $project_id \
            -variable_id $variable_id
        ad_returnredirect [export_vars -base project { project_id }]
        ad_script_abort
    }
} -edit_data {
    logger::variable::edit \
        -variable_id $variable_id \
        -name $name \
        -unit $unit \
        -type $type              
} -after_submit {
    ad_returnredirect "[ad_conn url]?variable_id=$variable_id"
    ad_script_abort
}
