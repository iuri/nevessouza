<?xml version="1.0"?>
<!DOCTYPE queryset PUBLIC "-//OpenACS//DTD XQL 1.0//EN"
"http://www.thecodemill.biz/repository/xql.dtd">
<!-- packages/assessment/tcl/as-item-procs-postgresql.xql -->
<!-- @author Dave Bauer (dave@thedesignexperience.org) -->
<!-- @creation-date 2006-05-18 -->
<!-- @cvs-id $Id: as-item-procs-postgresql.xql,v 1.2 2006/06/12 02:49:50 daveb Exp $ -->
<queryset>
  
  <rdbms>
    <type>postgresql</type>
    <version>7.4</version>
  </rdbms>
  
  <fullquery name="as::item::new.update_clobs">
    <querytext>
      update as_items
      set feedback_right=:feedback_right,
      feedback_wrong=:feedback_wrong,
	  validate_block=:validate_block
      where as_item_id=:as_item_id
      </querytext>
  </fullquery>

  <fullquery name="as::item::edit.update_clobs">
    <querytext>
      update as_items
      set feedback_right=:feedback_right,
      feedback_wrong=:feedback_wrong,
	  validate_block=:validate_block
      where as_item_id=:new_item_id
      </querytext>
  </fullquery>  
  
  <fullquery name="as::item::new_revision.update_clobs">
    <querytext>
      update as_items
      set feedback_right=:feedback_right,
      feedback_wrong=:feedback_wrong,
	  validate_block=:validate_block
      where as_item_id=:new_item_id
      </querytext>
  </fullquery>  
  
</queryset>
