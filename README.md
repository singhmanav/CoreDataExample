# CoreDataDemo - iOS Swift App

This is a sample iOS application demonstrating Core Data for storing a list of names. It includes features like adding, deleting, and reordering items. The application is written in Swift 4.

## Features

*   Adding new names to the list.
*   Displaying the list of names.
*   Deleting names from the list using a custom delete icon.
*   Reordering names using drag and drop functionality.

## Project Structure

*   `CoreDataDemo/`: Main application folder.
*   `ViewController.swift`: Manages the main list view, including displaying names, handling deletions, and implementing drag & drop reordering.
*   `SecondViewController.swift`: Handles the "add name" screen, allowing users to input new names.
*   `Database.swift`: Manages all Core Data interactions, such as saving new `Person` entities, fetching existing ones, and deleting them from the persistent store.
*   `Model.swift`: Serves as the data model for the `ViewController` and assists with the logic for drag and drop operations.
*   `CoreDataDemo.xcdatamodeld`: Defines the Core Data model, specifically the "Person" entity with its "name" attribute.
*   `Assets.xcassets`: Contains app icons and other image resources, including the custom delete icon.

## How to Build and Run

This is an Xcode project. To build and run the application:

1.  Clone the repository to your local machine.
2.  Open the `CoreDataDemo.xcodeproj` file in Xcode.
3.  Select an iOS simulator or a connected iOS device as the build target.
4.  Click the "Run" (or Play icon) button in Xcode to build and launch the application.

## Potential Improvements

This section lists potential enhancements that could be made to the application:

*   Implement more robust error handling throughout the app to gracefully manage unexpected situations.
*   Add functionality to edit existing names in the list.
*   If the application were to be expanded, consider implementing more complex data models and Core Data relationships.
*   Introduce UI tests to verify the application's user interface and unit tests for Core Data operations to ensure data integrity.
