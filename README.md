TapDiff: Novel Visualization Tool to Show Differences Between Trigger-Action Programs
===
# Introduction

This is the artifact for the paper “Understanding Trigger-Action Programs Through Novel Visualizations of Program Differences” ([link](https://www.blaseur.com/papers/chi21-diff.pdf)) published in [CHI 2021](https://chi2021.acm.org/). It includes both the software we developed and the data from our user studies. The purpose of distributing this artifact are: 
 - To open-source the interfaces we built to show TAP differences
 - To reproduce the pages participants saw in our user study mentioned in the paper
 - To publish results and analysis we got from our user study

# The TapDiff software
The software TapDiff composes of several interfaces that allows novel end-users to compare Trigger-Action programs in their smart homes. It includes a traditional interface that shows only syntax differences in programs, a novel interface that identify differences in program outcomes, and a novel interface showing different abstract properties of the programs. 

This repository consists of TapDiff as a web-application. There are four components - a database, a backend, a frontend and an Nginx proxy server - that supports this web-application. The following instructions will show how to set up a local server and play with TapDiff.

## Install pre-requisites
 - docker
 - docker-compose

Please follow the instructions on https://docs.docker.com/compose/install/ to install both docker and docker-compose.

## Start a local server
Before setting up the server, make sure that port 80 is not occupied by other processes. Our web-server runs on port 80.

Go into the repository and and run:
```console
user@host:/path/to/this/repo$ ./start-dev.sh --data data/userstudy.sql
```
The sql "userstudy.sql" consists of the TAP-rules and tasks we used in our user study. Please wait until the following statement 
appears:
```
frontend_1  | ℹ ｢wdm｣: Compiled successfully.
```

## Checkout the tutorials and tasks in our user study with our interfaces

After the local server has started, visit the following urls in your browser to see the tasks in our user study under our interfaces. Note that you need to replace ${INTERFACE} with specific interface names in the table.
 - **1-Straightforward**: localhost/testuser/1/${INTERFACE}?save-style=yesorno
 - **2-Simple Logic**: localhost/testuser/2/${INTERFACE}?save-style=selectfromtwo
 - **3-Redundant Programs**: localhost/testuser/3/${INTERFACE}?save-style=yesorno
 - **4-Hidden Similarity**: localhost/testuser/4/${INTERFACE}?save-style=selectfromtwo
 - **5-27 Variants**: localhost/testuser/7/${INTERFACE}
 - **6-Abstraction**: localhost/testuser/12/${INTERFACE}?save-style=selectfromtwo

${INTERFACE} | Description in the paper
--- | ---
singleview | Rules (only showing rules)
splitdiff | Text-Diff (highlighting text diffs like GitHub)
timelinediff | Outcome-Diff: Flowcharts (displaying all situations where outcomes differ in flowcharts)
mcdiff | Outcome-Diff: Questions (asking users to select their desired outcomes for situations)
spdiff | Property-Diff (extracting high-level properties programs hold)

You can also visit the following urls to see the interface tutorials that the user study participants saw:
 - **Rules**: localhost/testuser/887/singleview?tutorial=true&save-style=selectfromtwo
 - **Text-Diff**: localhost/testuser/889/splitdiff?tutorial=true&save-style=selectfromtwo
 - **Outcome-Diff: Flowcharts**: localhost/testuser/887/timelinediff?tutorial=true&save-style=selectfromtwo
 - **Outcome-Diff: Questions**: localhost/testuser/885/spdiff?tutorial=true&save-style=selectfromtwo
 - **Property-Diff**: localhost/testuser/881/mcdiff?tutorial=true

## License
> Copyright (C) 2018-2021  Valerie Zhao, Lefan Zhang, Bo Wang, Weijia He

TapDiff is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

TapDiff is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with TapDiff.  If not, see <https://www.gnu.org/licenses/>.


# User study
We provide the user study data in the file "data/prgmdiff_results.csv". Explanations about its column headers are listed in "header_explanations.csv". The survey is available in the appendix at https://www.blaseur.com/papers/chi21-programdiff-appendix.pdf. The statistical analysis script is "data/analyze.R".


# Contact
If you have any further questions about the software or the study, please contact Valerie Zhao (vzhao@uchicago.edu).


# Citation
Valerie Zhao, Lefan Zhang, Bo Wang, Michael L. Littman, Shan Lu, and Blase Ur. 2021. Understanding Trigger-Action Programs Through Novel Visualizations of Program Differences. *Proceedings of the 2021 CHI Conference on Human Factors in Computing Systems*. Association for Computing Machinery, New York, NY, USA, Article 312, 1–17. DOI:https://doi.org/10.1145/3411764.3445567