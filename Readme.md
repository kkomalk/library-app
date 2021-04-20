Library Management System is a system developed as a prototype for IIT Indore Central Library and manages all operations of a libraray along with providing some social features.
Developers
-> Vaibhav Chandra (vaibhavviking)
-> Purnadip Chakrabarti (ChakPC)
-> Komal Kumar (kkomalk)
-> Priyanshu Uttam (uttam509)

Tech Stack

Front End: HTML, CSS, Bootstrap, Javascript
Backend: NodeJS
Database: MySQL

Project Installation Guide

-> Clone this repository in your local machine
-> Open terminal in the project directory
-> If you have already installed NodeJS then type 'npm init' (without the single quotes). Else, please install NodeJS first.
-> The keys to our database are not put in this repository. You can build your own database using files in Database folder and 
   type credentials of your MySQL database in server.js
-> After doing above steps, type 'node server' in terminal and open your browser
-> You can now use the project by typing localhost:5000 as url
-> To stop the server, go to the terminal and press Ctrl + C 

Major Features

: Books are put on hold/loan/loan&hold for a particular user depending on a set of pre-defined rules like hold-limit/loan-limit/unpaid fines etc.

User(Student/Professor)
-> Request hold on a book
-> Mark a book as favourite/ rate books/ review books
-> Search friends and send friend requests to make community
-> See friend's list of favourite/read books
-> Look for other details regarding loan/hold/loan&hold of a book 

Librarian
-> Add/Delete/Update details of book
-> Issue/withdraw books to/from users
-> Collect fines from users