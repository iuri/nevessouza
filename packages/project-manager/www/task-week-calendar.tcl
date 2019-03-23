ad_page_contract {
    @author Anny Flores (annyflores@viaro.net) Viaro Networks (www.viaro.net)
} {
    {date ""}
    {display_p "d"}
}


set date [clock format [clock scan $date] -format "%Y-%m-%d"]
set selected_users [pm::calendar::users_to_view]

set package_id [ad_conn package_id]
set instance_clause "and o.package_id=:package_id"
set users_clause "and pa.project_id in (select  p.item_id
          from pm_projectsx p 
          where 
          p.item_id = pa.project_id 
          and p.object_package_id = :package_id)"


set return_url [ad_return_url]\#top

set edit_hidden_vars [export_vars -form {return_url {new_tasks "0"}}]

if {[empty_string_p $date]} {
    # Default to todays date in the users (the connection) timezone
    set server_now_time [dt_systime]
    set user_now_time [lc_time_system_to_conn $server_now_time]
    set date [lc_time_fmt $user_now_time "%x"]
}

set user_id [ad_conn user_id]
set base_url [apm_package_url_from_id $package_id]
set start_date $date

# Convert date from user timezone to system timezone
#set system_start_date [lc_time_conn_to_system "$date 00:00:00"]

set first_day_of_week [lc_get firstdayofweek]
set first_us_weekday [lindex [lc_get -locale en_US day] $first_day_of_week]
set last_us_weekday [lindex [lc_get -locale en_US day] [expr [expr $first_day_of_week + 6] % 7]]

db_1row select_weekday_info {}
db_1row select_week_info {}

set current_weekday 0

#s/item_id/url
multirow create items \
    item_id \
    users_list \
    event_name \
    event_url \
    status_summary \
    start_date \
    day_of_week \
    start_date_weekday \
    start_time \
    end_time \
    no_time_p \
    add_url \
    day_url

# Convert date from user timezone to system timezone
set first_weekday_of_the_week_tz [lc_time_conn_to_system "$first_weekday_of_the_week 00:00:00"]
set last_weekday_of_the_week_tz [lc_time_conn_to_system "$last_weekday_of_the_week 00:00:00"]


set order_by_clause "order by to_char(t.end_date, 'J'),to_char(t.end_date,'HH24:MI')"
set interval_limitation_clause [db_map week_interval_limitation]
set additional_select_clause ",(to_date(t.end_date,'YYYY-MM-DD HH24:MI:SS')  - to_date(:first_weekday_of_the_week_tz,'YYYY-MM-DD HH24:MI:SS')) as day_of_week"
set items_query "select_items"
set selected_users [pm::calendar::users_to_view]
set selected_users_clause " and ts.task_id in (select task_id from pm_task_assignment where party_id in ([join $selected_users ", "]))"


if { [string eq $display_p l] } {
    set order_by_clause "order by to_char(t.latest_finish, 'J'),to_char(t.latest_finish,'HH24:MI')"
    set interval_limitation_clause [db_map week_interval_limitation]
    set additional_select_clause ",(to_date(t.latest_finish,'YYYY-MM-DD HH24:MI:SS')  - to_date(:first_weekday_of_the_week_tz,'YYYY-MM-DD HH24:MI:SS')) as day_of_week"
    set items_query "select_items_by_latest_finish"
}


db_foreach  $items_query {} {
    set base_url "[apm_package_url_from_id $instance_id]"
    set item_template "${base_url}task-one?task_id=\$item_id"
    
    # Convert from system timezone to user timezone
    set ansi_start_date [lc_time_system_to_conn $ansi_start_date]
    set ansi_end_date [lc_time_system_to_conn $ansi_end_date]
    set start_date_weekday [lc_time_fmt $ansi_start_date "%A"]
    set start_date [lc_time_fmt $ansi_start_date "%x"]
    set end_date [lc_time_fmt $ansi_end_date "%x"]
    
    set start_time [lc_time_fmt $ansi_start_date "%X"]
    set end_time [lc_time_fmt $ansi_end_date "%X"]
    
    # need to add dummy entries to show all days
    for {  } { $current_weekday < $day_of_week } { incr current_weekday } {
        set ansi_this_date [dt_julian_to_ansi [expr $first_weekday_julian + $current_weekday]]
        multirow append items \
            0 \
            "" \
            "" \
            "" \
            "" \
            [lc_time_fmt $ansi_this_date "%x"] \
            ${current_weekday} \
            [lc_time_fmt $ansi_this_date %A] \
            "" \
            "" \
            "" 
    }
    
    set ansi_this_date [dt_julian_to_ansi [expr $first_weekday_julian + $current_weekday]]
    if {[string equal $start_time "12:00 AM"] && [string equal $end_time "12:00 AM"]} {
        set no_time_p t
    } else {
        set no_time_p f
    }
    
    set users_list "<table>"
    foreach user $selected_users {
	if {[db_string users {} -default 0]} {
	    db_1row name {select p.first_names || ' ' || p.last_name  as full_name from persons p where person_id=:user}
	    if { $user == $user_id } {
		append users_list "<tr><td><span class=selected><small>$full_name</small></span></td></tr>"
	    } else {
		append users_list "<tr><td><small>$full_name</span></td></tr>"
	    }
	}
    }
    append users_list "</table>"
    multirow append items \
	$task_item_id \
	$users_list \
        "$name" \
        [subst $item_template] \
        $status_summary \
        $start_date \
        $day_of_week \
        ${start_date_weekday} \
        $start_time \
        $end_time \
        $no_time_p 
    
    set current_weekday $day_of_week
}

if {$current_weekday < 7} {
    # need to add dummy entries to show all hours
    for {  } { $current_weekday < 7 } { incr current_weekday } {
	set ansi_this_date [dt_julian_to_ansi [expr $first_weekday_julian + $current_weekday]]
	multirow append items \
            0 \
            "" \
            "" \
            "" \
            "" \
            [lc_time_fmt $ansi_this_date "%x"] \
            $current_weekday \
            [lc_time_fmt $ansi_this_date %A] \
            "" \
            "" \
            "" 
    }
}

# Navigation Bar
set dates "[lc_time_fmt $first_weekday_date "%q"] - [lc_time_fmt $last_weekday_date "%q"]"
set previous_week_url "?view=week&date=[ad_urlencode [dt_julian_to_ansi [expr $first_weekday_julian - 7]]]&display_p=$display_p\#top"
set next_week_url "?view=week&date=[ad_urlencode [dt_julian_to_ansi [expr $first_weekday_julian + 7]]]&display_p=$display_p\#top"




# -------------------------------------
# make a list of users in this subsite.
# -------------------------------------

set users_to_view [pm::calendar::users_to_view]

db_multirow -extend {checked_p} users assignees {} {
    if {[lsearch $users_to_view $party_id] == -1} {
        set checked_p f
    } else {
        set checked_p t
    }
}
