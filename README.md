# Klarna IGE 2019 Exercise

Calculate and visualize CO2 emission data

## Prerequisites

Firstly we need you to bring your laptops! :-) The project should ideally work on all the operating systems.

### IDE / Text Editor for Coding

In case you don't have any editor installed, I'd recommend you to download and install [Sublime Text 3](https://www.sublimetext.com/3), it's free and compatible with ruby by default.

For those who are using Windows, it's preferable to use [PowerShell](https://en.wikipedia.org/wiki/PowerShell) and [Terminal](https://macpaw.com/how-to/use-terminal-on-mac) on MacOS.

### Git Clone / Download this project

#### If you are using a Mac book / windows with [powershell](https://en.wikipedia.org/wiki/PowerShell)
Git is a version control system that allows you to smooothly cooperate with others.

To install Git, follow the instructions on this page: [Install Git](https://www.atlassian.com/git/tutorials/install-git) (you will need to scroll down to see instructions for windows)

Once you are done with the installation, do:
```
git clone https://github.com/fdfzcq/klarna-ige-exercise-smashing.git && cd klarna-ige-exercise-smashing
```
#### If you don't have powershell or a Mac book

Download and unzip the zip file from [here](https://github.com/fdfzcq/klarna-ige-exercise-smashing/archive/master.zip)

---
### Docker

Docker is a program used for operating-system-level virtualization. It allows you to run programs in a neatly segregated environment also known as a container. It will save you the hustle of installing ruby and smashing, as well as setting up all the system variables required.

To install docker you need to register a new account on DockerHub, instructions can be found for different operating systems:
* [Docker for mac](https://docs.docker.com/docker-for-mac/install/)
* [Docker for windows](https://docs.docker.com/docker-for-windows/install/)
* [Docker for ubuntu](https://docs.docker.com/install/linux/docker-ce/ubuntu/)

When docker is readily installed, you can run the following command in your klarna-ige-exercise-smashing directory:
```
docker build -t klarna-ige-sl-dashboard .
```
This will build a new image with the name 'klarna-ige-exercise-smashing:latest' locally.

Then you can run the docker image by using this command:
````
docker run -p 3030:3030 klarna-ige-exercise-smashing:latest
````
Note that the program may throw some errors at the first time and here comes the fun part: 

### You need to fix it!

There are several TODOs in jobs/co2_emission.rb, and your task is to implement the TODOs. Among which are two bonus TODOs, the program will work without those pieces of code, but they might be fun to try out if you have extra time left!

Note that you need to build a new image each time you make change to the project.
If docker doesn't work, you can install ruby and smashing instead.
Don't be shy to ask for help if you have any questions!

#### hints:
* You need to fill in the API key
* You need to populate some fields in the code to make it work
