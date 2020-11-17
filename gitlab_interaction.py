import argparse
import gitlab
import os

def gitlab_upload_attachment_comment_notes_in_issue(gitlab_url,access_token_pjt,project_id,issue_id,file_absoluete_path):
    get_uploaded_file_url = []
    with gitlab.Gitlab(gitlab_url, private_token=access_token_pjt) as gl:
        #projects = gl.projects.list()
        #print(projects)
        # Get a project by ID
        project = gl.projects.get(project_id)
        #print(project)
        for root,directory,files in os.walk(r"{}".format(file_absoluete_path)):
            for file in files:
                if '.html' in file:
                    uploaded_file = project.upload(file,filepath=os.path.join(root, file))
                    if uploaded_file:
                        get_uploaded_file_url.append(uploaded_file["url"])
                else:
                    print("There is a issue in uploading the file and the filename is {}".format(file))
        print("Uploaded file url is {}".format(get_uploaded_file_url))            
        issue = project.issues.get(issue_id)
        if len(get_uploaded_file_url)!=0:  
            created_note_status = issue.notes.create({
                "body": '\n'.join("Attached Report for {}\n\n [{}]({})\n".format(url.split("/")[-1].split('.html')[0][:-11],url.split("/")[-1],url) for url in get_uploaded_file_url)
            })
            
            if created_note_status:
                print("Comment and File Uploaded")
            else:
                print("Problem uploading the Comment and File")

#gitlab_url = "https://gitlab.com"
#project_id = "345666"
#issue_id = '6'
#access_token_pjt='<access_token>'
#file_absoluete_path = r"Content_API-master\tests\results\smoke"

##############################################################################################################################################################
#Usage without -u/gitURL::
                
#python gitlab_interaction.py -t "<access_token>" -pid "12127631" -id "6" \
                                  #-file "Base_Content_API-master\tests\results\smoke"

#Usage with -u/gitURL::

#python gitlab_interaction.py -u "https://gitlab.com" -t "<access_token>" -pid "23444" -id "6" \
                                  #-file "Base_Content_API-master\tests\results\smoke"

###############################################################################################################################################################

if __name__ == '__main__':

    parser = argparse.ArgumentParser(description='Receive Input for interact with Gitlab API in Gitlab CI/CD Interaction')
    
    parser.add_argument("-u", "--gitURL", action="store",help="Retrieves the Gitlab URL",default="https://gitlab.com",type=str)

    parser.add_argument('-t', '--token', action='store', type=str,help="Retrieves the Gitlab Access Token to access APIs available",required=True)

    parser.add_argument('-pid', '--pid', action='store', type=str,help="Retrieves the Gitlab Project ID",required=True)

    parser.add_argument('-id', '--iid', action='store', type=str,help="Retrieves the Gitlab Issue ID to access",required=True)

    parser.add_argument('-file', '--filePath', action='store', type=str,help="Retrieves the Gitlab Issue ID to access",required=True)

    args = parser.parse_args()
    
    if args.gitURL and args.token and args.pid and args.iid and args.filePath:
        gitlab_upload_attachment_comment_notes_in_issue(args.gitURL,args.token,args.pid,args.iid,args.filePath)
    else:
        print("Error in passing ArgParse Commandline Utility or error getting the inputs from the commandline..So please check")
        
