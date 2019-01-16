ad_library {

    ns-core package API

    @author Iuri Sampaio (iuri.sampaio@iurix.com)
    @creation-date 2018-12-25
}


namespace eval ns_core {}
namespace eval ns_core::email {}
namespace eval ns_core::user {}

ad_proc -public ns_core::email::add_weights {
    {-email_id:required}
} {

    It saves weights from emails

    @param email_id
} {

    ns_log Notice "Running ns_core::email::add_weights | EMAILID $email_id"
    
    db_1row select_bodies {
	select bodies from iurix_mails WHERE mail_id = :email_id
    } 
    
    ns_log Notice "BODIES $bodies"
    
    set mime_type [lindex [lindex $bodies 0] 0]
    set body [lindex [lindex $bodies 0] 1]
    
    # ns_log Notice "MIME $mime_type"
    # ns_log Notice "$body"
    
    set lines [split $body \n]
    
    set tree_id [category_tree::get_id "Criteria" "en_US"]
    set categories [category_tree::get_categories -tree_id $tree_id]
    ns_log Notice "TREEID $tree_id | CATEGORIES $categories"
    
    # Critérios de distribuiçao:
    # Quantidade - Complexidade - Competencia - Urgencia
    # Pesos :
    # 1 = 5 pontos; 2 = 15 pontos; 3 = 50 pontos; 4 = 100 pontos; 5 = 200 pontos
    # maximo de pontos por dia: 100
    
    # Contradicao:  5 = 200 enquanto o max diario é 100
    
    # qual a referencia de decisao?
    ##  Selecionar o usuario com menos pontos no dia e enviar o email?
    ## Se todos ultrapassam 100 pontos no dia?
    ### deve-se aguardar o proximo dia?

    for {set i 0} {$i < 4} {incr i} {
	
	set weight [lindex $lines $i]
	
	if {! [ regexp {^([1-5])$} $weight] }  {

	    ns_log Notice "ERROR: Wrong format within email's body. Weight is not within the interval 1-5!"
	    return
	}
    }

    
    
    set total 0
    for {set i 0} {$i < 4} {incr i} {
	
	set weight [lindex $lines $i]
	
	set points [db_string get_desc {
	    SELECT description FROM category_translations WHERE name = :weight AND locale = 'en_US'
	} -default ""]    
	
	ns_log Notice "WEIGHT $weight | POINTS $points"
	
	append weights "${weight},"
	
	set total [expr $total + $points]
	
    }
    
    set weights [string trimright $weights ","]
    
    
    
    
    
    if {![db_0or1row exists_mail_p {
	SELECT id FROM ns_mail_weights WHERE mail_id = :email_id
    }] } {
	
	ns_log Notice "INSETRT MAIL WEIGHTS"
	
	set id [db_nextval ns_mail_weights_seq]
	
	ns_log Notice "ID $id | MAILID $email_id | WEIGHTS $weights | TOTAL $total"
	
	# To save mail weights for tracking purposes 
	db_transaction {
	    
	    db_dml insert_weights {
		INSERT INTO ns_mail_weights(id, mail_id, weights) VALUES (:id, :email_id, :weights)
	    }   
	}
	
    } else {
	ns_log Notice "MAIL EXISTS"
    }
    
    
    
    
    
}






ad_proc -public ns_core::user::get_target_lawyer {} {

    Returns user_id, which has minum score

} {

    set group_id [group::get_id -group_name "Adv Junior"]
    set lawyers "[group::get_members -group_id $group_id]"

    ns_log Notice "ID $group_id | MEMBERS $lawyers"
    set group_id [group::get_id -group_name "Adv Senior"]

    set lawyers "$lawyers [group::get_members -group_id $group_id]"

    ns_log Notice "ID $group_id | MEMBERS $lawyers"

        
    
    # Get the user with minimum score
    set scored_lawyers [db_list select_user {
	SELECT DISTINCT user_id
	FROM ns_user_score
	WHERE NOW() > creation_date::timestamptz
	AND NOW() - creation_date::timestamptz <= interval '24 hours' 
	
    }]
    
    ns_log Notice "TODAY SCORED LAWYERS $scored_lawyers"
    
    # IF scored_lawyers == 0 THEN select random from members
    # ELSE
    ## IF scored_lawyers > 0 then
    ### IF scored_lawyers == lawyers THEN select the lawyers with minimum score
    ### ELSE get lawyers (not in scored) and select random (scored_lawyers never have more than lawyers) 
    
    ns_log Notice "SCOREDLAWYERS $scored_lawyers | LAWYERS $lawyers"
	    
    if {$scored_lawyers eq 0} {
	#do nothing
	set target_lawyer [lindex $lawyers 0]
	
    } else {


	if {[llength $scored_lawyers] > [llength $lawyers]} {
	    ns_log Notice "SCOREDLAWYERS $scored_lawyers >  LAWYERS $lawyers"
	    
	    ns_log Notice "DEAD END! :(  GROUP LAWEYRS has no members"
	    
	} else  {
	    
	    ns_log Notice "SCOREDLAWYERS $scored_lawyers > 0"
	    
	    
	    if {[llength $scored_lawyers] eq [llength $lawyers]} {
		set lawyers [join $lawyers ", "]
		
		# what if there are 2 or more lawyers with the same score?
		# set target_lawyer [db_string select_min_score "
		#    SELECT user_id FROM ns_user_score WHERE score = (SELECT MIN(score) FROM ns_user_score WHERE user_id IN ($lawyers))
		# "]
		set target_lawyer [db_string select_min_score "
		    SELECT user_id FROM ns_user_score ORDER BY score LIMIT 1
		"]
		
	    } else {
		foreach elem $lawyers {
		    # if any lawyer is not in scored then add it to 
		    if {[lsearch -inline $scored_lawyers $elem] eq ""} {
			set target_lawyer $elem	
		    }
		}       
	    }
	}
    }

    
    return $target_lawyer
}






ad_proc -public ns_core::calendar::new {
    {-user_id}
} {
    It creates a new calendar to the user_id passed as parameter. Returns calendar_id

} {

    ns_log Notice "############ USERID $user_id"
    #set auto_login [im_generate_auto_login -user_id $user_id]
    # Verify and Create and new calendar
    set package_id [db_string select_package_id {
	SELECT min(package_id)
	from apm_packages
	where instance_name = 'Agenda' AND package_key = 'calendar'
    } -default 0]
    
    ns_log Notice "PACKAGEID $package_id \n [calendar::have_private_p -party_id $user_id]"
    
    if { ![calendar::have_private_p -party_id $user_id] } {
	
	set calendar_id [calendar::new \
			     -owner_id $user_id \
			     -private_p "t" \
			     -calendar_name "Personal" \
			     -package_id $package_id]
	calendar::item_type_new -calendar_id $calendar_id -type "task"

	
    } else {
	set calendar_id [db_string get_calendar_id {
	    select calendar_id
	    from calendars
	    where owner_id = :user_id
	    and private_p = 't'
	} ]
    }
    
    if { ![calendar::personal_p -calendar_id $calendar_id -user_id $user_id] } {
	permission::require_permission -object_id $calendar_id -party_id $user_id -privilege create
    }
    
    return $calendar_id
    
}




ad_proc -public ns_core::email::scan_email {
    {-mail_id}
} {
    
    It scans email's body, searching, registering and distributing the email to the lawyers, based on defined criteria 
    Specification

    # Critérios de distribuiçao:
    # Quantidade - Complexidade - Competencia - Urgencia
    # Pesos :
    # 1 = 5 pontos; 2 = 15 pontos; 3 = 50 pontos; 4 = 100 pontos; 5 = 200 pontos
    # maximo de pontos por dia: 100
    
    # Contradicao:  5 = 200 enquanto o max diario é 100
    
    # qual a referencia de decisao?
    ##  Selecionar o usuario com menos pontos no dia e enviar o email?
    ## Se todos ultrapassam 100 pontos no dia?
    ### deve-se aguardar o proximo dia?

    # Melhor distribuir alternadamente e tambem adotar os criterior.
    ## Ex.  1 email 1,2,3,1  e outro email 2,1,3,1 com pontuacao muito baixa nao deve ser enviados para o mesmo advogado (enviar alternadamente)


    # Observacoes
    ## Achei o limite de 100 pontos diarios muito baixo. Esta coerente?
    ## Sugiro paramtetrizarmos os criterios para torna-los facilmente modificaveis.
    
    
} {

    ns_log Notice "Running ns_core::scan_email $mail_id"


    set email_id $mail_id
    
    ns_core::email::add_weights -email_id $email_id
     
     
    set score 0
    set weights [db_string select_weights {
	SELECT weights FROM ns_mail_weights WHERE mail_id = :email_id
    } -default ""]
    
    ns_log notice "WEIGHTS $weights"
    
    foreach weight [split $weights  ","] {
	
	set points [db_string get_desc {
	    SELECT description FROM category_translations WHERE name = :weight AND locale = 'en_US'
	} -default ""]    
	
	ns_log Notice "WEIGHT $weight | POINTS $points"
	
	append weights "${weight},"
	
	set score [expr $score + $points]
	
    }
    
    #    ns_log Notice "SCORE $score"
    
    
    # if the final lawyer isn't scored already then it creates a new record

    set target_lawyer [ns_core::user::get_target_lawyer ]
    ns_log Notice "TARGET LAWYER $target_lawyer"
    
    if {[info exists target_lawyer]} {
	if {[db_0or1row select_user {
	    SELECT user_id FROM ns_user_score
	    WHERE user_id = :target_lawyer
	    AND creation_date::date = now()::date
	}] } {
	    
	 #   ns_log Notice "UPDATE USER $target_lawyer TO score table"
	    
	    db_transaction {
		db_dml update_score {
		    
		    UPDATE ns_user_score SET score = score + :score
		    WHERE user_id = :target_lawyer
		    
		}	
	    }
	    
	} else {
	#    ns_log Notice "ADD USER $target_lawyer TO score table"
	    set id [db_nextval ns_user_score_seq]
	    
	    # get user_id
	    db_transaction {
		db_dml insert_user {
		    INSERT INTO ns_user_score (id, user_id, score, creation_date)
		    VALUES (:id, :target_lawyer, :score, now())
		}
	    }
	}    
	
	
	acs_user::get -user_id $target_lawyer -array user
	
	# ns_log Notice "[parray user]"
	
	ix_mail::get -mail_id $email_id -array email
	
	#ns_log Notice "[parray email]"



	###
	# New calendar item
	###
	
	# Based on the score we define activity schedule. Points are converted in Time as 100 points means 1 day of work.
	# Dia util e dia corrido
	# Difinir paraterizacao
	# Parameter quantuidade de pontos por dia. Ex. 100 p/d
	#ns_core::calendar::cal_item_new -score $score -user_id $target_lawyer
	#Ratio of score and time to define how many hours per day a lawyer have to work in a task, based on the score of the ask.
	

	# IF user_id exists
	if {[db_0or1row select_user {
	    SELECT user_id FROM users WHERE user_id = :target_lawyer
	} ] } {
	    set calendar_id [ns_core::calendar::new -user_id $target_lawyer]
	    
	    ns_log Notice "CALENDAR ID $calendar_id"
	    
	    
	    

	    # DEfines start and end date (task deadline) based on the quantity of points (score) of the user (lawyer)
	    set param1 [parameter::get_global_value -package_key "ns-core" -parameter "TotalScoreDaily" -default ""]
	    
	    ns_log Notice "$param1"
	    

	    # 100 per day means 100 per 24 hours, which  means 100 per 24X60 minutes
	    # 24h ??  I'd define that a day has 8 hours.


	    set start_date [db_string select_datetime {SELECT now() FROM dual} ]
	    ns_log Notice "START DATE $start_date "
	    #set end_date [db_string select_datetime {SELECT now() + INTERVAL '1 day'   FROM dual} ]
	    #ns_log Notice "END DATE $end_date "

	    set param2 [parameter::get_global_value -package_key "ns-core" -parameter "WorkingHoursDaily" -default "8"]
	    ns_log Notice "$param2 PRAM2"
	    set no_days [expr $score / $param2]
	    ns_log Notice "NODAYS $no_days"

	    set end_date [db_string select_datetime "SELECT now() + INTERVAL '$no_days days'  FROM dual" ]
	    ns_log Notice "END DATE $end_date "

	    
	    # END start and end dates



	
	    # To support green calendar
	    # set date [split $date "-"]
	    # lappend date ""
	    # lappend date ""
	    # lappend date ""
	    # lappend date "YYYY MM DD"
	    #set date [calendar::to_sql_datetime -date $date -time ""]	
	    
	    #set date "[template::util::date::get_property year $date] [template::util::date::get_property month $date] [template::util::date::get_property day $date]"
	    
	    #set start_date [calendar::to_sql_datetime -date $date -time $start_time -time_p $time_p]
	    #set end_date [calendar::to_sql_datetime -date $end_date -time $end_time -time_p $time_p]





	    # Retrieves calendar types and assigns "task" as item_type
	    set item_types [calendar::get_item_types -calendar_id $calendar_id]
	    ns_log Notice "ITEM TYPES $item_types"

	    foreach type $item_types {
		if {[lindex $type 0] eq "task" } {
		    set item_type_id [lindex $type 1]
		}
		ns_log Notice "$type"
	    }
	    ns_log Notice "$item_type_id"

	    
	    

	    
	    if { ![calendar::personal_p -calendar_id $calendar_id -user_id $target_lawyer] } {
		permission::require_permission -party_id $target_lawyer -object_id $calendar_id -privilege create
	    }
	    
	    set cal_item_id [calendar::item::new \
				 -start_date $start_date \
				 -end_date $end_date \
				 -name $email(subject) \
				 -description $email(bodies) \
				 -calendar_id $calendar_id \
				 -item_type_id $item_type_id \
				 -creation_user $target_lawyer]
	    

	    ns_log Notice "NEW CAL-ITEM $cal_item_id"
	    
	    # not now!!
	    set repeat_p 0
	    if {$repeat_p} {
#		ad_returnredirect [export_vars -base cal-item-create-recurrence { return_url cal_item_id}]
#		    ad_returnredirect [export_vars -base cal-item-view { cal_item_id }]	
	    }
	    
	    # end-if user_id exists		    
	}






	



	###
	# END new calendar item
	###





	# TARGET shouldn't received the same email someone has forwarded to nevessouza
	# IT should receives a ontification from the system within email's content.
	
	###
	# Send email to target lawyer
	###
	
	ns_log Notice "SENDING EMAIL to $user(email)"
	
	acs_mail_lite::send -send_immediately \
	    -from_addr "nevessouza@iurix.com" \
	    -to_addr $user(email) \
	    -subject $email(subject) \
	    -body $email(bodies) \
	    -mime_type "text/html"
	
	
    }
    
    
    
    
    
    
    
    return  
}
    
    
