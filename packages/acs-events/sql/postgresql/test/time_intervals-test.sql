-- packages/acs-events/sql/postgres/test/time_interval-test.sql
--
-- Regression tests for time_interval API
--
-- @author jowell@jsabino.com
-- @creation-date 2001-06-26
--
-- $Id: time_intervals-test.sql,v 1.3 2013/03/30 13:00:30 gustafn Exp $

-- Note: These tests use the semi-ported utPLSQL regression package
\i utest-create.sql

-- Set-up the regression test
CREATE OR REPLACE FUNCTION ut__setup() RETURNS integer AS $$
BEGIN

	raise notice 'Setting up time_intervals test...';

	-- create copies of the tables (shadow tables) to verify API operations
	-- No need for execute here?
	create table ut_time_intervals as select * from time_intervals;

	-- For testing purposes, both tables should still be empty
	PERFORM ut_assert__eqtable ('Comparing copied data for time interval',
				    'time_intervals',
				    'ut_time_intervals'
				    );

	-- Store keys that are in the table prior to the regresion test
	create table ut_interval_ids as select interval_id from time_intervals;

	return 0;

END;
$$ LANGUAGE plpgsql;


-- Clean up the mess that regression testing did
CREATE OR REPLACE FUNCTION ut__teardown() RETURNS integer AS $$
BEGIN

	raise notice 'Tearing down time_intervals test...';

	-- Delete intervals added by tests
	-- cascade delete in timespans should delete corresponding entries in that table
	-- Note that we exclude deleting rows that existed prior to regression test
	delete from ut_time_intervals
	where interval_id not in (select interval_id
			          from ut_interval_ids);

				

	-- Drop test tables
	-- cascade option does not work?
	drop table ut_time_intervals;
	drop table ut_interval_ids;

	return 0;

END;
$$ LANGUAGE plpgsql;


-- Postgres has this weird behavior that you cannot change a row twice
-- within a transaction.  


-- We test the creation of a time interval entry


-- added
select define_function_args('ut__new','date1,date2');

--
-- procedure ut__new/2
--
CREATE OR REPLACE FUNCTION ut__new(
   new__date1 timestamptz,
   new__date2 timestamptz
) RETURNS integer AS $$
DECLARE
	new__interval_id    time_intervals.interval_id%TYPE;
	v_result	    integer;
BEGIN

        raise notice 'Testing time_interval__new...';

	-- create a time interval, and check if entry is made
	v_result :=  ut_assert__isnotnull ('Creating a new test time interval:',
		 		           time_interval__new(new__date1, new__date2)
				           );

	-- Verify that the API does the correct insert by manually entering
	-- an entry in the shadow table
	-- Note that we did not port the currval in the timepsan_seq view
	select currval('timespan_sequence') into new__interval_id;
	insert into ut_time_intervals(interval_id, start_date, end_date)
        values(new__interval_id, new__date1, new__date2);
	
	PERFORM ut_assert__eqtable ('Comparing created data for time interval :',
			    'time_intervals',
			    'ut_time_intervals'
			    );

	-- If successful, interval id is correct
	return new__interval_id;

END;
$$ LANGUAGE plpgsql;


-- Check the deletion of a time interval


-- added
select define_function_args('ut__delete','interval_id');

--
-- procedure ut__delete/1
--
CREATE OR REPLACE FUNCTION ut__delete(
   delete__interval_id integer
) RETURNS integer AS $$
DECLARE
BEGIN

	raise notice 'Testing time interval delete...';

	-- Delete entry from shadow table
	delete from ut_time_intervals
	where interval_id = delete__interval_id;

	-- Delete the row from actual table
	PERFORM time_interval__delete(delete__interval_id);


	-- Verify time interval not there.
	PERFORM ut_assert__eqtable ('Delete verification',
				    'ut_time_intervals',
				    'time_intervals'
				    );

	-- If successful, interval id is correct
	return 0;

END;
$$ LANGUAGE plpgsql;



-- added
select define_function_args('ut__edit','interval_id,start_date,end_date');

--
-- procedure ut__edit/3
--
CREATE OR REPLACE FUNCTION ut__edit(
   edit__interval_id integer,
   edit__start_date timestamptz,
   edit__end_date timestamptz
) RETURNS integer AS $$
DECLARE
BEGIN
        raise notice 'Testing time_interval__edit...';

	-- Edit the time interval
	PERFORM time_interval__edit(edit__interval_id,edit__start_date,edit__end_date);

	-- Verify
	if edit__start_date is not null and edit__end_date is not null
	then
	update ut_time_intervals
		set start_date = edit__start_date,
		    end_date = edit__end_date
		where interval_id = edit__interval_id;
	end if;

	if edit__start_date is null and edit__end_date is not null
	then
	update ut_time_intervals
		set  end_date = edit__end_date
		where interval_id = edit__interval_id;
	end if;

	if edit__start_date is not null and edit__end_date is null
	then
	update ut_time_intervals
		set start_date = edit__start_date
		where interval_id = edit__interval_id;
	end if;

	PERFORM ut_assert__eqtable ('Comparing edited data for time interval',
			    'time_intervals',
			    'ut_time_intervals'
			    );

	return 0;

END;
$$ LANGUAGE plpgsql;



-- added
select define_function_args('ut__eq','msg,interval_id_1,interval_id_2,result');

--
-- procedure ut__eq/4
--
CREATE OR REPLACE FUNCTION ut__eq(
   eq__msg varchar,
   eq__interval_id_1 integer,
   eq__interval_id_2 integer,
   eq__result boolean
) RETURNS integer AS $$
DECLARE

BEGIN

	PERFORM ut_assert__eq (eq__msg,
			       time_interval__eq(eq__interval_id_1, eq__interval_id_2),
			       eq__result
			       );
	return 0;

END;
$$ LANGUAGE plpgsql;




-- added
select define_function_args('ut__shift','interval_id,offset_1,offset_2,date1,date2');

--
-- procedure ut__shift/5
--
CREATE OR REPLACE FUNCTION ut__shift(
   shift__interval_id integer,
   shift__offset_1 integer,
   shift__offset_2 integer,
   shift__date1 timestamptz,
   shift__date2 timestamptz
) RETURNS integer AS $$
DECLARE
BEGIN

	raise notice 'Testing shift...';
		
	-- Shift the time interval
	PERFORM time_interval__shift(shift__interval_id, shift__offset_1, shift__offset_2);

	-- Verify
	update ut_time_intervals 
	        set start_date = shift__date1,
		    end_date = shift__date2
                where interval_id = shift__interval_id;

	PERFORM ut_assert__eqtable ('Comparing shifted data for time intervals',
				    'time_intervals',
				    'ut_time_intervals'
				    );
		
	return 0;

END;
$$ LANGUAGE plpgsql;




-- added

--
-- procedure ut__overlaps_p/4
--
CREATE OR REPLACE FUNCTION ut__overlaps_p(
   overlaps_p__msg varchar,
   overlaps_p__interval_id_1 integer,
   overlaps_p__interval_id_2 integer,
   overlaps_p__result boolean
) RETURNS integer AS $$
DECLARE
BEGIN
	-- Test the time interval
	PERFORM	ut_assert__eq (overlaps_p__msg,
			       time_interval__overlaps_p(overlaps_p__interval_id_1, overlaps_p__interval_id_2),
			       overlaps_p__result
			       );

	return 0;

END;
$$ LANGUAGE plpgsql;



-- added

--
-- procedure ut__overlaps_p/5
--
CREATE OR REPLACE FUNCTION ut__overlaps_p(
   overlaps_p__msg varchar,
   overlaps_p__interval_id integer,
   overlaps_p__start_date timestamptz,
   overlaps_p__end_date timestamptz,
   overlaps_p__result boolean
) RETURNS integer AS $$
DECLARE
BEGIN
	-- Test the time interval
	PERFORM	ut_assert__eq (overlaps_p__msg,
			       time_interval__overlaps_p(overlaps_p__interval_id, 
							 overlaps_p__start_date,
							 overlaps_p__end_date),
			       overlaps_p__result
			       );

	return 0;

END;
$$ LANGUAGE plpgsql;



-- added
select define_function_args('ut__overlaps_p','msg,start_date_1,end_date_1,start_date_2,end_date_2,result');

--
-- procedure ut__overlaps_p/6
--
CREATE OR REPLACE FUNCTION ut__overlaps_p(
   overlaps_p__msg varchar,
   overlaps_p__start_date_1 timestamptz,
   overlaps_p__end_date_1 timestamptz,
   overlaps_p__start_date_2 timestamptz,
   overlaps_p__end_date_2 timestamptz,
   overlaps_p__result boolean
) RETURNS integer AS $$
DECLARE
BEGIN
	-- Test the time interval
	PERFORM	ut_assert__eq (overlaps_p__msg,
			       time_interval__overlaps_p(overlaps_p__start_date_1,
							 overlaps_p__end_date_1,
							 overlaps_p__start_date_2,
							 overlaps_p__end_date_2),
			       overlaps_p__result
			       );

	return 0;

END;
$$ LANGUAGE plpgsql;




-- added
select define_function_args('ut__copy','interval_id,offset');

--
-- procedure ut__copy/2
--
CREATE OR REPLACE FUNCTION ut__copy(
   copy__interval_id integer,
   copy__offset integer
) RETURNS integer AS $$
DECLARE
	v_interval_id		time_intervals.interval_id%TYPE;
	interval_row		record;
BEGIN

	raise notice 'Testing time_interval__copy...';
		
		
	-- Copy the time interval
	v_interval_id := time_interval__copy(copy__interval_id,copy__offset);

	-- Get the copied start and end dates, before the offset
	select * into interval_row
	from time_intervals
	where interval_id = copy__interval_id;

	-- Insert for testing
	insert into ut_time_intervals (interval_id, start_date, end_date)
	values (v_interval_id, interval_row.start_date + copy__offset, interval_row.end_date + copy__offset);

	-- Verify copies
	PERFORM	ut_assert__eqtable ('Comparing copied data for time intervals',
			            'time_intervals',
			            'ut_time_intervals'
				    );

	return v_interval_id;

END;
$$ LANGUAGE plpgsql;




--
-- procedure ut__regression1/0
--
CREATE OR REPLACE FUNCTION ut__regression1(

) RETURNS integer AS $$
DECLARE
	v_result	 integer := 0;
	v_interval_id	 time_intervals.interval_id%TYPE;
	v_interval_id_ck time_intervals.interval_id%TYPE;
BEGIN

	raise notice 'Regression test, part 1 (creates and edits).';

	-- We first check if the creation of time intervals work
	v_interval_id := ut__new(timestamptz '2001-01-01',timestamptz '2001-01-02');

	-- Try to edit, putting new values for start date and end dates
	PERFORM ut__edit(v_interval_id,timestamptz '2001-01-02',timestamptz '2001-01-30');

	-- Edit, but this time, change only the start date
	PERFORM ut__edit(v_interval_id,timestamptz '2001-01-07',null);

	-- Edit, but this time, change only the end date
	PERFORM ut__edit(v_interval_id,null,timestamptz '2001-01-08');

	-- We now test equality of (identical) intervals
	PERFORM ut__eq('Equal (same) intervals',v_interval_id,v_interval_id,true);

	-- Create another interval for comparison
	v_interval_id_ck := ut__new(timestamptz '2001-01-07',timestamptz '2001-01-08');

	-- We now test equality of (nonidentical) intervals
	PERFORM ut__eq('Equal (distinct) intervals',v_interval_id,v_interval_id_ck,true);

	-- Shift the second interval start date by one day, the end date by two days
	PERFORM ut__shift(v_interval_id_ck,1,2,timestamptz '2001-01-08', timestamptz '2001-01-10');

	-- Now test inequality of time intervals
	PERFORM ut__eq('Unequal (distinct) intervals',v_interval_id,v_interval_id_ck,false);

	-- Shift the second interval start date BACK by one day, the end date same
	PERFORM ut__shift(v_interval_id_ck,-1,0,timestamptz '2001-01-07', timestamptz '2001-01-10');

	-- Now test inequality of time intervals
	PERFORM ut__eq('Unequal (distinct) intervals: start date equal',v_interval_id,v_interval_id_ck,false);

	-- Shift the second interval, start date same, but the end date BACK by two days
	PERFORM ut__shift(v_interval_id_ck,0,-2,timestamptz '2001-01-07', timestamptz '2001-01-08');

	-- Should be equal again
	PERFORM ut__eq('Equal again, (distinct) intervals',v_interval_id,v_interval_id_ck,true);

	-- For fun, shift start date BACK by two days, the end date BACK by 1 day
	PERFORM ut__shift(v_interval_id_ck,-2,-1,timestamptz '2001-01-05', timestamptz '2001-01-07');

	-- Should be unequal again
	PERFORM ut__eq('For fun, unequal (distinct) intervals',v_interval_id,v_interval_id_ck,false);

	-- Note that at this point, interval pointed to by v_interval_id is from 2001-01-07 through 2001-01-08
	-- while interval pointed to by v_interval_id_ck is from 2001-01-05 through 2001-01-07.
	-- They overlap.
	PERFORM ut__overlaps_p('Overlapping intervals',v_interval_id,v_interval_id_ck,true);

	-- Ok, shift the dtart and end dates by one so that intervals do not overlap
	PERFORM ut__shift(v_interval_id_ck,-1,-1,timestamptz '2001-01-04', timestamptz '2001-01-06');

	-- They should not overlap now.
	PERFORM ut__overlaps_p('Non-overlapping intervals',v_interval_id,v_interval_id_ck,false);


	-- We test the overloaded function definitions of time_interval__overlaps_p
	-- Note that we are comparing with 2001-01-07 through 2001-01-08
	PERFORM ut__overlaps_p('Overlapping intervals',
			       v_interval_id,
			       timestamptz '2001-01-06',
			       timestamptz '2001-01-09',
			       true);	

	-- How about an interval next month?
	PERFORM ut__overlaps_p('Non-overlapping intervals',
			       v_interval_id,
			       timestamptz '2001-02-06',
			       timestamptz '2001-02-09',
			       false);	

	-- Try a null starting interval
	PERFORM ut__overlaps_p('Overlapping intervals (null start)',
			       v_interval_id,
			       null,
			       timestamptz '2001-01-09',
			       true);	

	-- Try a null starting interval
	PERFORM ut__overlaps_p('Overlapping intervals (null end)',
			       v_interval_id,
			       timestamptz '2001-01-06',
			       null,
			       true);	

	-- What if the interval is not an allowable interval?
	-- By definition, any interval should be non-overlapping with a non-existent interval
	PERFORM ut__overlaps_p('Non-overlapping intervals (non-allowed interval, outside month)',
			       v_interval_id,
			       timestamptz '2001-02-09',
			       timestamptz '2001-02-06',
			       false);				     

	-- What if the interval is not an allowable interval?
	-- By definition, any interval should be non-overlapping with a non-existent interval
	PERFORM ut__overlaps_p('Non-overlapping intervals (non-allowed interval, in month)',
			       v_interval_id,
			       timestamptz '2001-01-09',
			       timestamptz '2001-01-06',
			       false);				     

	-- Yet another overloaded definition
	PERFORM ut__overlaps_p('Overlapping intervals (not in time_intervals)',
			       timestamptz '2001-01-06',
			       timestamptz '2001-01-09',
			       timestamptz '2001-01-07',
			       timestamptz '2001-01-08',
			       true);				     


	-- Yet another overloaded definition
	PERFORM ut__overlaps_p('Overlapping intervals (not in time_intervals)',
			       timestamptz '2001-01-06',
			       timestamptz '2001-01-09',
			       timestamptz '2001-01-09',
			       timestamptz '2001-01-10',
			       true);				     

	-- Yet another overloaded definition
	PERFORM ut__overlaps_p('Overlapping intervals (not in time_intervals)',
			       timestamptz '2001-01-06',
			       timestamptz '2001-01-09',
			       null,
			       timestamptz '2001-01-10',
			       true);				     
	PERFORM ut__overlaps_p('Overlapping intervals (not in time_intervals)',
			       timestamptz '2001-01-06',
			       timestamptz '2001-01-09',
			       timestamptz '2001-01-10',
			       null,
			       false);				     

	-- Yet another overloaded definition
	PERFORM ut__overlaps_p('Non-overlapping intervals (not in time_intervals)',
			       timestamptz '2001-02-06',
			       timestamptz '2001-02-09',
			       timestamptz '2001-01-07',
			       timestamptz '2001-01-08',
			       false);				     



	-- Overwrite the check interval a copy, with zero offset
	v_interval_id_ck := ut__copy(v_interval_id,0);


	-- Should be equal
	-- Now test equality of time intervals
	PERFORM ut__eq('Copied intervals (zero offset)',v_interval_id,v_interval_id_ck,true);

	-- Overwrite the check interval a copy, with non-zero offset
	v_interval_id_ck := ut__copy(v_interval_id,1);


	-- Should be unequal
	-- Now test inequality of time intervals
	PERFORM ut__eq('Copied intervals (non-zero offset)',v_interval_id,v_interval_id_ck,false);


	-- We will improve the regression test so there is reporting 
	-- of individual test results.  For now, reaching this far is
	-- enough to declare success.
       	return v_result;

END;
$$ LANGUAGE plpgsql;



--
-- procedure ut__regression2/0
--
CREATE OR REPLACE FUNCTION ut__regression2(

) RETURNS integer AS $$
DECLARE
	v_result	 integer := 0;
	rec_interval	 record;
BEGIN

	raise notice 'Regression test, part 2 (deletes).';

	-- Remove all entries made by regression test
	-- This also tests the deletion mechanism
	FOR rec_interval IN 
	   select * from time_intervals
	   where interval_id not in (select interval_id from ut_interval_ids)
        LOOP
		PERFORM ut__delete(rec_interval.interval_id);
	END LOOP;

	-- We will improve the regression test so there is reporting 
	-- of individual test results.  For now, reaching this far is
	-- enough to declare success.
       	return v_result;

END;
$$ LANGUAGE plpgsql;

--------------------------------------------------------------------------------
-- Main regression test.  PostgreSQL does not allow multiple changes made to a 
-- primary key inside a transaction if the primary key is referenced by another 
-- table (e.g., insert and delete). As a fix, we break down the regression test 
-- so that row creations and edits are separate from row deletions
--------------------------------------------------------------------------------
select (case when ut__setup() = 0
             then
	         'Regression test properly set up.'
	     end) as setup_result;

select (case when ut__regression1() = 0
             then
	         'Regression test, part 1 successful.'
	     end) as test_result;

select (case when ut__regression2() = 0
             then
	         'Regression test, part 2 successful.'
	     end) as test_result;

select (case when ut__teardown() = 0
             then
	         'Regression test properly torn down.'
	     end) as teardown_result;

-- Clean up created functions.
-- This depends on openacs4 installed.
select drop_package('ut');

--------------------------------------------------------------------------------
-- End of regression test
--------------------------------------------------------------------------------
\i utest-drop.sql








