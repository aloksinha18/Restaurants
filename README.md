# Restaurants

[![Platforms](https://img.shields.io/badge/Platform-iOS-yellow.svg)]()
[![Language](https://img.shields.io/badge/Language-Swift_5.1-orange.svg)]()
[![Autolayout](https://img.shields.io/badge/Autolayout-Supported-blue.svg)]()
[![License](https://img.shields.io/badge/License-MIT-blue.svg)]()

Restaurants is a iOS application written in swift with UnitTests and UITests.

This application has follwoing use cases: 

- Loads list of restaurants from `json`  file and present in tableview.
- Always sort by the status(`open` restaurants will appear on top, `orderahead` restaurants  in middle and closed restaurants in `bottom`)
- Search Restaurant by name.
- Sort restaurants by various sorting options (defined in json file)
- Persist sorting options to local storage( `NSUserDefaults`)

# Architecture
MVVM

## Model ( json )
```
{
  "restaurants": [{
    "name": "Tanoshii Sushi",
    "status": "open",
    "sortingValues": {
      "bestMatch": 0.0,
      "newest": 96.0,
      "ratingAverage": 4.5,
      "distance": 1190,
      "popularity": 19.0,
      "averageProductPrice": 1536,
      "deliveryCosts": 200,
      "minCost": 1000
  }]
}
```

## Screenshot

![Simulator Screen Shot - iPhone 13 - 2022-07-01 at 17 04 03](https://user-images.githubusercontent.com/30017908/176920546-53452367-aeec-4591-b406-8a804b8bb4a7.png)

![Simulator Screen Shot - iPhone 13 - 2022-07-01 at 17 14 17](https://user-images.githubusercontent.com/30017908/176922067-f6df07d1-9a1c-4b4c-b745-56d0bf71ea56.png)


