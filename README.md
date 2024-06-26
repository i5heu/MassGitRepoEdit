# MassGitRepoEdit

This is a Script collection that will allow you to simply and efficiently edit multiple files in multiple git repos at the same time while handling feature branches, commits and pushes for your changes.

## Install

You need to have python3 and pip3, all compatible with the apt aka ppa versions of mayor linux distributions.  

```bash
pip3 install GitPython
```

## Use

This entire process is pretty self explanatory, all configs and places to edit are well described and well recognizable.    

The different Steps are visible in the filenames of the files you have to EDIT or RUN.  
Files with EDIT need to be edited and not executed.  
Files with RUN need to be executed and not edited.  



For troubleshooting and maintainability here is a overview over the steps, what they do and what you have to do.  

### Step1_EDIT_repos.conf
This is a configuration file.  

```conf
[DEFAULT]
[DEFAULT]
; this is the branch the feature-branch will be created from
; if the branch in Step2_EDIT_repos.list our script will fallback to this branch
GlobalFallBackBranch = main 
; this brnach will be created and checked out from the branch defined in Step2_EDIT_repos.list
; as a fallback to the Step2_EDIT_repos.list branch the GlobalFallBackBranch branch is used
NewBranchName = new-feature-branch
; The commit message all commits will recieve
CommitMessage = Your commit message here A-DFasd 🎉🎉
```

### Step2_EDIT_repos.list
This is a configuration file.  
The First value is the url to the repo, the second one is the branch that is used to create the NewBranchName branch from, if the branch is not found it will fall back to GlobalFallBackBranch.

```text
ssh://git@100.111.10.89:222/Test/Test2.git branchFromWhichFeatureBranchWillBeCreated
ssh://git@100.111.10.89:222/Test/Test3.git main
ssh://git@100.111.10.89:222/Test/Test4.git main
ssh://git@100.111.10.89:222/Test/Test5.git main
```

### Step3_RUN_CloneAndCreateBranch.py
Run it with
```bash
python3 Step3_RUN_CloneAndCreateBranch.py
```
This will download all repos, checkout the defined branch and create a new branch from the defined branch.

### Step4_EDIT_FileChanges.sh
This is a configuration file.   
You need to edit 2 location.  

First you need to this line which will filter all file extensions you want to edit. 
```bash
# Set the file extension the script will process
file_extension=".md"
# ☝️☝️☝️ Edit this line
```

Then you can insert your script to change single files into this area:
```bash
    echo "Processing $file"
    #🔽🔽🔽🔽 Here is place to add your processing logic

    echo "Path: $file"
    tail -n 1 $file



    #🔼🔼🔼🔼 End of processing logic
```

### Step5_RUN_FileChanges.sh
Run it with
```bash
bash Step5_RUN_FileChanges.sh
```

This will execute the script you defined in Step4_EDIT_FileChanges.sh on all files with the defined file extension in all repos.

### Step6_RUN_generate_diff.sh
Run it with
```bash
bash Step6_RUN_generate_diff.sh
```

This will generate a diff for all files that have been changed in the repos. They are stored in the diff folder.  
If you need to have the output in color you can use this command:
```bash
bash Step6_RUN_generate_diff.sh --color
```

### Step7_RUN_commit_and_push.sh
Run it with
```bash
bash Step7_RUN_commit_and_push.sh
```

This will commit all changes in all repos and push them to the remote repo in the checked out branch, which should be the NewBranchName branch.