ad_page_contract {} {
    old_file:trim,optional
    old_file.tmpfile:tmpfile,optional
    new_file:trim,optional
    new_file.tmpfile:tmpfile,optional
}


ad_form -name filediff -html {enctype multipart/form-data} -form {
    {old_file:file {label "Upload old file"} {html "size 30"}}
    {new_file:file {label "Upload new file"} {html "size 30"}}    
} -on_submit {

    # old_file's filesize
    set filesize1 [file size ${old_file.tmpfile}]
    # new_file's filesize is greater than 0 
    set filesize2 [file size ${new_file.tmpfile}]
    
    # open old file and assign its address to f1 variable. read permissions only
    set f1 [open ${old_file.tmpfile} r]
    # open new file and assign its address to f2 variable. read permissions only
    set f2 [open ${new_file.tmpfile} r]
    
    # assign f1 content into data1 stream
    set lines1 [split [read $f1] "\n"]
    # assign f2 content into data2 stream
    set lines2 [split [read $f2] "\n"]


    if {$filesize1 eq 0 && $filesize2 > 0} {
	foreach line $lines2 {
	    set output "+ $line \n"
	}

	doc_return 200 text/html $output
    }
    
    
    foreach line1 $lines1 line2 $lines2 {

	ns_log Notice " Comparing: $line1 | $line2 "
	
	if { [string equal $line1 $line2] } {
	    
	    if { $line1 eq "" && $line2 eq ""} {
		append output "  [lindex $l2 0] \n"
		set l2 [lreplace $l2 0 0]
		
	    } else {
		
		append output "  $line1 \n"
	    }
	} else {
	    
	    if { $line1 ne "" && $line2 eq "" } {
		append output "+ [lindex $l2 0] \n"
		set l2 [lreplace $l2 0 0]
		
	    } else {
	   
		append output "- $line1 \n"
		lappend l2 $line2
	    }
	}
      	
    }

    file delete -- ${old_file.tmpfile}
    file delete -- ${new_file.tmpfile}
   
    ns_log Notice "OUTPUT $output"    
    doc_return 200 text/plain $output
    
    
    
}
    
    
