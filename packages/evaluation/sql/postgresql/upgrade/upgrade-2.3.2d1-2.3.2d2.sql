-- 
-- 
-- 
-- @author Victor Guerra (guerra@galileo.edu)
-- @creation-date 2007-12-10
-- @cvs-id $Id: upgrade-2.3.2d1-2.3.2d2.sql,v 1.2 2018/08/15 16:55:08 gustafn Exp $
--


update apm_parameters set default_value = 'zip' where parameter_name = 'ArchiveExtension' and package_key = 'evaluation';
update apm_parameters set default_value = '/usr/bin/zip -r {out_file} {in_file}' where parameter_name = 'ArchiveCommand' and package_key = 'evaluation';
update apm_parameter_values set attr_value = '/usr/bin/zip -r {out_file} {in_file}' where parameter_id = (select parameter_id from apm_parameters where parameter_name = 'ArchiveExtension' and package_key = 'evaluation');
update apm_parameter_values set attr_value = 'zip' where parameter_id = (select parameter_id from apm_parameters where parameter_name = 'ArchiveCommand' and package_key = 'evaluation');
