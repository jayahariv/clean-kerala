# Clean Kerala

Its an app to display toilets near the user. Users can also add a toilet with a rating. 

## Features include
    * Ability to see nearby toilets in the map, also as a list. 
    * Ability to search with address.
    * Ability to add a toilet

### Known Issue
    * Not restricted to search any address outside Kerala.
    * Not restricted to zoom out and scroll to other places in map. 
    
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

## Useful Links
* [how data is designed in Firebase](https://gist.github.com/jayahariv/afe7bad2368bf831ff22f658124fa0d5)
