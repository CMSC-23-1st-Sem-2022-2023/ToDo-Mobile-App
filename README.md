# Project
A shared todo flutter app that uses firebase with the following features:
1. Add, delete, and edit a todo
2. Add and delete a friend
3. Accept and decline a friend request
4. Sign in, Login, and Logout an account
5. View profile
6. View friend's profile

### Name: Roxanne Ysabel P. Resuello
### Student Number: 202002805
### Section: C1L


## Milestone 1


## Milestone 2
![Appdrawer](/images/milestone2.png)
![Profile](/images/milestone2friends.png)
![Friends](/images/milestone2profile.png)

## Milestone 3


## Things you did in the code
To implement milestone 1, I used exercise 7 as my base code and just edited the signup page and the user model.\
I added input fields for birthday, location, bio, and initialize the arrray for friends, sentFriendRequest, and\
receivedFriendrequests. For milestone 2, I used my exercise 6 to implement the functions like accepting and\
declining a friend request, and deleting a friend. Moreover, I used exercise 2 as my base code to implement the\
profile page. I also added an app drawer to navigate to the different screens — Todos Page, Friends page, Profile,\
and Logout button. For milestone 3, I used the week 7 discussion code as my base code to implement to features\
like adding, deleting, and editing a todo.



## Challenges faced
The data from firebase is sometimes late to fetch, thus the user I used in profile screen is somketimes null

## Test Cases
Happy paths: 
User tapped sign up button and was directed to sign up page\
![Signup](/images/SignupPage.png)

User inputted valid email and password in login page and was logged in.\
![Login](/images/LoginSuccess.png)

User inputted a first name, last name, and valid email and password.\
![SignupSuccess](/images/SignupSuccess.png)


Unhappy path/s:\
User did not input a first name, last name, valid email, or password when signing up\
![SignupError](/images/SignupErrorPage.png)

User did not input valid email and password in login page\
![LoginError](/images/loginErrorPage.png)


## References
