# Base R Shiny image
FROM rocker/shiny

# Make a directory in the container
RUN mkdir /home/shiny-app

# Install R dependencies
RUN R -e "install.packages(c('Shiny'))"

# Copy the Shiny app code
COPY app.R /home/shiny-app/app.R

# Expose the application port
EXPOSE 3254

# Rodar o app Shiny
CMD ["R", "-e", "shiny::runApp('/home/shiny-app/app.R')"]



