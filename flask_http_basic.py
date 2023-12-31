from flask import Flask
from flask_httpauth import HTTPBasicAuth
from werkzeug.security import generate_password_hash, check_password_hash

api = Flask(import_name='my_api'  )
auth = HTTPBasicAuth()

users = {
    "daniel": {
        'password' : generate_password_hash("datascientest"),
        'private' : 'Private Resource Daniel',
        'role' : ['admin', 'user']
    },
    "john": {
        'password' : generate_password_hash("secret"),
        'private' : 'Private Resource John',
        'role' : 'user'
    }
}

@auth.verify_password
def verify_password(username, password):
    if username in users and check_password_hash(users.get(username)['password'], password):
        return username
    
    
@auth.get_user_roles
def get_user_roles(user):
    return users.get(user)['role']

@api.route('/admin')
@auth.login_required(role='admin')
def admin():
    """
    Description:
    Cette route est accessible uniquement par les utilisateurs ayant le rôle 'admin'. Elle affiche un message de bienvenue spécifique aux administrateurs.

    Args:
    Aucun argument requis.

    Returns:
    - str: Un message de bienvenue pour l'administrateur actuellement authentifié.

    Raises:
    - HTTPException(401, detail="Unauthorized"): Si l'utilisateur n'est pas authentifié ou n'a pas le rôle 'admin', une exception HTTP 401 Unauthorized est levée.
    """

    return "Hello {}, vous êtes admin!".format(auth.current_user())

@api.route('/')
@auth.login_required(role='user')
def index():
    """
    Description:
    Cette route est accessible uniquement par les utilisateurs ayant le rôle 'user'. Elle affiche un message de bienvenue générique.

    Args:
    Aucun argument requis.

    Returns:
    - str: Un message de bienvenue pour l'utilisateur actuellement authentifié.

    Raises:
    - HTTPException(401, detail="Unauthorized"): Si l'utilisateur n'est pas authentifié ou n'a pas le rôle 'user', une exception HTTP 401 Unauthorized est levée.
    """

    return "Hello, {}!".format(auth.current_user())

@api.route('/private')
@auth.login_required(role='user')
def private():
    """
    Description:
    Cette route est accessible uniquement par les utilisateurs ayant le rôle 'user'. Elle affiche des informations privées de l'utilisateur.

    Args:
    Aucun argument requis.

    Returns:
    - str: Les informations privées de l'utilisateur actuellement authentifié.

    Raises:
    - HTTPException(401, detail="Unauthorized"): Si l'utilisateur n'est pas authentifié ou n'a pas le rôle 'user', une exception HTTP 401 Unauthorized est levée.
    """

    return "Resource : {}".format(users[auth.current_user()]['private'])

if __name__ == '__main__':
    api.run()