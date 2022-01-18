# Social-Media-System
Implementation of a social media system within bash scripts.

# System requirements
This system is a basic model of a social media system. The system allows the client to
create a user account, add friends, post to a friend’s wall and see their friends wall.
When creating a user, the system will only allow a username to be used once, therefore
if a user attempts to create a user with an already existing name, then an error message
will be prompted. A user may add friends as long as that friendship does not already
exist, it must be noted however that these relationships are not symmetric within the
system, and therefore A may be on B’s friends list, while B is not on A’s. A user will
only be able to post to the wall of someone they are friends with, but any user will be
able to see the wall of other users regardless of relationship status. The client will be
able to send requests to the server through the client application. This will all be done
by means of a communication system whereby the client will input a command and this
command will be sent to the server, within the server the instructions are executed, and
the results are sent back to the user in the form of a confirmation message in the case
of adding a friend, posting to a wall or creating a user. When the client requests to see
friends wall then the same communication process is executed, and the wall will be
displayed on the client side. The client will also be able to shut down the system, which
too will shut down the server.

# Create.sh
In order to create a user a new directory must be created and within this directory there
must be two files, named friends and wall. The most important element in creating this
script was to ensure that the user was notified in the case where an incorrect number of
parameters were entered, or whether a user already existed on the system, this script
takes one parameter. These two cases were covered using if statements and echo to
notify the user in this instance. If conditions for creating a user were satisfied then
mkdir was used to create a directory with whatever name that was inputted by the
user, then within this directory two files were immediately created using touch.

# Add.sh
The implementation of the add script was very similar to that of the create script, with
the shell of if else statements used once again to negate any instances where conditions
were not met. The number of parameters had to be exactly two, and therefore any
instance where this was not met, a message was displayed to notify the user. Similarly,
if either of the users inputted by the client did not exist, then a similar error message
was displayed using echo. In the case where the users were already friends, grep was
used to test whether or not the user name (second argument) was within the file friends
stored in the other user’s directory (first argument), if this was the case then once again
an error message was displayed. Finally, in the case where none of these conditions
existed the username was added to the list of friends by redirecting the second argument
(user to be added) using >> into the friends file of the other user.

# Post.sh
The structure of this script was the exact same as that of ‘add.sh’. In a very similar
fashion the number of parameters was checked first, to ensure that exactly three
arguments were given by the user. Then it was checked whether the users existed. Due
to the asymmetrical nature of the relationships, if the user wishing to post was not a
friend of the other user then they were not allowed post. This condition was checked
using grep once again to test whether or not the user was within the list of friends of
the other user, and if not, an error message was displayed. And very similar to add.sh
in the case where all of these conditions were met, then the user name and the message
were redirected to the other user’s wall file and a message was displayed to notify the
user that their requests have been executed successfully.

# Show.sh
This script displays the contents of a specified users wall. It takes one parameter (the
users name), any parameter problems were dealt with in a similar fashion to the
previously mentioned scripts. As well as this the user’s existence was checked too in
the same way. If all conditions were met, then the users wall contents were displayed
using cat, this is a standard utility.
It must be noted that within each of these scripts a lock was put on the files in use at
the beginning of each script using lockfile. This creates semaphore files, one for
each argument that was used within the script, these lockfiles were then deleted once
the script had been executed. This ensures that no two commands can access the same 
file concurrently, which in turn reduces inconsistencies that occur with concurrent
execution.

# Server.sh
The server scripts purpose is to set up the server pipe, execute the commands it receives
from the server pipe and then send the replies back to the client’s pipe. To do so the
first operation within the script is the creation of a pipe named server.pipe, this is where
the instructions of the client are sent. A while loop was created with a case statement
within. The instructions sent by the client are read from the server pipe and each
argument is assigned to a variable e.g. $request, $id where $request is one of the four
basic commands, and $id is the client id specified by the client on the client side. Using
the case statement, a particular command can be executed dependent on the request that
the client specifies. Each request is then executed with the arguments inputted by the
user on the client side and the output is redirected to the client pipe. The commands are
executed in the background, this was implemented by including an ampersand at the
end of each command. The server will continue to run until instructed by the user to
shut down, on shutdown the server.pipe is deleted. In the case of a bad request the
server.pipe is deleted and the server is shutdown.

# Client.sh
The client side scripts primary function is to redirect the requests from the user to the
server.pipe so as that it can then be executed and redirected back to the client pipe for
the user to see. The first operation of the client script is the creation of a client pipe that
is specific to the client id of the user. Similar to the first four scripts, this script is
comprised of if statements such that the conditions specified are met. Firstly, the
number of parameters is checked, a minimum of two and a maximum of five parameters
are allowed, if this condition is not met then the user will be notified. For requests
create, post and add, the users input (arguments) are redirected to the server pipe using
echo and >. The instructions are then executed on the server side and the output is
redirected to the specific client pipe. This output is the read from the pipe and using
echo the user is notified on the client side. If the request is show, then the output to the
named pipe must be processed before being displayed to the client. In order to remove
the ‘WallStart’ and ‘WallEnd’ tags that were displayed in the original script, the output
from the client pipe is concatenated using cat and then redirected to a file named show,
using sed the first and last line are removed to display only the posts on the wall. After
each execution of a request the client pipe is removed using rm. In the case that the
request is shutdown, then both the server and client pipes are exited, and the named
pipes are removed. It must be noted that when using these client and server sides, the
server side must be running before any client-side requests can be executed. 
 
The system is used by first beginning the server by executing the server.sh script, this
will begin an infinite loop that may only be shut down on the client side with a shutdown
request. Once the server side is ready, the client may input a request into the client
application as follows ‘./client.sh $clientID $request [args]’. The
specific client id ensures that a client pipe is created for that unique user to redirect any
output to the client application. The number of arguments is variable dependent on the
request the client wishes to execute, and the request is one of the five requests (add,
post, show, create, shutdown), in the case that a user attempts to request anything other
than these commands then an error is prompted. An example of a client request is: ./client.sh 1234 show Anthony
This specific request will be redirected to the server pipe and the server will read the
request and execute, producing an output containing the contents of Anthony’s wall,
this output is then redirected to the unique client pipe ‘1234.pipe’ and read by the client
application such that the user is displayed the contents of Anthony’s wall.
