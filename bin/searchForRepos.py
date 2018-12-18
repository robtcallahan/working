#!/usr/bin/python

import glob
import os
import xmltodict
import time
import sys
from progress.bar import Bar
import argparse

# There are 4321 jobs to search from the following command
# find jenkins-*/jobs -name config.xml | wc -l

TOTAL_JOBS = 8790
TOTAL_WORKING_JOBS = 0
TOTAL_FAILED_JOBS = 0
TOTAL_FOLDERS = 0
NO_SCM_JOB_LIST = []
REPO_LIST = []
job_dirs = [
    'jenkins-release-jobs/jobs',
    'jenkins-master-jobs/jobs',
    'jenkins-develop-jobs/jobs',
    'jenkins-alfred-beta-jobs/jobs'
]

bar = Bar("Searching through jobs", max=TOTAL_JOBS)

for job_dir in job_dirs:
    if not os.path.exists(job_dir):
        raise IOError("Directory does not exist: {}".format(job_dir))

    for root, dir, files in os.walk(job_dir):
        for file in files:
            if(file == "config.xml"):
                config_file = os.path.join(root, file)

                with open(config_file) as fd:
                    doc = xmltodict.parse(fd.read())

                config_type = next(iter(doc))
                if(config_type == 'com.cloudbees.hudson.plugins.folder.Folder'):
                    TOTAL_FOLDERS += 1
                    continue
                if(config_type == 'project'):
                    try:
                        scm_type = doc['project']['scm']['@class']
                    except:
                        print("Couldn't find scm plugin properties for " + config_file)
                        TOTAL_FAILED_JOBS += 1
                        NO_SCM_JOB_LIST.append(config_file)

                    if(scm_type == "hudson.plugins.git.GitSCM"):
                        REPO_LIST.append(doc['project']['scm']['userRemoteConfigs']['hudson.plugins.git.UserRemoteConfig']['url'])
                        TOTAL_WORKING_JOBS += 1
                    elif(scm_type == "org.jenkinsci.plugins.multiplescms.MultiSCM"):
                        for dict in doc['project']['scm']['scms']['hudson.plugins.git.GitSCM']:
                            for k, v in dict.items():
                                if k == 'userRemoteConfigs':
                                    REPO_LIST.append(v['hudson.plugins.git.UserRemoteConfig']['url'])
                        TOTAL_WORKING_JOBS += 1
                    elif(scm_type == "hudson.scm.NullSCM"):
                        TOTAL_WORKING_JOBS += 1
                    elif(scm_type == "org.jenkinsci.plugins.p4.PerforceScm"):
                        TOTAL_WORKING_JOBS += 1
                    elif(scm_type == "hudson.scm.CVSSCM"):
                        TOTAL_WORKING_JOBS += 1
                    else:
                        print("we didn't find anything for {0}".format(config_file))
                        exit()
                if(config_type == 'org.jenkinsci.plugins.workflow.multibranch.WorkflowMultiBranchProject'):
                    try:
                        scm_tpye = doc['com.cloudbees.jenkins.plugins.bitbucket.BitbucketSCMSource']
                        bb_url = doc['org.jenkinsci.plugins.workflow.multibranch.WorkflowMultiBranchProject']['source']['serverUrl']
                        bb_project = doc['org.jenkinsci.plugins.workflow.multibranch.WorkflowMultiBranchProject']['source']['repoOwner']
                        bb_repo = doc['org.jenkinsci.plugins.workflow.multibranch.WorkflowMultiBranchProject']['source']['repository']
                    except:
                        print("Couldn't find scm plugin properties for " + config_file)
                        TOTAL_FAILED_JOBS += 1
                        NO_SCM_JOB_LIST.append(config_file)

                    
                        
                fd.close()
                bar.next()

bar.next()
bar.finish()

total_jobs = TOTAL_WORKING_JOBS + TOTAL_FAILED_JOBS + TOTAL_FOLDERS
total_jobs_missing = TOTAL_JOBS - total_jobs

print("Jobs found: {}".format(str(TOTAL_WORKING_JOBS)))
print("Folders found: {}".format(str(TOTAL_FOLDERS)))
print("No SCM: {}".format(str(TOTAL_FAILED_JOBS)))
print("Total jobs processed: " + str(total_jobs))
if(total_jobs_missing == 0):
    print('Success!')
else:
    print('Failure:  We missed a config, see below.')

for job_name in NO_SCM_JOB_LIST:
    print("{} was not processed".format(job_name))

for url in REPO_LIST:
    print(url)

def get_args():
    parser = argparse.ArgumentParser(
        description = 'Search for repos in all config.xml within a directory'
    )

    parser.add_argument( '-g', '--generate',
        action = 'store',
        type = str,
        required = False,
        default = None,
        help = 'Generate a new list of repos'
    )
