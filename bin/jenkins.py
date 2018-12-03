#!/bin/env python

from jenkinsapi.jenkins import Jenkins

def get_server_instance():
    jenkins_url = 'https://alfred-beta.idirect.net'
    server = Jenkins(jenkins_url, username='rcallahan', password='S0br13ty!', ssl_verify=False)
    return server

def get_job_details():
    # Refer Example #1 for definition of function 'get_server_instance'
    server = get_server_instance()
    for j in server.get_jobs():
        job_instance = server.get_job(j[0])
        print 'Job Name:%s' %(job_instance.name)
        print 'Job Description:%s' %(job_instance.get_description())
        print 'Is Job running:%s' %(job_instance.is_running())
        print 'Is Job enabled:%s' %(job_instance.is_enabled())

if __name__ == '__main__':
    server = get_server_instance()
    nodes = server.get_nodes()
    for node in nodes.iterkeys():
        print server.get_node(node)
        exit(0)
