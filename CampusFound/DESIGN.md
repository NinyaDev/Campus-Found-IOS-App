# DESIGN

## 1. Project Purpose and Goals

**Project name:** CampusFound – Lost and Found System

The purpose of this project is to provide a simple, mobile-friendly lost and found system for a university campus. Instead of relying on random emails, posters, or social media posts, CampusFound gives students and staff a single place to:

- Report **lost** items,
- Report **found** items,
- Browse and search existing reports,
- See where items were last seen,
- Mark items as **returned** when they are resolved.

From a course perspective, this project demonstrates:

- Object-oriented design in Swift,
- Use of at least one design pattern from class,
- A clear system architecture (MVVM),
- Basic unit testing,
- Professional project structure and documentation via GitHub.

---

## 2. Functional Requirements

Below are the main functional requirements that guided the design and implementation.

### Core features

- **R1 – Create lost item report**
  - The user can enter a title, description, category, approximate location, date, and contact info for a lost item.
  - The item is saved into the app’s data store and appears in the main list under “Lost”.

- **R2 – Create found item report**
  - Similar to R1, but the item is posted as “Found”.
  - Users can describe where and when it was found, plus how to reach the person who found it.

- **R3 – View list of all items**
  - The home screen shows a list of lost and found items.
  - Items can be grouped and/or visually distinguished by status (Lost, Found, Returned).

- **R4 – Search and filter**
  - Users can search items by text (for example, “backpack”, “AirPods”).
  - Optional filters:
    - Filter by **status** (Lost, Found, Returned),
    - Filter by **category** (electronics, clothing, ID cards, etc.),
    - Filter by **location** (building or area), if provided.

- **R5 – View item details**
  - Tapping an item opens a detail screen that shows:
    - Full description,
    - Category,
    - Location information,
    - Date,
    - Contact instructions.

- **R6 – Mark an item as returned**
  - Items can be updated from Lost/Found to a “Returned” or “Claimed” status.
  - This keeps the list clean and lets other users know that the item is no longer active.

- **R7 – Location context**
  - The app can optionally use CoreLocation to:
    - Store coordinates for an item,
    - Show a distance from the user to the item’s last known location (if permissions are granted).

- **R8 – Data persistence / repository**
  - Items are managed through a repository layer that can be implemented with:
    - An in-memory store for testing and development, and
    - A backing store (for the moment is local persistent storage) for real usage.
  - The rest of the app talks to the repository via a protocol, not directly to Firebase.

- **R9 – Unit tests**
  - At least basic unit tests are included for:
    - Adding items,
    - Filtering items,
    - Updating item status.

---

## 3. Non-Functional Requirements

- **Usability**
  - The UI is built with SwiftUI and is designed to be simple and easy to understand.
  - Primary actions (add item, view detail, search) are reachable within one or two taps.

- **Performance**
  - The item list uses efficient SwiftUI views and observable objects.
  - Data access goes through a repository to keep logic simple and maintainable.

- **Maintainability**
  - The code follows an **MVVM** (Model-View-ViewModel) structure.
  - Data access is abstracted behind protocols, allowing future changes (for example switching from local storage to Firebase) without needing to rewrite the UI.

- **Testability**
  - The repository layer can be swapped for a mock implementation in tests.
  - View models contain most of the logic and can be tested without rendering the UI.

---

## 4. Architecture Overview

The main architectural style for CampusFound is **MVVM**:

- **Models:** Plain Swift structs/enums that represent domain concepts (LostItem, ItemStatus, Category, etc.).
- **ViewModels:** Classes that hold state, expose observable properties, and implement business logic.
- **Views:** SwiftUI views that render the UI and bind to view models via `@StateObject` or `@EnvironmentObject`.

### High-level layers

1. **UI Layer (SwiftUI Views)**
   - `ItemsListView`
   - `ItemDetailView`
   - `AddItemView`
   - `FilterView` / filters integrated into the list

2. **Presentation Layer (ViewModels)**
   - `ItemsViewModel` – main view model for listing, searching, and filtering items.
   - `AddItemViewModel` – handles form validation and creation of new items.
   - `FilterViewModel` – manages filter state (status, category, location).

3. **Data Layer (Repository + Models)**
   - `LostItem` – core model representing a lost/found item.
   - `ItemStatus` – enum (Lost, Found, Returned).
   - `ItemCategory` – enum or struct for categories.
   - `LocationInfo` – model for descriptive location and optional coordinates.
   - `ItemsRepository` – protocol defining how the app interacts with stored items.
   - `InMemoryItemsRepository` – simple implementation for development/testing.

### App entry point

- `CampusFoundApp` (SwiftUI `@main` struct) sets up the shared `ItemsViewModel` and injects it into the environment so all child views can access it.

---

## 5. Major Classes and Components

### Models

- **`LostItem`**
  - Properties:
    - `id: UUID`
    - `title: String`
    - `description: String`
    - `status: ItemStatus`
    - `category: ItemCategory`
    - `location: LocationInfo`
    - `dateReported: Date`
    - `contactInfo: String`
  - Responsibility:
    - Represents one lost/found item in the system.

- **`ItemStatus`**
  - Enum: `.lost`, `.found`, `.returned`
  - Used to control how the item is displayed and filtered.

- **`ItemCategory`**
  - Enum or struct: `electronics`, `clothing`, `idCard`, `keys`, `other`, etc.
  - Used for categorization and filtering.

- **`LocationInfo`**
  - Properties:
    - `buildingName: String`
    - Optional coordinates: `latitude`, `longitude`
  - Responsibility:
    - Stores human-readable location and any GPS-level data if available.

---

### ViewModels

- **`ItemsViewModel`**
  - Key properties:
    - `@Published var items: [LostItem]`
    - `@Published var searchText: String`
    - `@Published var selectedStatus: ItemStatus?`
    - `@Published var selectedCategory: ItemCategory?`
  - Responsibilities:
    - Load items from the repository.
    - Apply search and filter logic.
    - Handle marking items as returned or updating their status.
    - Expose a computed `filteredItems` array to the UI.

- **`AddItemViewModel`**
  - Key properties:
    - `title`, `description`, `category`, `location`, `contactInfo`, `status`
  - Responsibilities:
    - Manage the form state for creating new items.
    - Validate input (for example, non-empty title).
    - Build a `LostItem` object and send it to the repository via `ItemsViewModel`.

- **`FilterViewModel`** 
  - Responsibilities:
    - Manage the currently selected filters and provide helper methods to apply them.

---

### Data / Repository Layer

- **`ItemsRepository` (protocol)**
  - Example methods:
    - `func loadItems() async throws -> [LostItem]`
    - `func add(_ item: LostItem) async throws`
    - `func update(_ item: LostItem) async throws`
  - Responsibility:
    - Defines the abstraction for any data source (in-memory, file, Firebase, etc.).

- **`InMemoryItemsRepository`**
  - Stores items in an array in memory.
  - Used for development and unit testing.
  - Makes it easy to test view models without network or database dependencies.

- **`FirebaseItemsRepository`** (implement in the future)
  - Connect to Firebase to store and retrieve items.
  - Implement the same `ItemsRepository` protocol so that the rest of the app does not need to change.

- **`AppDataManager` / `RepositoryProvider` (Singleton)**
  - Provides a single shared instance of `ItemsRepository`.
  - Ensures that all parts of the app use a consistent data source.

---

## 6. Data Flow and State Management

1. The app launches with `CampusFoundApp`, which creates a single instance of `ItemsViewModel`.
2. `ItemsViewModel` requests items from the injected `ItemsRepository` and stores them in `items`.
3. SwiftUI views subscribe to `ItemsViewModel` via `@EnvironmentObject` and automatically update when `@Published` properties change.
4. When the user:
   - Adds an item:
     - `AddItemViewModel` validates and builds a new `LostItem`.
     - It calls into `ItemsViewModel` which calls `ItemsRepository.add`.
     - After a successful add, `ItemsViewModel` refreshes `items`.
   - Searches or filters:
     - `ItemsViewModel` updates `searchText` or filter properties.
     - A computed property `filteredItems` is recalculated and the UI list updates.
   - Marks an item as returned:
     - `ItemsViewModel` modifies the `status` of the item and calls `ItemsRepository.update`.

This separation keeps the UI declarative and the logic centralized in view models.

---

## 7. Design Patterns Used

### MVVM (Model–View–ViewModel)

- Used as the main architectural pattern.
- It fits naturally with SwiftUI, keeps views simple, and concentrates logic in view models that are easy to test.

### Singleton

- The data access layer can be exposed via a singleton or a shared instance (for example, `AppDataManager.shared`).
- **Why:** The app has a single, shared set of lost/found items and a single backend. A singleton keeps configuration in one place and makes dependency injection into view models straightforward.

### Repository Pattern

- `ItemsRepository` defines an abstraction over how data is stored.
- `InMemoryItemsRepository` and `FirebaseItemsRepository` are concrete implementations.
- **Why:** This decouples the app from a specific database. It makes it possible to:
  - Swap implementations without changing UI or view model code,
  - Use a lightweight in-memory repository in tests.
---

## 8. Testing Strategy

### Unit Tests

Unit tests focus mainly on the view models and repository:

- **ItemsViewModel tests**
  - Adding a new item updates the `items` list correctly.
  - Search text filters the list by title/description.
  - Filter by status (Lost / Found / Returned) works as expected.
  - Marking an item as returned updates its status and moves it to the correct section.

- **Repository tests**
  - For `InMemoryItemsRepository`, tests confirm that `add` and `update` behave correctly.

These tests use the in-memory repository or mock implementations to avoid network or database dependency.

### Manual / UI Testing

- Basic walkthrough tests:
  - Launch app and verify that the default list appears.
  - Add a lost item and confirm it appears in the list.
  - Add a found item and confirm its status shows correctly.
  - Use search to find items by keyword.
  - Mark an item as returned and verify its status.

If UI tests are configured, they can automate some of these flows.

---

## 9. Limitations and Future Improvements

### Current Limitations

- **No cloud backend yet**  
  All items are stored locally (in memory or simple local storage). Data does not sync across devices, and it is lost if the app is deleted or reinstalled.

- **No authentication or user accounts**  
  Any user of the app can create or update items. There is no way to track which user posted which report.

- **Limited media support**  
  Item reports do not yet support uploading or displaying photos of items, which can make it harder to visually identify them.

- **Basic error handling and offline behavior**  
  Error messages are minimal and there is no robust handling for network or sync errors, because a remote backend is not yet integrated.

### Future Improvements

- **Add Firebase backend for persistent storage**  
  Integrate Firebase (for example, Cloud Firestore or Realtime Database) so that lost and found items are stored in the cloud, persist between app installs, and sync across multiple devices.

- **Firebase Authentication and user accounts**  
  Use Firebase Authentication so users can sign in with their campus email or another provider. This would allow items to be associated with specific users and enable features like “My items” and reporting abuse.

- **Item images and attachments**  
  Allow users to upload photos of lost and found items, stored in Firebase Storage and referenced from the database.

- **Improved notifications and matching**  
  Implement notifications so that when a found item matches the description or category of someone’s lost item, they receive an alert.

- **Enhanced error handling and offline support**  
  Once Firebase is integrated, add clear user-facing error messages, retry logic, and basic offline caching so that the app remains usable even with spotty connectivity.

- **Better map integration**  
  Use stored coordinates with a map view to show nearby lost and found items, and possibly cluster items by building or zone on campus.

---

## 10. Reflection

Building CampusFound helped reinforce several core concepts from the course:

- **Object-oriented design:** Defining clear models for items, statuses, categories, and locations.
- **Architecture:** Applying MVVM in a practical iOS app and separating the UI from logic and data.
- **Design patterns:** Using Singleton and Repository patterns to keep the code flexible and maintainable.
- **Testing:** Writing unit tests around view models and repositories showed how much easier it is to verify behavior when logic is not tied directly to the UI.
- **Version control and documentation:** Organizing the project in GitHub with a clear README and this DESIGN document made it easier to keep track of changes and explain the system to others.

If we had more time, we would focus on polishing the UI even more, adding authentication, and making the Firebase integration production-ready with robust error handling and offline caching.
