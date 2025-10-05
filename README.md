# utilx

Linux tools and scripts usefull to manage boxes and executing commands. Started to be a practise bash scripts. Scripts to agile day by day tasks for users.

# Files

## Apache

- Scripts to get active connections.
- Check running web servers.

## Certificates and Private / Public Keys

Several scripts (cert-*.sh) made to:

- Create and manage keystores.
- Import certificates and keys to keystores.
- Keystore migration between JCEKS, JKS, PKCS11, PKCS12 formats.
- Create PFX files from certificates and keys.
- Convert PEM to DER.
- Extract certificates and keys fom PFX file.
- Extract certificates and keys from P7B2.

Some filenames end with "-rsa" to indicate that keys are created or exported using rsa encryption.
In future releases will be added equivalent to use elliptic curve (EC).

## git

- git-pull-p.sh: Execute git pull from any other directory / folder.
- git-pull-r.sh: Execute git pull recursively for directores containing git repositories.
- git-set-env-nopass.sh: When you execute git pull in a repo protected by a secret and you do not want to stop for secret, skipping in these cases.

## postgres

Scripts for:

- Database creation.
- Maintenance, Analysis and Index.
- Backup and Restore.

In order to allow executing the same postgres commands in a machine with different postgres versions, the scripts has a "-v-" in the name and one of the arguments is the version. The scripts assume that postgres is installed from official repo.

## Remote command execution

- rcmd.sh
- rcmd-bulk.sh

These scripts execute remote command in a remote Unix / Linux machine using ssh. The script rcmd-bulk.sh use the command in a bulk mode through the machines listed in a input file supplied as an argument.
The first argument is always the user for execution in the remote machine, the second is the host or input file with hosts list, and at the end is the command to execute.

## scp execution in bulk mode (run in several machines)

- scp-bulk.sh
- scp-bulk-r.sh

These are the same. The difference is only related to copy the files recursively. The syntax is the one as scp command. Two files were created only for simplicity.

The parameters once more are:

- User in the remote machine to login.
- Input filename for hosts list.
- Destination path in the remote machine.
- Sources files or path in the local machine to copy.

Note: Opposite to standard in the Unix / Linux machines copy / move or similar commands related, where the destination is the last path as argument, here destination and source are switched in the position. This was made to permit and simplify the way user fill the source files and paths to copy.

## ssh id copy for several machines

### ssh-copy-id-bulk.sh

Using a hosts input file as used in rcmd and scp scripts, copy ssh key to remote machines for ssh remote login.

## ACL management

There are several scripts, setacl*.sh, to manage the acl for files and paths. These scripts in the beginning were created for security and access concerns, because all the time **SECURITY** was the main objective. Meanwhile readling a lot of information and manuals about acl in Linux, I concluded that there are many information out there that can lead to erroneous results. So many tests were made that led to these scripts and bypass one issue that for me, setfacl command is missing, and this is not having an option to distinguish object types like directory or file.

Scripts filename format:

- setacls*.sh. Scripts to set acl for several users and groups acl for a path or file.
- setacl-def*.sh. Manage default acl for several paths.
- setacl-u*.sh. Set acl for user for several paths.
- setacl-g*.sh. Set acl for group for several paths.
- setacl-m*.sh. Set acl mask for several paths.

The scripts also as an parameter to indicate if mask should be recalculated or not. In bulk mode, executing setfacl commands in a sequence, can be useful to speed up. Beside, in some situations, can be useful to set the mask based on user / owner permissions and not based in group mask which is the default behaviour for setfacl / acl in Linux.

- setacl-remove-all.sh. Remove all acl definitions, including default acl, from path or paths.

The following scripts execute setfacl for user (-u-) or group (-g-) applying only for directories or files.

- setacl-u-r-dirsonly.sh
- setacl-u-r-filesonly.sh
- setacl-g-r-dirsonly.sh
- setacl-g-r-filesonly.sh

## Others

### find-useful-queries.sh

Script to check permissions in a several ways. This begin to be a first approach to find unnecessary permissions or security holes.

- Permissions for others.
- Write group permission where user does not have that permission.
- Execute group permission where user does not have that permission.

More scripts related to security can be find in admx (https://github.com/jchurrocarvalho/admx) project

# Format for input of hosts list
(used also in https://github.com/jchurrocarvalho/admx project)

This format is now used in scripts for remote commands execution such as rcmd-bulk.sh and scp-bulk*.sh.

The format of the files used as input for such commands are simple as text files with 3 simples rules:

- Prefix "P" to indicate the port. Any number after "P" until "H" or another char (not number) will be assumed as the port where ssh is listening.
- Prefix "H". After it is a string until end of line or until space char to indicate the host.
- If prefix "P" is not present in the line, the ssh default port is assumed (22).

I know this is a very basic "format", but it was useful to rapidly build a way for automatization of several maintenance tasks as security updates, certificates updates, log monitoring, etc …
So think this as a starting point. In the **TODO** list is included in future release, to adopt a json format somehow standard for hosts list.

Products to see:

- glpi
- wazuh
- otrs
- Other CMDB tool, or asset manager

# TODO
(For now ...)

- Introduce the json format for reading host list.
- Add elliptic curve (EC) for key creation.

