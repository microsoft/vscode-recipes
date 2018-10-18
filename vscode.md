# Authenticating to GitHub

## How to login to GitHub or GitHub Enterprise

1. In Visual Studio, select **Team Explorer** from the **View** menu.
    <a href="images/view_team_explorer.png?raw=true" target="_blank"><div><img src="images/view_team_explorer.png" alt="Team Explorer in the view menu" width="500px"/></div></a>
1. In the Team Explorer pane, click the **Manage Connectios** toolbar icon.
    <a href="images/manage_connections.png?raw=true" target="_blank"><div><img src="images/manage_connections.png" alt="Manage connections toolbar icon in the Team Explorer pane" width="500px"/></div></a>
1. Click the **Connect** link in the GitHub section.
        <a href="images/sign-in-to-github-provider.png?raw=true" target="_blank"><div><img src="images/sign-in-to-github-provider.png" alt="Connect to GitHub" height="300px"/></div></a>   

   If you're connected to a TFS instance, click on the **Sign in** link instead
   <a href="images/sign-in-to-github.png?raw=true" target="_blank"><div><img src="images/sign-in-to-github.png" alt="Sign in to GitHub" width="300px"/></div></a>  

   If none of these options are visible, click **Manage Connections** and then **Connect to GitHub**.  
   <a href="images/connect_to_github.png?raw=true" target="_blank"><div><img src="images/connect_to_github.png" alt="Connect to GitHub in the manage connections dropdown in the Team Explorer pane" width="500px"/></div></a>
1. In the **Connect to GitHub dialog** choose **GitHub** or **GitHub Enterprise**, depending on which product you're using.

**GitHub option**:
<a href="images/connect-to-github-dialog.png?raw=true" target="_blank"><div><img src="images/connect-to-github-dialog.png" alt="Connect to GitHub dialog view" height="400px"/></div></a>

- To sign in with credentials, enter either username or email and password.
- To sign in with SSO, select `Sign in with your browser`.

**GitHub Enterprise option**:  
<a href="images/connect-to-github-enterprise-dialog.png?raw=true" target="_blank"><div><img src="images/connect-to-github-enterprise-dialog.png" alt="Connect to GitHub Enterprise dialog view" height="400px"/></div></a>

- To sign in with SSO, enter the GitHub Enterprise server address and select `Sign in with your browser`.
- To sign in with credentials, enter the GitHub Enterprise server address.
   - If a `Password` field appears, enter your password.
   - If a `Token` field appears, enter a valid token. You can create personal access tokens by [following the instructions in the section below](#personal_access_tokens).

Before you authenticate, you must already have a GitHub or GitHub Enterprise account.

- For more information on creating a GitHub account, see "[Signing up for a new GitHub account](https://help.github.com/articles/signing-up-for-a-new-github-account/)".
- For a GitHub Enterprise account, contact your GitHub Enterprise site administrator.

### Personal access tokens

If all signin options above fail, you can manually create a personal access token and use it as your password.

The scopes for the personal access token are: `user`, `repo`, `gist`, and `write:public_key`. 
- *user* scope: Grants access to the user profile data. We currently use this to display your avatar and check whether your plans lets you publish private repositories.
- *repo* scope: Grants read/write access to code, commit statuses, invitations, collaborators, adding team memberships, and deployment statuses for public and private repositories and organizations. This is needed for all git network operations (push, pull, fetch), and for getting information about the repository you're currently working on.
- *gist* scope: Grants write access to gists. We use this in our gist feature, so you can highlight code and create gists directly from Visual Studio
- *write:public_key* scope: Grants access to creating, listing, and viewing details for public keys. This will allows us to add ssh support to your repositories, if you are unable to go through https (this feature is not available yet, this scope is optional)

For more information on creating personal access tokens, see "[Creating a personal access token for the command line](https://help.github.com/articles/creating-a-personal-access-token-for-the-command-line). 

For more information on authenticating with SAML single sign-on, see "[About authentication with SAML single sign-on](https://help.github.com/articles/about-authentication-with-saml-single-sign-on)."


