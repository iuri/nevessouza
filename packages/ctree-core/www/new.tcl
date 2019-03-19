ad_page_contract {}


set tree_id [content::item::new \
		 -name "test" \
		 -creation_user [ad_conn user_id] \
		 -creation_ip [ad_conn peeraddr] \
		 -package_id [ad_conn package_id] \
		 -content_type "c_tree" \
		 -mime_type "text/plain"
	    ]




set type_id [content::item::new \
		 -name "21ec137f-d241-1062-535d-348db8190275" \
		 -parent_id $tree_id \
		 -creation_user [ad_conn user_id] \
		 -creation_ip [ad_conn peeraddr] \
		 -package_id [ad_conn package_id] \
		 -content_type "c_type" \
		 -mime_type "text/plain"
	    ]




set attributes [list]
lappend attributes [list color "#8a5b15"]
lappend attributes [list icon_url "/images/app-icon-32.png"]
lappend attributes [list parents_max 0]
lappend attibutes [list parents_required false]
lappend attibutes [list prompt "Create cTree"]


set revision_id [content::revision::new \
		     -item_id $type_id \
		     -title "Subject" \
		     -description "What this cTree is about" \
		     -attributes $attributes]
