ad_page_contract {


}

# http://www.ecb.europa.eu/stats/eurofxref/eurofxref-daily.xml
# Convert currencies


set currencies [ix_currency::get_currency_rates "today"]

set l_cur ""

foreach currency $currencies {
    ns_log Notice "$currency"
    append l_cur $currency  
    append l_cur " | "
}


#http://stackoverflow.com/questions/9716868/select-todays-since-midnight-timestamps-only


# Round diff and percent to 4 decimals
#http://www.postgresql.org/docs/8.3/static/typeconv-func.html

set currencies2 [db_list_of_lists select_rates {
    SELECT cr1.currency_code AS currency, cast(cr1.rate as numeric) AS today, cast(cr1.rate as numeric)-cast(t1.rate as numeric) AS diff, 100-(cast(t1.rate as numeric)*100/cast(cr1.rate as numeric)) AS percent from ix_currency_rates cr1 RIGHT OUTER JOIN ( select * from ix_currency_rates cr1 WHERE cr1.creation_date > now() - interval '48 hour' AND creation_date < now() - interval '24 hours') as t1 ON (t1.currency_code = cr1.currency_code) WHERE cr1.creation_date > now() - interval '24 hour' ;
}]


# TCL Function References
# https://www.tcl.tk/man/tcl8.4/TclCmd/expr.htm
# http://www.astro.princeton.edu/~rhl/Tcl-Tk_docs/tcl/expr.n.html
# https://www.tcl.tk/man/tcl/TclCmd/format.htm
# https://www.tcl.tk/man/tcl8.4/TclCmd/format.htm

set usd_pos [lsearch -glob $currencies2 USD*]
set usd_rate [lindex [lindex $currencies2 $usd_pos] 1]
set usd_diff [lindex [lindex $currencies2 $usd_pos] 2]
set usd_percent [lindex [lindex $currencies2 $usd_pos] 3]
set eur_rate [expr 1 / [expr $usd_rate]]

if {[expr $usd_diff] != 0} {
set eur_diff [expr 1 / [expr $usd_diff]]
set eur_percent [expr 1 / [expr $usd_percent]]
} else { 
set eur_diff 0.00
set eur_percent 0.00
}

# https://www.tcl.tk/man/tcl/TclCmd/lreplace.htm
set currencies2 [lreplace $currencies2 0 0 "EUR $eur_rate $eur_diff $eur_percent"] 

ns_log Notice "[lindex $currencies2 0]"
# 
#ns_log Notice "LST EUR $$eur USD"

#http://stackoverflow.com/questions/5575868/convert-postgres-field-of-type-varchar-to-numeric

set lcur ""
foreach currency $currencies2 {
    set code [lindex $currency 0]
    set rate [format "%.4f" [expr [expr $eur_rate] * [expr [lindex $currency 1]]]]

    set diff [format "%.4f" [expr [lindex $currency 2]]]
    set percent [format "%.4f" [expr [lindex $currency 3]]]

    set one_currency_url [export_vars -base "/ix-currency/one-currency" {code rate diff percent usd_rate}]

    append lcur " | <a style='text-decoration:none;' href='$one_currency_url'>$code: "
    if {$diff < 0} {
	append lcur "<span style=\"color:red;\">$$rate $$diff $percent%</span></a>"
    } elseif {$diff == 0} {
	append lcur "<span style=\"color:blue;\">$$rate $$diff $percent%</span>"
    } elseif {$diff > 0} {
	append lcur "<span style=\"color:green;\">$$rate  $+$diff +$percent%</span>"
    }



}


template::head::add_javascript -src "/resources/ix-currency/js/crawler.js"


