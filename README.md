# Kara — Tailored MVVM Architecture

> **Kara** is an iOS app built with **SwiftUI** and **Firestore** using a **Feature-Based MVVM** architecture.
> 
> *This example has been perfectly tailored to contain exactly three features: Arus Kas, Input Forms (Income & Expense), and Rekap Transaksi.*

---

## Part 1: The Architecture

### 1.1 Architecture Overview

This project uses **MVVM (Model-View-ViewModel)** pattern, but it organizes folders by **Feature** rather than by file type.

The codebase relies on 4 simple file responsibilities:
1. **Models**: Simple Swift `struct` files that define data (`CashFlowModel`).
2. **Services**: Classes that talk to external systems like Firebase (`FirebaseService`).
3. **ViewModels**: The brain holding state (`@Published`) and business logic.
4. **Views**: The SwiftUI code.

### 1.2 How Foldering Works (The Rules)

If you are adding a new file to this project, follow these rules:

**Rule 1: Everything starts in a "Feature" Folder**
If you are building a new screen (e.g., a "Profile" page), you must create a new folder inside `Features/` called `Profile/`. Inside that folder, you create three subfolders: `Models/`, `ViewModels/`, and `Views/`. **Everything** related to the Profile page lives in this folder.

**Rule 2: The `Core` Folder is only for Shared Items**
Never put a file in `Core/` unless it is used by **more than one feature**. 
For example, both `CashFlow` and `Rekap` need to use `CashFlowModel`. If we put it in `CashFlow/`, then `Rekap` would have to break into another feature's folder to use it. Therefore, `CashFlowModel` is placed in `Core/Models/`. `Core` is your universal toolbox.

**Rule 3: Local Components vs Global Components**
When you break a large SwiftUI View into smaller pieces (like a custom row or card), where does it go?
- **Local Component:** If the card is ONLY used by the `CashFlow` feature, it goes into `Features/CashFlow/Views/Components/`. 
- **Global Component:** If you build a custom `PrimaryButton` that is used on every single screen in the app, it goes into `Core/Components/`.

**Rule 4: Navigation is its own Feature**
`MainTabView.swift` (the bottom bar) doesn't belong to Arus Kas or Rekap. Its only job is to orchestrate the tabs. Therefore, it gets its own feature folder: `Features/Navigation/`. 

#### The Complete Folder Tree Example

```
Kara/
├── KaraApp.swift                 # App Entry point
├── ContentView.swift             # Root View
│
├── Core/                         # SHARED TOOLBOX (Used by multiple features)
│   ├── Services/                 
│   │   └── FirebaseService.swift 
│   └── Models/                   
│       └── CashFlowModel.swift   
│
└── Features/                     # FEATURE MODULES (Strictly isolated)
    │
    ├── CashFlow/                 # Feature 1: Arus Kas
    │   ├── ViewModels/
    │   │   └── CashFlowViewModel.swift
    │   └── Views/
    │       ├── CashFlowView.swift
    │       └── Components/       # Local components only for CashFlow
    │           ├── CashFlowSummaryCard.swift
    │           └── CashFlowTransactionRow.swift
    │
    ├── AddRecord/                # Feature 2: Input Forms
    │   ├── ViewModels/           
    │   │   ├── AddExpenseViewModel.swift
    │   │   └── AddIncomeViewModel.swift
    │   └── Views/                
    │       ├── ExpenseFormView.swift
    │       ├── IncomeFormView.swift
    │       └── AddRecordView.swift
    │
    ├── Rekap/                    # Feature 3: Rekap Transaksi
    │   ├── ViewModels/           
    │   │   └── RekapViewModel.swift
    │   └── Views/                
    │       └── RekapView.swift
    │
    └── Navigation/               # Orchestration Feature
        └── Views/                
            └── MainTabView.swift
```

### 1.3 The Flow (How it works)

Let's look at how adding a new expense works in this architecture. If you want to understand how it works, you only need to open `Features/AddRecord/`:

1. **The User Taps "Save"**: In `ExpenseFormView.swift`, the SwiftUI button calls `await viewModel.save()`.
2. **The ViewModel Validates**: Inside `AddExpenseViewModel.swift`, the `save()` function checks if the `amount > 0`. If it is, it creates a `CashFlowModel`.
3. **The Service Saves**: The ViewModel calls the shared `FirebaseService.shared.saveCashFlowTransaction(expense)` from the `Core` folder.
4. **The UI Updates**: The ViewModel sets `isSaved = true`, and the View automatically dismisses itself.

---

## Part 2: Git Standards & Naming Conventions

To ensure the codebase remains clean and collaborative, our group adheres to the following global standards.

### 2.1 File Naming Convention
In Swift and MVVM, file names must clearly communicate what the file is and what layer it belongs to.
- **Always use `PascalCase`** (e.g., `CashFlowView.swift`, never `cash_flow_view.swift`).
- **Suffix Rules**:
  - **Views**: Must end with `View` (e.g., `CashFlowView.swift`, `ExpenseFormView.swift`).
  - **ViewModels**: Must end with `ViewModel` (e.g., `AddExpenseViewModel.swift`).
  - **Models**: Should ideally end with `Model` or be a clear noun (e.g., `CashFlowModel.swift`, `UserModel.swift`).
  - **Services**: Must end with `Service` or `Manager` (e.g., `FirebaseService.swift`).

### 2.2 Commit Message Standard
We strictly follow **Conventional Commits** to keep our Git history readable and professional.

#### Types of Commits
When writing a commit (or naming a branch), you must start with one of these types:

| Type | Description | Example |
|---|---|---|
| **`feat`** | A new feature for the user. | `feat(auth): add Google login support` |
| **`fix`** | A bug fix for the user. | `fix(cart): resolve item duplication issue` |
| **`docs`** | Documentation only changes. | `docs: update setup instructions in README` |
| **`refactor`**| A code change that neither fixes a bug nor adds a feature. | `refactor: simplify data ingestion logic` |
| **`perf`** | A code change that improves performance. | `perf: optimize query` |
| **`test`** | Adding missing tests or correcting existing tests. | `test: add unit tests` |
| **`chore`** | Other changes that don't modify source or test files. | `chore: update .gitignore` |

#### Structure
**Structure:** `[type]([scope]): [description]`
- `<type>` (Mandatory): Pick one from the table above.
- `<scope>` (Optional): The area/component affected (e.g., `auth`, `cart`).
- `<description>` (Mandatory): A brief description of the changes.

### 2.3 Branching Strategy
We use a structured branch naming convention so everyone knows exactly what type of work the branch contains, what it does, and who is working on it.

**Structure:** `[developer_name]/[type]/[quick-description]`

**Examples:**
- `budi/feat/add-cashflow-list`
- `siti/fix/fixing-query-access`
- `budi/refactor/simplify-auth-flow`

### 2.4 Pull Request (PR) Rules

**Avoiding Git Conflicts & Ensuring Quality:**
1. **Mandatory Review**: A Pull Request **cannot** be merged into `main` without at least one approval from another team member. This ensures code quality and prevents accidental breaks.
2. **Focus the PR**: Make sure your PR has a very specific purpose. If you want to fix a bug, focus on that fix. Do not sneak in additional features.
3. **Pull Often**: Once you create a PR branch, submit the PR as soon as possible. If the PR is delayed, always pull/merge from the `master` (or `main`) branch into your PR branch to resolve conflicts locally before merging.

**PR Message Structure:**
Your PR description should follow this template so reviewers have full context:

```markdown
## Summary
[Brief explanation of what this PR does, e.g., "Add the Cash Flow list feature to the main tab."]

## Impact
- **Modules Affected:** [e.g., `Features/CashFlow`]
- **Downstream Impact:** [e.g., "Updates the way totals are calculated in Rekap"]

## Visual Proof
[Include screenshots or GIF recordings of the UI changes here]
```
