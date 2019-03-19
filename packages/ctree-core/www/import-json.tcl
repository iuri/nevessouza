ad_page_contract {
    Import JSON file
} {
    {url "https://iurix.com/resources/ctree-core/firebase-export.json"}
}


package require rl_json
namespace path {::rl_json}



# Gets file data
#set f1 [open "/var/www/iurix/packages/ctree-core/resources/firebase-export.json" r]
#set data [read $fl]


set result [util::http::get -url $url]
#ns_log Notice "JSON $result"


# Converts JSON to TCL array
array set arr $result

# Isolates page data
set data [json get $arr(page)]
#ns_log Notice "DATA $data"

set ctrees [lindex $data 1]

foreach tree $ctrees {
    ns_log Notice "$tree"

}


# https://github.com/RubyLane/rl_json

