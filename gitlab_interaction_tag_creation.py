import argparse
import gitlab

# https://python-gitlab.readthedocs.io/en/stable/gl_objects/projects.html#project-tags
def fetch_project_tags_from_gitlab_create_new_tag(gitlab_url, access_token_pjt, project_id,tag_name, branch_name):
    tags_available_list = None
    project = None
    try:
        with gitlab.Gitlab(gitlab_url, private_token=access_token_pjt) as gl:
            # Get a project by ID
            project = gl.projects.get(project_id)
            tags_available_list = [a.name for a in project.tags.list()]
            print("Fetching the tags available for the project are {}".format(tags_available_list))
    except (gitlab.exceptions.GitlabGetError, Exception) as e:
        pass
        # print(e)

    if tag_name in tags_available_list:
        print("Requested Tag - {} is already available for ECR Deploy commit message and in same we can have n number of ECR commits for pushing latest image to AWS ECR".format(tag_name))

        # Delete the tag name available for the day and create the same tag with updated commit info(last/latest commit of the day)
        project.tags.delete(tag_name)

        if tag_name not in [a.name for a in project.tags.list()]:
            # creating the new tag name for the project
            print("After Deletion ::: Fetching the tags available for the project are {}".format([a.name for a in project.tags.list()]))
            project.tags.create({'tag_name': tag_name, 'ref': branch_name})
            print("Same Tag Available with update of new commit message(after creation/updation of tag) -- Available Tags names list is {}".format([a.name for a in project.tags.list()]))
        else:
            raise Exception("Exception::: Tag Name - {} that is deleted is still available".format(tag_name))

    if tag_name not in tags_available_list:
        print("New tag name - {} is going to be created for the project".format(tag_name))
        print("Before New Tag Creation -- Available Tags names list is {}".format([a.name for a in project.tags.list()]))

        # creating the new tag name for the project
        project.tags.create({'tag_name': tag_name, 'ref': branch_name})
        import time
        time.sleep(2)
        print("After New Tag Creation -- Available Tags names list is {}".format([a.name for a in project.tags.list()]))

# fetch_project_tags_from_gitlab_create_new_tag(gitlab_url="https://gitlab.com", access_token_pjt="<Access token>", project_id='<project_id>', tag_name ="dev-08042020", branch_name="UAE")

##############################################################################################################################################################
# Usage with -u/gitURL::
# python gitlab_interaction.py -u "https://gitlab.com" -t "<access_token>" -pid "12739607" -tag "dev-08042020" -b "<branch_name>"
###############################################################################################################################################################

if __name__ == '__main__':

    parser = argparse.ArgumentParser(
        description='Receive Input for interact with Gitlab API in Gitlab CI/CD Interaction')

    parser.add_argument("-u", "--gitURL", action="store", help="Retrieves the Gitlab URL", default="https://gitlab.com",
                        type=str)

    parser.add_argument('-t', '--token', action='store', type=str,
                        help="Retrieves the Gitlab Access Token to access APIs available", required=True)

    parser.add_argument('-pid', '--pid', action='store', type=str, help="Provide associated Gitlab Project ID",
                        required=True)

    parser.add_argument('-tag', '--tag_name', action='store', type=str, help="Provide tag_name to create",
                        required=True)

    parser.add_argument('-b', '--branch_name', action='store', type=str, help="Branch Name to refer for tag creation",
                        required=True)

    args = parser.parse_args()

    if args.gitURL and args.token and args.pid and args.tag_name and args.branch_name:
        fetch_project_tags_from_gitlab_create_new_tag(args.gitURL, args.token, args.pid, args.tag_name, args.branch_name)
    else:
        print("Error in passing ArgParse Commandline Utility or error getting the inputs from the commandline..So please check")
