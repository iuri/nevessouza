ad_library {
  Test cases for the Tcl API of the logger package. The test cases are based 
  on the acs-automated-testing package

  @author Peter Marklund
  @creation-date 31 March 2003
  @cvs-id $Id: logger-test-init.tcl,v 1.9 2004/01/16 02:47:32 vinodk Exp $
}

aa_register_case logger_create_package {
  Test creation and deletion of logger package along with a project,
  a few entries, and other logger data.

  @author Peter Marklund
} {
    aa_run_with_teardown -test_code {
        #####
        #
        # Setup
        #
        #####

        # Test constants
        set package_name "ACS Automated Testing Logger Test Package"
        set project_name "aa_logger_test_project"
        array set hours_var {
            name Time
            unit hours
            type additive
        }
        array set minutes_var {
            name Time
            unit minutes
            type additive
        }
        array set expense_var {
            name Expense 
            unit EUR
            type additive
        }
        set projection_start_time "2003-04-10"
        set projection_end_time "2003-04-20"
        set projection_value "10"
        set projection_name "Test Projection"
        array set hour_entry_1 {
            value 11
            time_stamp "2003-04-15"
            description "I worked on the time logger"
        }
        

        # Create a package
        set package_id [apm_package_instance_new \
                            -package_key logger \
                            -instance_name $package_name]

        # Create a project in that package
        logger::util::set_vars_from_ad_conn {creation_user creation_ip}        
        set project_id [logger::project::insert -name $project_name \
                                                -package_id $package_id \
                                                -creation_user $creation_user \
                                                -creation_ip $creation_ip]

        # Assert that the name of the project can be retrieved
        logger::project::get -project_id $project_id \
                             -array project_array
        aa_equals "Names of projects can be retrieved after creation" $project_array(name) $project_name

        # Assert that the project is mapped to the package and not mapped to any other packages
        set all_projects_list [logger::package::all_projects_in_package -package_id $package_id]
        set only_projects_list [logger::package::projects_only_in_package -package_id $package_id]
        foreach list_var_name {all_projects_list only_projects_list} {
            set list_var_value [set $list_var_name]
            aa_true "Projects can be retrieved for package ($list_var_name)" \
                [expr [llength $list_var_value] == 1 && [string equal [lindex $list_var_value 0] $project_id]]
        }

        # Create and map the hours variable (is probably most common)
        set hours_var_id [logger::variable::new -name $hours_var(name) \
                                                -unit $hours_var(unit) \
                                                -type $hours_var(type)]
        logger::project::map_variable -project_id $project_id \
                                      -variable_id $hours_var_id

        # Create and map the minutes variable
        # (variate by pre-generating the variable id this time)
        set minutes_var_id [logger::variable::new -name $minutes_var(name) \
                                                  -unit $minutes_var(unit) \
                                                  -type $minutes_var(type)]
        logger::project::map_variable -project_id $project_id \
                                      -variable_id $minutes_var_id

        # Create and map the expense variable (euros)
        set expense_var_id [logger::variable::new -name $expense_var(name) \
                                                  -unit $expense_var(unit) \
                                                  -type $expense_var(type)]
        logger::project::map_variable -project_id $project_id \
                                      -variable_id $expense_var_id

        # Assert that variables are retrievable
        logger::variable::get -variable_id $hours_var_id -array hours_var_retr
        logger::variable::get -variable_id $minutes_var_id -array minutes_var_retr
        logger::variable::get -variable_id $expense_var_id -array expense_var_retr
        set expected_var_names [list $hours_var(name) $minutes_var(name) $expense_var(name)]
        set retrieved_var_names [list $hours_var_retr(name) $minutes_var_retr(name) $expense_var_retr(name)]
        aa_true "Names of variables can be retrieved after creation" [util_sets_equal_p $expected_var_names \
                                                                         $retrieved_var_names]

        # Assert that variables are mapped to the project
        set expected_var_list [list $hours_var_id $minutes_var_id $expense_var_id]
        set actual_var_list [logger::project::get_variables -project_id $project_id]
        aa_true "Variables can be retrieved for project" [util_sets_equal_p $expected_var_list \
                                                                                   $actual_var_list]

        # Create a projection
        set projection_id [logger::projection::new -project_id $project_id \
                                                   -variable_id $hours_var_id \
                                                   -start_time $projection_start_time \
                                                   -end_time $projection_end_time \
                                                   -value $projection_value \
                                                   -name $projection_name]

        # Assert that projection values can be retrieved
        logger::projection::get -projection_id $projection_id -array projection
        aa_equals "Projection values can be retrieved after creation" $projection(value) \
                                                                      $projection_value

        # Create mesurements
        set hour_entry_1_id [logger::entry::new -project_id $project_id \
                                                            -variable_id $hours_var_id \
                                                            -value $hour_entry_1(value) \
                                                            -time_stamp $hour_entry_1(time_stamp) \
                                                            -description $hour_entry_1(description)]

        # Check that entries are retrievable
        logger::entry::get -entry_id $hour_entry_1_id -array hour_entry_1_retr
        aa_equals "Value of entries is retrievable" $hour_entry_1_retr(value) \
                                                         $hour_entry_1(value)

        # Add a test category tree
        # TODO when the categories package is stabilized

    }  -teardown_code { 
        #####
        #
        # Teardown
        #
        #####

        # Delete the categories
        # TODO...

        # Delete the package - deletes all logger data related to the package through the before-uninstantiate callback
        apm_package_instance_delete $package_id

        # Check that there is no logger data associated with the deleted package
        # TODO...
    }
}
