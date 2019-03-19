<?xml version="1.0"?>
<!DOCTYPE queryset PUBLIC "-//OpenACS//DTD XQL 1.0//EN" "http://www.thecodemill.biz/repository/xql.dtd">
<!--  -->
<!-- @author Victor Guerra (guerra@galileo.edu) -->
<!-- @creation-date 2005-05-25 -->
<!-- @cvs-id $Id: change-site-template.xql,v 1.3 2018/08/15 17:02:02 gustafn Exp $ -->

<queryset>
  <fullquery name="select_site_templates">
    <querytext>
      select pretty_name, site_template_id
      from dotlrn_site_templates
    </querytext>
  </fullquery>
</queryset>
