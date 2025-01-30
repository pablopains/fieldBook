# get shiny serves plus tidyverse packages image
FROM rocker/shiny-verse:latest

# system libraries of general use
RUN apt-get update && apt-get install -y \
    sudo \
    pandoc \
    pandoc-citeproc \
    libcurl4-gnutls-dev \
    libcairo2-dev \
    libxt-dev \
    libssl-dev \
    libssh2-1-dev

##Install R packages that are required--> were already succesfull
RUN R -e "install.packages(c('shinydashboard','shiny', 'plotly', 'dplyr', 'magrittr'))"

#Heatmap related packages
RUN R -e "install.packages('gpclib', type='source')"
RUN R -e "install.packages('rgeos', type='source')"
RUN R -e "install.packages('rgdal', type='source')"

# copy app to image
COPY ./App /srv/shiny-server/App

# add .conf file to image/container to preserve log file
COPY ./shiny-server.conf  /etc/shiny-server/shiny-server.conf


##When run image and create a container, this container will listen on port 3838
EXPOSE 3838

###Avoiding running as root --> run container as user instead
# allow permission
RUN sudo chown -R shiny:shiny /srv/shiny-server
# execute in the following as user --> imortant to give permission before that step
USER shiny

##run app
CMD ["/usr/bin/shiny-server.sh"]