# Netflix-Data-Analysis-Project
Introduction
- This project involves analyzing a Netflix dataset to derive meaningful insights. The dataset includes information on various Netflix shows and movies, such as title, director, cast, country, date added, release year, rating, duration, genres, and description. The objective is to clean the data and execute SQL queries to uncover trends and patterns.

Business Problem
- Netflix aims to gain deeper insights into its content and viewer preferences. By analyzing the dataset, we can provide valuable information such as the most prolific directors, popular genres, and country-specific preferences.

Business Goal
- The goals of this analysis are:
a) Identify directors who have created both movies and TV shows.
b) Determine the country with the highest number of comedy movies.
c) Identify directors with the maximum number of movies released each year.
d) Calculate the average duration of movies across different genres.
e) Find directors who have produced both comedy and horror movies.

Technologies Used
a) SQL: For data manipulation and analysis.
b) Python: For additional data processing and visualization (optional).
c) Microsoft SQL Server: For storing and querying the dataset.

Project Steps
1. Data Cleaning and Preparation
The initial step involved creating a raw table with appropriate data types and lengths for each column. The data was cleaned to ensure no duplicate titles within the same type (Movie or TV Show).

2. Data Transformation
A cleaned table was created from the raw data, focusing on ensuring data consistency and integrity.

3. Creating Separate Tables for Multi-valued Columns
Separate tables were created for columns that contain multiple values, such as genres, directors, cast, and country. This allowed for more granular analysis.

4. Analysis and Insights
- Several SQL queries were executed to derive insights, including:
a) Identifying directors who have created both movies and TV shows.
b) Determining the country with the highest number of comedy movies.
c) Identifying the directors with the most movies released each year.
d) Calculating the average duration of movies in each genre.
e) Finding directors who have produced both comedy and horror movies.
