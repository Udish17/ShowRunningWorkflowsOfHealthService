# ShowsRunningWorkflowsOfHealthService
This is repository of a PowerShell script which will show all the running workflows of a health service

Usage:
1. Stop the MMA on the server.
2. It is important to note that the MMA stops properly. In cases, where the MMA is under heavy load then it might time out and lock the edb.
3. In such case, incease the Windows Service Pipe timeout and reboot the MS. Let the workflow count increase and then try to stop the MMA.
   # reg add "HKLM\SYSTEM\CurrentControlSet\Control" /v "ServicesPipeTimeout" /t REG_DWORD /d 60000 /f
4. Copy the HealthServiceStore.edb file from the installation directory. Like
   Management Server : C:\Program Files\Microsoft System Center\Operations Manager\Server\Health Service State\Health Service Store
   or Agent C:\Program Files\Microsoft Monitoring Agent\Agent\Health Service State\Health Service Store
5. Open the edb file in Stealth.
6. Navigate to the end on the left panel and expand WORKFLOW
7. Click on Records. Note the number in parenthesis.
8. Click on View -> Options -> Set the Mex Records to a number that you see under Records.
9. Click on Edit -> Select All.
10. Click on Edit -> Copy.
11. Paste the clipboard in Excel Sheet.
12. Delete all columns except D, L
13. Inset a new row at the top. Add the name of the columns as InstanceID and WorkflowName.
14. Save the file as .csv format.
15. Copy the file full path and run the script with that as parameter.
