<!--	
	Displays the basic UI for the calendar
	
	@author Gary Jin (gjin@arsidigta.com)
     	@creation-date Dec 14, 2000
     	@cvs-id $Id: cal-item-create-recurrence.adp,v 1.16 2018/01/19 14:27:14 gustafn Exp $
-->


<master>
<property name="doc(title)">#calendar.lt_Calendars_Repeating_E#</property>
<property name="context">#calendar.Repeat#</property>

#calendar.lt_You_are_choosing_to_m#
<p>
<strong>#calendar.Date#</strong> @cal_item.start_date@<br>
<strong>#calendar.Time#</strong>
<if @cal_item.time_p;literal@ true>
  @cal_item.start_time@ - @cal_item.end_time@
</if>
<else>
  #calendar.All_Day_Event#
</else><br>
<strong>#calendar.Details#</strong> @cal_item.description@
<p>

    <formtemplate id="cal_item"></formtemplate>


