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


## Milestone 3
![Friends](/images/milestone3/Friends.png)
![addTodo](/images/milestone3/addTodo.png)
![editTodo](/images/milestone3/editTodo.png)


## Things you did in the code
To implement milestone 1, I used exercise 7 as my base code and just edited the signup page and the user model.\
I added input fields for birthday, location, bio, and initialize the arrray for friends, sentFriendRequest, and\
receivedFriendrequests. For milestone 2, I used my exercise 6 to implement the functions like accepting and\
declining a friend request, and deleting a friend. Moreover, I used exercise 2 as my base code to implement the\
profile page. I also added an app drawer to navigate to the different screens — Todos Page, Friends page, Profile,\
and Logout button. For milestone 3, I used the week 7 discussion code as my base code to implement to features\
like adding, deleting, and editing a todo. I just edited the base codes in a way that would satisfy or implement\
the said features in the specification.


## Challenges faced
At first, I used another stream to fetch data for users together with a todo stream. But when I'm going to the friensd page,\
it is just loading. It seem like my stream for user is encountering a problem or getting blocked, thus, I just used one\
stream for todo and just fetch all the users at the start of the app or when a user logged in.

## Test Cases
Happy paths: 
User tapped sign up button and was directed to sign up page\
![Signup](/images/Signup.png)

User inputted valid email and password in login page and was logged in.\
![Login](/images/Login.png)

User tapped todo in app drawer\
![Todo](/images/Todo.png)

User tapped add button in todo page\
![addTodo](/images/addTodo.png)

User tapped edit button of a todo\
![editTodo](/images/editTodo.png)

User tapped delete button of a todo\
![editTodo](/images/deleteTodo.png)

User tapped profile in app drawer\
![Profile](/images/Profile.png)

User tapped friends in app drawer\
![Friends](/images/Friends.png)

User tapped delete in friends\
![deleteFriend](/images/deleteFriend.png)

User tapped a friend\
![friendProfile](/images/friendProfile.png)

User tapped search button\
![Search](/images/Search.png)

User search a user\
![SearchResult](/images/searchResult.png)


Unhappy path/s:\
User did not input a first name, last name, valid email, or password when signing up\
![SignupError](/images/SignupError.png)

User did not input valid email and password in login page\
![LoginError](/images/LoginError.png)

User tapped the delete of a not owned todo\
![NotOwnedTodo](/images/NotOwnedTodo.png)

User typed a long title and description for todo

## References
The profile screen UI design is based in https://www.behance.net/gallery/96438079/Profile-UI\

jameelsocorro(2020) Github[Source code]https://github.com/jameelsocorro/profile_app_ui


