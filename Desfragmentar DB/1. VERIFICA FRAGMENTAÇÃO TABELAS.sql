Select object_name(ind.object_id) AS TableName, 
	   indexstats.page_count,
	   indexstats.index_depth,
	   indexstats.index_level,
	   indexstats.avg_page_space_used_in_percent,
	   indexstats.avg_fragmentation_in_percent

	From sys.dm_db_index_physical_stats(DB_id(), OBJECT_ID('nometabela'), NULL, NULL, 'DETAILED') indexstats 
    Inner Join sys.indexes ind On ind.object_id = indexstats.object_id 
                                And ind.index_id = indexstats.index_id 

	 Where alloc_unit_type_desc = 'IN_ROW_DATA' 
	 and index_level = 0 
	 and avg_page_space_used_in_percent < 99
	 and page_count > 1000

 Order by 2 desc

