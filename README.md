# chunk_checker
Wee script to see if metrics is honestly reporting the actual no of records stored

Install to $HOME/.local/bin

chmod +x  chunk_checker.sh

Run chunk_checker.sh

Choose your method of running nodes. For most folks this will be Launchpad

$ record_check.sh
Please select a search option:
1) Launchpad
2) Antnode Manager (antctl)
3) Formicaio
4) NTracking(anm)
Enter your choice (1-4): 

This will choose the requisite path to start searching for all instances of record_store dirs and count the chunks in each directory
