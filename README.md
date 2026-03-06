# SiteBuilder — No-Code Website Builder for Android

Build beautiful, fully functional websites from your phone — no coding required.

## Features

- 🎨 **5 Website Categories**: E-Commerce, Portfolio, Blog, Landing Page, Business
- 🧩 **Pre-built Logic**: Cart, checkout, contact forms, FAQ, testimonials — all pre-wired
- ✋ **Touch-first Editor**: Drag, drop, resize elements directly on canvas
- 📝 **Rich Property Panel**: Edit text, colors, fonts, images from your phone
- 📦 **Export to ZIP**: Generate deployable HTML/CSS/JS website package
- 💾 **Local Projects**: All sites saved locally with SQLite
- ↩️ **Undo/Redo**: Full undo/redo history
- 🔍 **Live Preview**: WebView preview of your site

## Project Structure

```
lib/
├── main.dart                    # App entry point
├── app.dart                     # Theme + routing
├── models/                      # Data models
│   ├── website_project.dart     # Project + SitePage
│   ├── page_element.dart        # Element with properties
│   └── element_type.dart        # 20 element type enum
├── templates/                   # 5 pre-built templates
│   ├── ecommerce_template.dart
│   ├── portfolio_template.dart
│   ├── blog_template.dart
│   ├── landing_page_template.dart
│   └── business_template.dart
├── screens/
│   ├── home/home_screen.dart    # Dashboard
│   ├── onboarding/              # Category picker
│   ├── editor/                  # Canvas + palette + properties
│   └── preview/                 # WebView preview
├── widgets/elements/            # Visual element renderers
├── providers/                   # State management
└── services/                    # SQLite, Export, Image
```

## Building the APK

This project uses **GitHub Actions** to build the APK automatically.

### Steps

1. Create a GitHub account at [github.com](https://github.com)
2. Create a new repository and push this code:

   ```bash
   git init
   git add .
   git commit -m "Initial commit: SiteBuilder app"
   git remote add origin https://github.com/YOUR_USERNAME/site-builder.git
   git push -u origin main
   ```

3. Go to **Actions** tab in your repository
4. The build will run automatically
5. Download the APK from the **Artifacts** section

## Element Types (20 total)

| Category   | Elements |
|------------|----------|
| Content    | Text, Heading, Divider, Spacer |
| Media      | Image, Hero Banner |
| Actions    | Button, Cart Button, Social Links |
| Store      | Product Card, Pricing Card |
| Navigation | Navbar, Footer |
| Forms      | Contact Form, FAQ Item |
| Sections   | Section, Testimonial, Feature Card, Team Card, Blog Post Card |

## Website Categories

| Category     | Pages |
|--------------|-------|
| E-Commerce   | Home, Shop, Cart, Checkout |
| Portfolio    | Home, Projects, About, Contact |
| Blog         | Home, Post, About |
| Landing Page | Home (single-page, multi-section) |
| Business     | Home, Services, Team, Contact |
