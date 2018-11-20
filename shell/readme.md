- input and output,user input
- if
- exit statues
- functions
- wildcards
- for loops
- case statements
- logging
- debugging tips
- bash shell options
- more
--------------------------------

- download \
shell-script-course/debugging/lessons \
shell-script-course/debugging/practice-exercies

- learn \
1 use variable \
2 perform tests and make decisions \
3 accept command line arguments \
4 accept input from a user 

# demo 
```bash
    #!/bin/bash 
    echo "scripting is fun!" 
    --------------------------    
    chmod 755 script.sh 
    ./script.sh
```


# not just shell script
```bash
    #!/usr/bin/python 
    print "this is a python script" 
    ------------------------------
    chmod 755 hi.py 
    ./hi.py
```

# Variables
- storage locations that have a name 
- name-value pairs 
- uppercase,case sensitive 
- VARIABLE_NAME="Value"

#### Variable Usage
```bash
    #!/bin/bash 
    MY_SHELL="bash" 
    echo "I like the $MY_SHELL shell."
```
```bash
    #!/bin/bash 
    MY_SHELL="bash"
    echo "I like the ${MY_SHELL} shell."
```
```bash
    #!/bin/bash
    MY_SHELL="bash"
    echo "I am ${MY_SHELL}ing on my keyboard."
    
    OUTPUT:
    I am bashing on my keyboard.
```

```bash
    #!/bin/bash
    MY_SHELL="bash"
    echo "I am $MY_SHELLing on my keyboard."
    
    OUTPUT:
    I am  on my keyboard.
```

```bash
    #!/bin/bash
    SERVER_NAME=$(hostname)
    echo "you are running this script on ${SERVER_NAME}."
    
    OUTPUT:
    you are running this script on linuxsvr.
```

```bash
    #!/bin/bash
    SERVER_NAME=`hostname`
    echo "you are running this script on ${SERVER_NAME}."
    
    OUTPUT:
    you are running this script on linuxsvr.
```
#### Variable Names（等号前后不能有空格）
- valid:
    - FIRST3LETTERS="ABC"
    - FIRST_THREE_LETTERS="ABC"
    - firstThreeLetters="ABC"
    
- Invalid:
    - 3LETTERS="ABC"
    - first-three-letters="ABC"
    - first@Three@Letters="ABC"
    
# Tests：success:0 failed:1
- Syntax:
   - [ condition-to-test-for ]
- Example:
   - [ -e /etc/passwd ]
   
# File operators(tests)
```bash
    -d FILE     ture if file is directory.
    -e FILE     true if file exists.   
    -f FILE     true if file exists and is a regular file
    -r FILE     true if file is readable by you
    -s FILE     true if file exists and is not empty.
    -w FILE     true if file is writable to you.
    -x FILE     true is file is executable by you.
```
# String operators(tests)
```bash
    -z STRING   true if string is empty.
    -n STRING   true if string is not empty.
    STRING1=STRING2     true is the strings are equal.
    STRING1!=STRING2    true is the strings are not equal.
```
# Arithmetic operators(tests)
```bash
    arg1 -eq arg2
    arg1 -ne arg2
    
    arg1 -lt arg2
    arg1 -le arg2
    
    arg1 -gt arg2
    arg1 -ge arg2
```
# Making Decisions - The if statement
```bash
    if [ condiction-is-true ]
    then
        command 1
        command 2
        command N
    fi
```
```bash
    #!/bin/bash
    MY_SHELL="bash"
    if [ "$MY_SHELL" = "bash" ]
    then
        echo "you seen to like the bash shell."
    fi
    
    OUTPUT:
    you seen to like the bash shell.
```
# if/else
```bash
    if [ condition-is-true ]
    then
        command N
    else
        command N
    fi
```
```bash
    #!/bin/bash
    MY_SHELL="csh"
    if [ "$MY_SHELL" = "bash" ]
    then
        echo "you seem to like bash shell."
    else
        echo "you don't seem to like bash shell."
    fi
```
# if/elif/else
```bash
    if [ condiction-is-true ]
    then
        command N
    elif [ condition-is-true ]
    then
        command N
    else 
        command N
    fi  
```
```bash
    #!/bin/bash
    MY_SHELL="csh"
    if [ "$MY_SHELL" = "bash" ]
    then
        echo "you seem to like bash shell."
    elif [ "$MY_SHELL" = "csh" ]
    then
        echo "you don't seem to like csh shell."
    else
        echo "you don't seem to like csh or bash shells."
    fi
```
# For loop
```bash
    for VARIABLE_NAME in ITEM1 ITEM_N
    do
        command 1
        command 2
        command N
    done    
```

````bash
    #!/bin/bash
    for COLOR in red green blue
    do
        echo "COLOR: $COLOR"
    done
   OUTPUT:
   COLOR: red
   COLOR: green
   COLOR: blue
````
````bash
    #!/bin/bash
    COLORS="red green blue"
    
    for COLOR in $COLORS
    do
        echo "COLOR: $COLOR"
    done
   OUTPUT:
   COLOR: red
   COLOR: green
   COLOR: blue
````
```bash
    #!/bin/bash
    PICTURES=$(ls *jpg)
    DATE=$(date +%F)
    for PICTURE in $PICTURES
    do
        echo "Renaming ${PICTURE} to ${DATE}-${PICTURE}"
        mv ${PICTURE} ${DATE}-${PICTURE}
    done
    
    OUTPUT:
    $ ls
    bear.jpg
    $ ./rename-pics.sh
    Renaming bear.jpg to 2015-03-06-bear.jpg
    $ ls
    2015-03-06-bear.jpg 
```
# parameters $0 - $9
- todo

# Exit statuses
- how to check the exit status of a command
- how to make decisions based on the status
- how to use exit statuses in your own scripts

####  Exit Status / Return Code
- Every command returns an exit status
- Range from 0 to 255
- 0 = success
- Other than 0 = error condition
- Use for error checking
- Use man or info to find meaning of exit status

#### Checking the exit status
- $? contains the return code of the previously executed command.

```bash
    ls /not/here
    echo "$?"
    
    OUTPUT:
    2
```
```bash
    HOST="google.com"
    ping -c l $HOST
    if [ "$?" -eq "0" ]
    then
        echo "$HOST reachable."
    else
        echo "$HOST unreachable."
    fi     
```
```bash
    HOST="google.com"
    ping -c l $HOST
    if [ "$?" -nq "0" ]
    then
        echo "$HOST unreachable."
    fi     
```
```bash
    HOST="google.com"
    ping -c l $HOST
    RETURN_CODE=$?
    
    if [ "$RETURN_CODE" -ne "0" ]
    then
        echo "$HOST unreachable."
    fi     
```
#### && and ||
- && = AND (前一个是true，后一个才会执行)
```bash
    mkdir /tmp/bak && cp test.txt /tmp/bak/
```

- || = OR (前一个是false，后一个才会执行)
```bash
    cp test.txt /tmp/bak/ || cp test.txt /tmp
```
```bash
    #!/bin/bash
    HOST="google.com"
    ping -c l $HOST && echo "$HOST reachable."
```

```bash
    #!/bin/bash
    HOST="google.com"
    ping -c l $HOST || echo "$HOST unreachable."
```

#### The semicolon ; 
- separate commands with a semicolon to ensure they all get executed.
- 和前一个命令是否成功无关，命令都会被执行，和换行是一个意思
```bash
    cp test.txt /tmp/bk/ ; cp test.txt /tmp
    #Same as:
    cp test.txt /tmp/bk/
    cp test.txt /tmp
```

#### Exit command
- Explicitly define the return code
    - exit 0 -- 255
- the default value is that of the last command executed
- 脚本的任何地方都可以使用exit命令

```bash
    HOST="google.com"
    ping -v 1 $HOST
    if [ "$?" -ne "0" ]
    then
        echo "$HOST unreachable."
        exit 1
    fi
    exit 0
```

#### Summary
- all command return an exit status
- 0 - 255
- 0 = success
- other than 0 = error condition
- $? contains the exit status
- Decision making -if , &&, ||
- exit

# Functions
- why to use functions
- how to create them
- how to use them
- variable scope
- function parameters
- exit statuses and return codes

#### Functions
- if you're repeating yourself ,use a function.
- reusable code
- must be defined before use
- has parameter support

```bash
    function function-name(){
        #code goes here
      }
    
    function-name(){
        #code goes here
    }
    
    #!/bin/bash
    function hello(){
        echo "Hello!"
    }
    hello
```
```bash
    #!/bin/bash
    function hello(){
        echo "hello！"
        now
    }
    function now(){
        echo "It's $(date +%r)"
    }
    hello
```

```bash
    #!/bin/bash
    function hello(){
        echo "hello！"
        now
    }
    hello # 会报错的
    function now(){
        echo "It's $(date +%r)"
    }

```

#### Positional Parameters
- functions can accept parameters
- the first parameter is stored in $1
- the second parameter is stored in $2, etc.
- $@ contains all of the parameters
- just like shell scripts.
    - $0 = the script itself, not function name
    
    
```bash
    #!/bin/bash
    function hello(){
        echo "Hello $1"
    }
    hello Jason
    
    # OUTPUT:
    # Hello Jason
```

```bash
    #!/bin/bash
    function hello(){
        for NAME in $@
        do  
            echo "hello $NAME"
        done
    }
    
    hello jason dan ryan
    # OUTPUT:
    # Hello jason
    # Hello dan
    # Hello v    
```
#### variable scope
- by default, variables are global
- variable have to be defined before used.
```bash
    GLOBAL_VAR=1
    # GLOBAL_VAL is available
    # in the function.
    my_function
```
```bash
    # GLOBAL_VAL is NOT available
    # in the function.
    my_function
    GLOBAL_VAR=1
```

```bash
    #!/bin/bash
    my_function(){
       GLOBAL_VAR=1 
    }
    
    # GLOBAL_VAL is NOT available yet
    echo $GLOBAL_VAR
    my_function
    # GLOBAL_VAL is NOW available yet
    echo $GLOBAL_VAR
```

#### local Variables
- can only be accessed within the function.
- create using the local keyword
    - local LOCAL_VAR=1
- only functions can have local variables
- best practice to keep variables local in functions
    
#### Exit Status(Return Code)
- functions have an exit status
- explicitly
    - return <RETURN_CODE>
    
- Implicity
    - the exit status of the last command executed in the function    

- Valid exit codes range from 0- 255
- 0 = success
- $?=the exit status

```bash
    my_function
    echo $?
```

```bash
    # todo :.
```

#### Summary
- DRY(don't repeat yourself)
- global and local variables
- parameters
- exit statuses

#Wildcards
- *-matches zero or more characters
    - *.txt
    - a*
    - a*.txt
    
- ?-matches exactly one character
    - ?.txt   
    - a?
    - a?.txt
     
# More Wildcards-Character Classes
- []- a character class
    - matches any of the characters include between the brackets. 
        matches exactly one character.
    - [aeiou]
    - ca[nt]*
        - can
        - cat
        - candy
        - catch

- [!]- matches any of the characters NOT included between the brackets. 
        matches exactly one character
    - [!aeiou]*
        - baseball
        - cricket
                  
#### more wildcards - Ranges
- User two characters separated by hyphen to create range in a
    character class.
- [a-g]*
    - matches all files that start with a,b,c,...g
           
- [3-6]*
    - matches all files that start with 3,4,5,6
        
#### Name character class
- [[:alpha:]] 字母
- [[:alnum:]] 数字字母
- [[:digit:]] 数字
- [[:lower:]] 小写字母
- [[:space:]] 字符
- [[:upper:]] 大写字母

#### Mathching wildcard patterns
- \-escape character. use if you want to match a wildcard 
    character
    - match all files that end with a question mark:
        - *\?
            - done？
            
#### summary
- *
- ?
- []
- [0-3]
- [[:digit:]] 

#### why use wildcards?
- wildcards are great when you want to work on a group of files or directories.
```bash
    #!/bin/bash
    cd /var/www
    cp *.html /var/www-just-html
```

```bash
    #!/bin/bash
    cd /var/www
    for FILE in *.html
    do
        echo "copy $FILE"
        cp $FILE /var/www-just-html
    done
    
    OUTPUT:
    copy about.html
    copy content.html
    copy index.html
```

```bash
    #!/bin/bash
    
    for FILE in /var/www/*.html
    do
        echo "copy $FILE"
        cp $FILE /var/www-just-html
    done
    
    OUTPUT:
    copy /var/www/about.html
    copy /var/www/content.html
    copy /var/www/index.html
```
#### summary
- just like on the command line.
- in loops
- supply a directory in the wildcard or use the cd command to change the current directory

# Case Statements
- alternative to if statements
    - if ["$VAR"="one"]
    - elif ["$VAR"="two"]
    - elif ["$VAR"="three"]
    - elif ["$VAR"="four"]
- may be easier to read than complex if statements

```bash
case "$VAR" in
    pattern_1)
        # commands go here
        ;;
    patter_N)
        # commands go here    
        ;;
esac
```

```bash
    case "$1" in
        start)
            /usr/sbin/sshd
            ;;
        stop)
            kill $(cat /var/run/sshd.pid)
            ;;
    esac           
```

```bash
    case "$1" in
        start)
            /usr/sbin/sshd
            ;;
        stop)
            kill $(cat /var/run/sshd.pid)
            ;;
        *)
            echo "Usage: $0 start|stop" ; exit 1
            ;;    
    esac           
```

```bash
    case "$1" in
        start|START)
            /usr/sbin/sshd
            ;;
        stop|STOP)
            kill $(cat /var/run/sshd.pid)
            ;;
        *)
            echo "Usage: $0 start|stop" ; exit 1
            ;;    
    esac           
```
```bash
    read -p "Enter y or n: " ANSWER
    case "$ANSWER" in
        [yY]|[yY][eE][sS])
            echo "your answered yes."
            ;;
        [nN]|[nN][oO])
            echo "your answered no."
            ;;
        *)
            echo "Invalid answer."
        ;;
     esac                   
```

```bash
    read -p "Enter y or n: " ANSWER
    case "$ANSWER" in
        [yY]*)
            echo "your answered yes."
            ;;
        *)
            echo "Invalid answer."
        ;;
     esac                   
```

#### summary
- can be used in place of if statements.
- patterns can include wildcards.
- multiple pattern matching using a pipe.


# Logging
#### what you will learn
- why log
- Syslog standard
- Generating log messages
- Custom logging functions

#### Logging
- Logs are the who ,what , when, where ,and why
- Output may scroll of the screen
- Script may run unattended(via cron, etc)

####
````bash
todo:
````
#### summary
- Why log
- syslog standard
- Generating log messages
- Custom logging functions

# while loops
- what you will learn
- while loops
- infinite loops
- loop control
    - explicit number of times
    - user input
    - command exit status
- reading files, line-by-line
- break and continue
```bash
    while [ condition_is _true ]
    do
        command 1
        command 2
        command N
    done
```

```bash
    while [ condition_is_true ]
    do
        # commands change the condition
        command 1
        command 2
        command N
    done
```        
        
#### infinite loops
```bash
    while [ condition_is_true ]
    do
        # commands do not change
        # the condition
        command N  
    done
```





























    
    











