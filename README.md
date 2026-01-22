# CampusFound

**A simplified Lost & Found system for university campuses.**

CampusFound is a native iOS application built with SwiftUI that helps students and staff report lost items, post found items, and track their return status in a centralized, mobile-friendly environment.

## Project Overview

Instead of relying on scattered emails or physical posters, CampusFound provides a digital solution to manage lost property. 

**Key Features:**
* **Report Lost & Found:** Users can easily create reports with descriptions, categories, and dates.
* **Search & Filter:** Find items quickly by keyword, category (Electronics, IDs, etc.), or Status (Lost/Found).
* **Location Context:** View where items were last seen (supports basic location data).
* **Status Tracking:** Mark items as "Returned" once they are reunited with their owner.

This project was built to demonstrate **MVVM Architecture**, **Repository Design Pattern**, and clean **SwiftUI** development practices.

---

## Dependencies & Requirements

* **iOS:** 16.0+
* **Language:** Swift 5
* **Framework:** SwiftUI
* **IDE:** Xcode 15+
* **Data Persistence:** Local Storage / In-Memory (Mock) / CoreData (depending on current implementation)

---

## Setup & Run Instructions

1.  **Clone the repository:**
    ```bash
    git clone [https://github.com/your-username/Campus-Found-IOS-App.git](https://github.com/your-username/Campus-Found-IOS-App.git)
    ```
2.  **Open the project:**
    * Navigate to the folder and open `CampusFound.xcodeproj` in Xcode.
3.  **Build and Run:**
    * Select an iPhone Simulator (e.g., iPhone 15 Pro).
    * Press `Cmd + R` or click the **Play** button in Xcode.

---

## 📱 Usage Examples

### 1. Adding a Report
1.  Tap the **"+"** button on the main screen.
2.  Select whether you **Lost** an item or **Found** one.
3.  Fill in the details (Title, Description, Category, Location).
4.  Tap **Save**. The item will appear in the main list.

### 2. Finding an Item
1.  On the Home screen, type "AirPods" into the **Search bar**.
2.  Tap the **Filter icon** to narrow results by Category (e.g., Electronics) or Status (e.g., Found).

### 3. Resolving an Item
1.  Tap on an item card to view the **Item Detail** screen.
2.  Once the item is returned to the owner, tap the **"Mark as Returned"** button.
3.  The item status will update to "Returned" and it will be visually distinguished in the list.

---

## 📂 Project Structure

The project follows the **MVVM (Model-View-ViewModel)** architectural pattern:

* **`Models/`**: Plain Swift structs representing data (e.g., `LostItem`, `ItemCategory`).
* **`ViewModels/`**: Business logic and state management (e.g., `ItemsViewModel`).
* **`Views/`**: SwiftUI interfaces (e.g., `ItemsListView`, `AddItemView`).
* **`Repositories/`**: Data access layer (e.g., `ItemsRepository`, `InMemoryItemsRepository`).

---

## Contact

**Adrian Ninanya**

* **GitHub**: [AdrianNinanya32](https://github.com/NinyaDev)
* **Linkedin**: [Adrian Ninanya](https://www.linkedin.com/in/adrian-ninanya/)

**Andres Eguez**
* **GitHub**: [Aeguez](https://github.com/Aeguez)
* **Linkedin**: [Andres Eguez](https://www.linkedin.com/in/andres-eguez-112292368/)
