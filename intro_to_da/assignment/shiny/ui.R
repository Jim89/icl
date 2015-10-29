# etwork Data Exploration Shiny Application ---------------------------------------


# set up -----------------------------------------------------------------------
# load packages that will be used for the application
library(shiny)
library(shiny)
library(networkD3)
library(igraph)
library(readxl)
library(dplyr)
library(magrittr)

# Set up the application ui
shinyUI(navbarPage("Social network data explorer",
                   
tabPanel("3779",
  sidebarLayout(
    sidebarPanel(
      h1("Information"),
      p("This simple network diagram represents student responses to the question:"),
      br(),
      strong("'Imagine you have been invited to join a team that will meet urgently as needed to rally student support for your graduation week celebration plan when it faces resistance. Select up to 6 people to join you in this task.'"),
      br(),
      br(),
      p("Students are represented by individual circles on this diagram (anonymously labelled with numbers), with membership to syndicate groups represented            by colors as labelled in the legend.")),
    mainPanel(
      forceNetworkOutput("urgent_meeting")))),                   

tabPanel("3780",
  sidebarLayout(
    sidebarPanel(
      h1("Information"),
      p("This simple network diagram represents student responses to the question:"),
      br(),
      strong("'Imagine a generous Imperial alumnus has given you a luxury box at the Royal 
              Albert Hall for a concert you will really enjoy. Select up to 6 people from 
              this class to invite to the concert.'"),
      br(),
      br(),
      p("Students are represented by individual circles on this diagram (anonymously labelled with numbers), with membership to syndicate groups represented by         colors as labelled in the legend.")),
    mainPanel(
      forceNetworkOutput("albert_hall")))),

tabPanel("3781",
         sidebarLayout(
           sidebarPanel(
             h1("Information"),
             p("This simple network diagram represents student responses to the question:"),
             br(),
             strong("'Imagine you have been asked to join a team that will meet weekly from January to May to complete detailed planning for the new graduation week celebration. Select up to 6 people you would like to see on this team.'"),
             br(),
             br(),
             p("Students are represented by individual circles on this diagram (anonymously labelled with numbers), with membership to syndicate groups represented by         colors as labelled in the legend.")),
           mainPanel(
             forceNetworkOutput("weekly_meeting")))),

tabPanel("3782",
sidebarLayout(
  sidebarPanel(
    h1("Information"),
    p("This simple network diagram represents student responses to the question:"),
    br(),
    strong("'Imagine you have been invited to a 2-day January workshop in which you will design a creative new graduation week celebration for students in your degree course. Select up to 6 people to join you'"),
    br(),
    br(),
    p("Students are represented by individual circles on this diagram (anonymously labelled with numbers), with membership to syndicate groups represented by         colors as labelled in the legend.")),
  mainPanel(
    forceNetworkOutput("workshop"))))
))
                 
                 