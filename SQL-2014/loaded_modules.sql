/*
	Memory Optimised Library for SQL Server 2014: 
	Shows details for the Loaded Memory Optimized Modules
	Version: 0.1.0 Beta, September 2016

	Copyright 2015-2016 Niko Neugebauer, OH22 IS (http://www.nikoport.com/), (http://www.oh22.is/)

	Licensed under the Apache License, Version 2.0 (the "License");
	you may not use this file except in compliance with the License.
	You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
*/

SELECT 
	obj.object_id as ObjectId,
	quotename(object_schema_name(obj.object_id)) + '.' + quotename(object_name(obj.object_id)) as ObjectName,
	obj.type_desc as ObjectType,
	md.name as FilePath,	
	--md.description, 
	--md.file_version,
	--md.product_version,
	--substring(md.name, 0, len(md.name) - charindex('_',reverse(md.name)) + 1 ),
	--charindex('_', reverse(substring(md.name, 0, len(md.name) - charindex('_',reverse(md.name)) + 1 ))), 
	substring(substring(md.name, 0, len(md.name) - charindex('_',reverse(md.name)) + 1 ), 
			  len(substring(md.name, 0, len(md.name) - charindex('_',reverse(md.name)) + 1 )) - charindex('_', reverse(substring(md.name, 0, len(md.name) - charindex('_',reverse(md.name)) + 1 ))) + 2, 10 ) as DatabaseId
	--replace(substring(md.name, len(md.name) - charindex('_',reverse(md.name)) + 2, len(md.name) ), '.dll', '') as ObjectId,
	--object_name( replace(substring(md.name, len(md.name) - charindex('_',reverse(md.name)) + 2, len(md.name) ), '.dll', '') ) as ObjectName,
	--*
	FROM sys.dm_os_loaded_modules md  
		LEFT JOIN sys.objects obj
			ON replace(substring(md.name, len(md.name) - charindex('_',reverse(md.name)) + 2, len(md.name) ), '.dll', '')  = obj.object_id
	WHERE description = 'XTP Native DLL'  
		AND substring(substring(md.name, 0, len(md.name) - charindex('_',reverse(md.name)) + 1 ), 
			  len(substring(md.name, 0, len(md.name) - charindex('_',reverse(md.name)) + 1 )) - charindex('_', reverse(substring(md.name, 0, len(md.name) - charindex('_',reverse(md.name)) + 1 ))) + 2, 10 ) = cast(DB_ID() as varchar(10))	
	ORDER BY quotename(object_schema_name(obj.object_id)) + '.' + quotename(object_name(obj.object_id)) 