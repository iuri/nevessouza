-- /packages/ix-currency/sql/postgresql/ix-currency-drop.sql

--
-- IX Currency Package
--
-- @author Iuri Sampaio (iuri.sampaio@iurix.com)
-- @creation-date 2015-09-11
--
DROP FUNCTION ix_currency_rate__new (
       varchar,	  	   -- currency_code
       varchar		   -- rate
);

DROP FUNCTION ix_currency_rate__delete (
       integer		   -- rate_id
);


DROP SEQUENCE ix_currency_rate_id_seq;


------------------------------------
-- Table: ix_rates
------------------------------------

DROP TABLE ix_currency_rates CASCADE;


