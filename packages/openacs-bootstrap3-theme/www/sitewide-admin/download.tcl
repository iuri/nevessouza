ad_page_contract {
    @author Gustaf Neumann

    @creation-date Aug 1, 2018
} {
    {version:word,notnull ""}
}

if {$version eq ""} {
    set version $::openacs_bootstrap3_theme::bootstrap_version
}
::util::resources::download \
    -version_dir $version \
    -resource_info [::openacs_bootstrap3_theme::resource_info]

ad_returnredirect .
