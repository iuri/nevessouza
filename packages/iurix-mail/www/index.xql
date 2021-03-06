<?xml version="1.0"?>

<queryset>
  <fullquery name="emails_pagination">
    <querytext> 
        SELECT im.mail_id, im.subject, im.from_address, im.date, cr.item_id AS mail_item_id
	FROM iurix_mails im, cr_revisions cr
	WHERE im.mail_id = cr.revision_id
	AND im.user_id = :user_id
	[template::list::filter_where_clauses -and -name "emails"]

    	[template::list::orderby_clause -orderby -name "emails"]

    </querytext>
  </fullquery>

  <fullquery name="select_emails">
    <querytext> 
        SELECT im.mail_id, im.subject, im.from_address, im.date, cr.item_id AS mail_item_id
	FROM iurix_mails im, cr_revisions cr 
	WHERE im.mail_id = cr.revision_id
	AND im.user_id = :user_id 
	[template::list::filter_where_clauses -and -name "emails"]
    	[template::list::page_where_clause -and -name "emails" -key "im.mail_id"]
     	[template::list::orderby_clause -orderby -name "emails"]


    </querytext>
  </fullquery>

</queryset>
