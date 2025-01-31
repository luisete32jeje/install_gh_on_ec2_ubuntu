COMO AÑADIR USUARIO EN LDAP

Lo primero entrar al bootstrap y añadir el usuario siguiendo la sintaxis de los añadidos anteriormente, con el mismo unit name, organización...

# user: Luis Aragon for unit IT department
dn: uid=luis.aragon,ou=IT,dc=example,dc=org
changetype: add
objectClass: inetOrgPerson
cn: Luis Aragon
sn: Aragon
uid: luis.aragon
mail: luis.aragon@example.org
userPassword: password789

Despues de eso ldapadd -x -D "cn=admin,dc=example,dc=org" -W -f bootstrap.ldif, aunque creo que no es completamente necesario.
Por precaución tambien hice 'docker compose down' y después 'docker compose up -d'

Y luego iniciar sesión con el usuario y contraseña creada recientemente.

