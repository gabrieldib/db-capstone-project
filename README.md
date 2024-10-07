Before you review, please read:

In the beginning of the course I saw the excel sheet was missing
quite some data if I wanted to make a minimaly realistic model, so 
I made the ER diagram and populated it with synthetic data from ChatGPT.

So to get this going, open MySQL workbench, connect to your server,
then open and run the SQL files in this order:

01 build little_lemon_db.sql
02 populate database with data.sql

( you can open them directly in mysql workbench)

then open 

03 Populate Data.ipynb

in your jupyter notebook, change the username and password to
the ones you are using, and run all cell on the notebook.

(In case you prefer to run a whole python file in your
IDE of choice, there's a py file in the python folder, same code
as the Jupyter NB)

This will populate the whole database with data.

-------------------------------------------------------------------------------------------------- 
Regarding the stored procedures:

The grading criteria asks for "ManageBooking()" procedure, but
we were never asked to create such procedure during the course.
I put all of the required procedures and the other relevant ones
in the file 

04 Stored Procedures.sql

-------------------------------------------------------------------------------------------------- 

ER diagram found on the PNG file 'little_lemon_db_diagram.png'
