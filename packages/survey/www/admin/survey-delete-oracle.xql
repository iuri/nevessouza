<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>
<fullquery name="delete_survey">
<querytext>
begin
	survey.remove(:survey_id);
end;
</querytext>
</fullquery>

</queryset>