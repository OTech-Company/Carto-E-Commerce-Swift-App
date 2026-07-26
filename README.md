# Carto — AI-Powered E-Commerce iOS App

Carto is an iOS e-commerce app built during a 2-week hackathon sprint, powered by **Shopify's Storefront GraphQL API** on the backend and enriched with an **AI layer** that goes beyond a typical storefront: outfit comparison, smart recommendations, AR product visualization, a shopping assistant, and search-by-photo.

Built for the **JETS MobileX Challenge 2026**, hosted at **ITI Smart Village**, by a 4-person team.

---

## 🏆 Hackathon Context

| | |
|---|---|
| **Event** | JETS MobileX Challenge 2026 |
| **Venue** | ITI Smart Village |
| **Duration** | 2 weeks |
| **Team size** | 4 members |
| **Domain** | E-commerce, sourced from Shopify's GraphQL Storefront API |

The challenge was to build a functioning e-commerce mobile experience on top of Shopify's data layer, with an AI-driven value-add differentiating it from a standard storefront clone — all shipped within a two-week window.

---

## 🧠 AI Features

The AI layer is the core differentiator of the app. Implemented capabilities include:

- **Outfit Comparison** — lets users compare two or more products/outfits side by side with AI-assisted evaluation.
- **Smart Recommendations** — AI-driven product/outfit suggestions based on user behavior or selection context.
- **AR Product Viewer** — augmented reality visualization of products (see `Packages/ARProductViewer`), letting users preview items in real-world space before buying.
- **Shopping Assistant** — an AI assistant that helps guide the user through the shopping experience (discovery, Q&A, guidance).
- **Search by Photo** — visual search: users can search the Shopify catalog using an image instead of text.

---

## 🏗️ Architecture

The app follows **Clean Architecture + MVVM**:

- **Presentation Layer (MVVM)** — Views + ViewModels drive UI state, keeping business logic out of the UI layer.
- **Domain Layer** — Use cases / business rules, independent of frameworks and UI.
- **Data Layer** — Repositories responsible for talking to Shopify's Storefront GraphQL API and any AI service endpoints, mapping raw responses into domain models.

This layering keeps the AI and Shopify integrations swappable/testable independently from the UI, and matches the modular structure of the repo (see below).

---

## 📦 Tech Stack

- **Language:** Swift
- **UI:** SwiftUI
- **Architecture:** Clean Architecture + MVVM
- **Data Source:** Shopify Storefront GraphQL API
- **Payments:** Paymob SDK (`PaymobSDK.xcframework`) integrated for checkout
- **AR:** ARKit-based product viewer, isolated in its own local Swift Package (`ARProductViewer`)
- **Modularization:** Local Swift Packages for feature isolation (e.g. AR viewer as a standalone package)
- **Testing:** Unit tests (`CartoTests`) and UI tests (`CartoUITests`)

---

## 🚀 Getting Started

1. Clone the repo:
   ```bash
   git clone https://github.com/OTech-Company/Carto-E-Commerce-Swift-App.git
   ```
2. Open `Carto.xcodeproj` in Xcode.
3. Resolve local Swift Package dependencies (Xcode will do this automatically for `Packages/ARProductViewer`).
4. Configure your Shopify Storefront API credentials (store domain + Storefront access token).
5. Build and run on a simulator or a physical device (AR features require a physical device with ARKit support).

---
## 👥 Team
 
Built by a 4-person team over 2 weeks for the JETS MobileX Challenge 2026 at ITI Smart Village.
 
| Name | Role | GitHub
|---|---|---|
| Nadin Ahmed    | iOS Developer | [@NadinAhmed](https://github.com/NadinAhmed)
| Menna Mohammed | iOS Developer | [@MennaMohamed23](https://github.com/MennaMohamed23)
| Mohammed Ayman | iOS Developer | [@MO-Ayman22](https://github.com/MO-Ayman22)
| Osama Hossam   | iOS Developer | [@MAD-SAM22](https://github.com/MAD-SAM22)
