ad_page_contract {} {
    {token}
    {name ""}
}

set access_token [parameter::get_global_value -package_key "ctree-rest" -parameter "WSAccessToken" -default ""]
set access_token "please"

if { [string equal $token $access_token] } {

    
    if { [exists_and_not_null name] } {
	set item_id [db_string select_item_id {
	    SELECT item_id FROM cr_items WHERE name = :name 
	} -default ""]
	
	content::item::get -item_id $item_id -array_name item
	
    } else {

	
	
    }
    
    set json "{
                  \"data\": {
                               \"status\":true,
                               $json

                  },
                  \"errors\":{},
                  \"meta\": { 
                             \"copyright\": \"Copyright (c) 2017-2019 Foundation For an Innovative Future (InnovativeFuture.org).\",
                             \"application\": \"C-Tree Rest API\",
                             \"version\": \"0.1d\",
                             \"id\": \"HTTP/1.1 200 Authorized\",
                             \"status\": \"true\"
                             \"message\": \"Successfull Request. Access allowed\"
                  }                                                                                                 
    }"



    doc_return 200 "application/json" $json

} else {



    set json "{
                  \"data\": {
                               \"status\":false,
                               \"items\": null

                  },
                  \"errors\":{
                               \"id\": \"401 Unauthorized\",
                               \"status\": \"HTTP/1.1 401 Access Denied\",
                               \"title\": \"Token is invalid!\",
                               \"detail\": \"You should pass the correct token.\",
                               \"source\": \"filename: /packages/evex-rest/userLoginRequest.tcl\"
                  },
                  \"meta\": {
                               \"copyright\": \"Copyright (c) 2017-2019 Foundation For an Innovative Future (InnovativeFuture.org).\",
                               \"application\": \"C-Tree Rest API\",
                               \"version\": \"0.1d\",
                               \"id\": \"HTTP/1.1 401 Unauthorized\",
                               \"status\": \"false\",
                               \"message\": \"Invalid Token. Access denied.\"
                  }                
        }"

    doc_return 401 "application/json" $json
    ad_return_complaint 1 "Request Failed! Token's invalid!"
    

}

ad_script_abort
