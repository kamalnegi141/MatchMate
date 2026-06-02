# MatchMate

A SwiftUI iOS app that fetches user profiles and lets you accept or decline them — like a lightweight match-making feed.

## Features

- Fetches user profiles from [JSONPlaceholder](https://jsonplaceholder.typicode.com/users)
- Swipeable card UI with avatar, name, email, and city
- Accept / Decline actions with visual status badges
- Toast notifications on every action
- Offline support — cached profiles via SwiftData persist across launches
- Match decisions are preserved on refresh (accepted/declined state survives re-fetch)

## Architecture

| Layer | File | Role |
|---|---|---|
| App | `MatchMateApp.swift` | Entry point, SwiftData `ModelContainer` setup |
| View | `ContentView.swift` | Scrollable profile feed |
| View | `MatchMateCardView.swift` | Individual profile card with accept/decline buttons |
| View | `ToastView.swift` | Transient feedback banner |
| ViewModel | `MatchMateViewModel.swift` | Network fetch, SwiftData persistence, match logic |
| Model | `User.swift` | SwiftData `@Model` with `MatchStatus` enum |
| Model | `UserResponse.swift` | Decodable DTO mapped to `User` |

MVVM pattern — views observe `MatchMateViewModel` via `@StateObject` / `@Published`.

## Tech Stack

- **Swift / SwiftUI**
- **SwiftData** — local persistence
- **Combine** — reactive state
- **Network** (`NWPathMonitor`) — connectivity detection
- **SDWebImageSwiftUI** — async image loading

## Requirements

- iOS 17+
- Xcode 15+

## Getting Started

1. Clone the repo
2. Open `MatchMate.xcodeproj` in Xcode
3. Xcode will resolve the SDWebImage Swift Package dependencies automatically
4. Build and run on a simulator or device (iOS 17+)

## How It Works

1. On launch, SwiftData is queried for any cached users — they render immediately
2. `NWPathMonitor` checks connectivity; if online, profiles are re-fetched from the API
3. Existing `matchStatus` values are preserved when the remote data replaces the cache
4. Tapping **Accept** or **Decline** updates the card state and persists it to SwiftData
5. A toast notification slides up from the bottom and auto-dismisses after 2.5 seconds
