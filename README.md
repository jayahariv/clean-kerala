# Clean Kerala

Its an app to display toilets near the user. Users can also add a toilet with a rating. 

## Features include
    * Ability to see nearby toilets in the map, also as a list. 
    * Ability to search with address.
    * Ability to add a toilet

### Known Issue
    * Not restricted to search any address outside Kerala.
    * Not restricted to zoom out and scroll to other places in map. 
    * App supports only Portrait orientation. Current use cases are best done in portrait orientation.  
    * On clicking the annotation, open up the google map to naivgate to the location. 
    
## Usage
If you want to run the app follow the below steps.
1. Open the terminal and clone the repository. `git clone https://github.com/jayahariv/clean-kerala.git`
2. Change director and move inside the repository folder. `cd ~/<path to repository>/clean-kerala/`
3. install the cocoa pods. `pod install`
4. Open the workspace, now you can run the application. But it will only include the toilets from the firebase real time database.


## How to login?
Currently we don't support authentication with Facebook, Google or Sign-Up option. Only the signed-in users can add toilets to the real-time database. But it will be exposed soon. 


## How to get google data?
1. Go to `https://console.developers.google.com/apis/dashboard`
2. Create a Google Application inside it. 
3. Enable Places API. 
4. Create Credentials and copy the API Key. 
5. Paste the API Key copied inside the Clean-India ->  model -> HttpConstants.swift -> API_KEY. 

## Screenshots
!<img width="160" alt="login" src="https://user-images.githubusercontent.com/10448770/43119379-01faa6c8-8ecb-11e8-9fc4-15a707fcb0bd.png">
<img width="160" alt="add_toilet_by_force_touch" src="https://user-images.githubusercontent.com/10448770/43119380-0211df3c-8ecb-11e8-9846-ec8818cc35f5.png">
<img width="160" alt="address_search" src="https://user-images.githubusercontent.com/10448770/43119381-026198a6-8ecb-11e8-865e-515cef25a1cf.png">
<img width="160" alt="home" src="https://user-images.githubusercontent.com/10448770/43119384-02d29466-8ecb-11e8-8e88-fff132cf572a.png">
<img width="160" alt="list" src="https://user-images.githubusercontent.com/10448770/43141191-2eeb2790-8f0a-11e8-835b-c6e526807666.png">


## Useful Links
* [how data is designed in Firebase](https://gist.github.com/jayahariv/afe7bad2368bf831ff22f658124fa0d5)
* [track the progress and history till now](https://github.com/jayahariv/udacity/tree/master/CleanIndia)

