Alter Database Sample2 Modify Name = Sample3



sp_renameDB 'Sample3','Sample4'


Drop database Sample4

Drop database master

Alter Database Sample4 Set SINGLE_USER With Rollback Immediate

Drop database Sample4




