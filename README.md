# ShowsRunningWorkflowsOfHealthService
This is repository of a PowerShell script which will show all the running workflows of a health service

Usage:
1. Stop the MMA on the server.
2. Copy the HealthServiceStore.edb file from the installation directory. Like
   Management Server : C:\Program Files\Microsoft System Center\Operations Manager\Server\Health Service State\Health Service Store
   or Agent C:\Program Files\Microsoft Monitoring Agent\Agent\Health Service State\Health Service Store
3. Open the edb file in Stealth.
4. Navigate to the end on the left panel and expand WORKFLOW
5. Click on Records. Note the number in parenthesis.
6. Click on View -> Options -> Set the Mex Records to a number that you see under Records.
7. Click on Edit -> Select All.
8. Click on Edit -> Copy.
9. Paste the clipboard in Excel Sheet.
10. Delete all columns except D, L
11. Inset a new row at the top. Add the name of the columns as InstanceID and WorkflowName.
12. Save the file as .csv format.
13. Copy the file full path and run the script with that as parameter.
