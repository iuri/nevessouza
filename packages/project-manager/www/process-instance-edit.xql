<?xml version="1.0"?>
<!--  -->
<!-- @author  (jader-ibr@bread.com) -->
<!-- @creation-date 2004-11-05 -->
<!-- @arch-tag: ba1c27b7-9842-474d-894f-fb77c40dc1df -->
<!-- @cvs-id $Id: process-instance-edit.xql,v 1.3 2005/05/26 09:34:29 maltes Exp $ -->

<queryset>

  <fullquery name="get_instance">
    <querytext>
      SELECT
      i.name,
      i.process_id
      FROM 
      pm_process_instance i
      WHERE
      i.instance_id = :instance_id
    </querytext>
  </fullquery>

</queryset>
