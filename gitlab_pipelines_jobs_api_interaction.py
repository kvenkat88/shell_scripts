import gitlab
import time

def gitlab_project_obj_fetch(url, private_access_token, gitlab_project_id):
    """
    Hit the Gitlab Pipelines API with project id and fetch the access obj
    :param url: url as string
    :param private_access_token: private_access_token as string
    :param gitlab_project_id: gitlab_project_id as string
    :return:
    """
    gl = gitlab.Gitlab(url, private_token=private_access_token)
    project_obj = gl.projects.get(gitlab_project_id)
    return project_obj

def identify_gitlab_project_running_status(gitlab_url, access_token, project_id,pipeline_status):
    """
    Identify the pipeline flow status(running,pending,canceled,etc) and wait for some time if pipeline is already running else continue on normal process
    :param gitlab_url: gitlab_url as string
    :param access_token: access_token as string
    :param project_id: project_id as string
    :param pipeline_status: pipeline_status as tuple. eg (running,pending,canceled)
    :return:
    """
    pipeline_availability_status = []
    proj_obj = gitlab_project_obj_fetch(url=gitlab_url, private_access_token=access_token, gitlab_project_id=project_id)

    for lin in proj_obj.pipelines.list():
        if lin.attributes['status'] in pipeline_status:
            print("{} status ::: pipeline_id:{}".format(lin.attributes['status'], lin.attributes['id']))

    pipeline_total_count = sum([1 for lin in proj_obj.pipelines.list() if lin.attributes['status'] in pipeline_status])
    print("Pipeline Sum fetched is ",pipeline_total_count)
    pipeline_status_sum_bool = sum([1 for lin in proj_obj.pipelines.list() if lin.attributes['status'] in pipeline_status]) >= 1  # noqa

    #pipeline_availability_status.append({""})


def cancel_gitlab_pipeline_flow(gitlab_url, access_token, project_id, pipeline_id):
    """
    Fetch the gitlab project details with project id and cancel the pipeline available
    :param gitlab_url: gitlab_url as string
    :param access_token: access_token as string
    :param project_id: project_id as string
    :param pipeline_id: pipeline_id as string
    :return:
    """
    proj_obj = gitlab_project_obj_fetch(url=gitlab_url, private_access_token=access_token, gitlab_project_id=project_id)

    pipeline = proj_obj.pipelines.get(pipeline_id)
    pipeline.cancel() # cancel the pipeline using pipeline id
    time.sleep(2)

    # Check whether pipeline is cancelled or not
    for lin in proj_obj.pipelines.list():
        print("Running for pipeline id - {} and its status available in function response is {}".format(lin.attributes['id'], lin.attributes['status']))

        if lin.attributes['id'] == int(pipeline_id):
            if lin.attributes['status'] == "canceled":
                print("Pipeline ID - {} requested for cancellation is successfully completed".format(pipeline_id))
                break

            if lin.attributes['status'] != "canceled":
                print("Pipeline ID - {} requested for cancellation is not successfully completed".format(pipeline_id))
                break



def gitlab_pipeline_get_all_jobs(gitlab_url, access_token, project_id, pipeline_id):
    """
    Fetch the gitlab project details with project id and cancel the pipeline available
    :param gitlab_url: gitlab_url as string
    :param access_token: access_token as string
    :param project_id: project_id as string
    :param pipeline_id: pipeline_id as string
    :return:
    """
    jobs_detail_list = []
    success_flag = False
    proj_obj = gitlab_project_obj_fetch(url=gitlab_url, private_access_token=access_token, gitlab_project_id=project_id)

    pipeline = proj_obj.pipelines.get(pipeline_id)
    jobs = pipeline.jobs.list()

    for lin in jobs:
        if lin.attributes['pipeline']['id'] == int(pipeline_id):
            #print(lin.attributes['stage'])
            jobs_detail_list.append({"job_id": lin.attributes['id'], "job_stage": lin.attributes['stage'],"job_status": lin.attributes['status'],  "job_name": lin.attributes['name']})

    #print(jobs_detail_list)
    #print([lin['job_stage'] for lin in jobs_detail_list])

    while True:
        if len(jobs_detail_list) != 0:
            #print("job_stages available is ",[lin['job_stage'] for lin in jobs_detail_list])
            #d = ["stage_completed" for lin in jobs_detail_list if lin['job_stage'] == 'push_to_aws_ecr_registry' and lin['job_stage'] == "canceled"]

            for a in jobs_detail_list:
                # if a['job_stage'] == 'push_to_aws_ecr_registry':
                #     print("job_stage - {} and status of job is {}".format("push_to_aws_ecr_registry",a['job_status'] if a['job_stage'] == 'push_to_aws_ecr_registry' else "don't consider"))

                if a['job_stage'] == 'push_to_aws_ecr_registry' and a['job_status'] == "running":
                    print("{} stage is running status and out of the while loop")

                if a['job_stage'] == 'push_to_aws_ecr_registry' and a['job_status'] == "success":
                    print("{} stage is success status and out of the while loop")
                    success_flag = True
                    break
        else:
            print("Length of the jobs_detail_list may be zero")
            break

        if success_flag == True:
            break


# def is_another_job_running():
#     # project_obj = fetch_gitlab_project_object(gitlab_url, access_token, project_id)
#
#     for lin in project.pipelines.list():
#         if lin.attributes['status'] in ('running'):
#             print("{} status ::: pipeline_id:{}".format(lin.attributes['status'], lin.attributes['id']))
#
#     return sum([1 for lin in project.pipelines.list() if lin.attributes['status'] == 'running']) > 1  # noqa
#
# while is_another_job_running():
#     print("Woha, another job is running...")
#     print("In any case I'm waiting ... ")
#     time.sleep(300)
#
# print("Awesome !!! no jobs or pipeline is running!")
# print("I will run another pipeline now!")
