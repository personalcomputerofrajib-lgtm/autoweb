import '../models/website_project.dart';
import '../models/page_element.dart';
import '../models/element_type.dart';

class RestaurantTemplate {
  static WebsiteProject create(String name) {
    return WebsiteProject(
      name: name,
      category: 'Restaurant',
      pages: [_homePage(name), _menuPage(name), _reservationsPage(name)],
      globalSettings: {
        'primaryColor': '#D97706',
        'fontFamily': 'Inter',
        'siteName': name,
        'favicon': '',
      },
    );
  }

  static SitePage _homePage(String brandName) {
    return SitePage(
      name: 'Home',
      elements: [
        PageElement(
          elementType: ElementType.navbar,
          x: 0, y: 0, width: 390, height: 60,
          properties: {
            'brandName': brandName,
            'backgroundColor': '#0D0808',
            'textColor': '#FFFFFF',
            'showCart': false,
            'showLogin': false,
            'menuItems': ['Home', 'Menu', 'Reservations'],
          },
        ),
        PageElement(
          elementType: ElementType.hero,
          x: 0, y: 60, width: 390, height: 340,
          properties: {
            'title': 'Authentic Flavors, Unforgettable Moments',
            'subtitle': 'Experience fine dining crafted with love and the freshest ingredients.',
            'buttonLabel': 'Reserve a Table',
            'buttonAction': 'page:Reservations',
            'backgroundImageUrl': '',
            'backgroundColor': '#1A0D06',
            'overlayOpacity': 0.3,
            'textColor': '#FFFFFF',
          },
        ),
        PageElement(
          elementType: ElementType.heading,
          x: 20, y: 415, width: 350, height: 44,
          properties: {
            'content': '🍽️ Why Dine With Us',
            'fontSize': 22.0,
            'fontWeight': 'bold',
            'color': '#FFFFFF',
            'textAlign': 'center',
            'fontFamily': 'Inter',
          },
        ),
        PageElement(
          elementType: ElementType.featureCard,
          x: 10, y: 468, width: 175, height: 120,
          properties: {
            'title': 'Fresh Ingredients',
            'description': 'Farm-to-table produce daily.',
            'icon': 'eco',
            'iconColor': '#D97706',
            'backgroundColor': '#1A1008',
            'borderRadius': 16.0,
          },
        ),
        PageElement(
          elementType: ElementType.featureCard,
          x: 200, y: 468, width: 175, height: 120,
          properties: {
            'title': 'Master Chefs',
            'description': 'Global culinary expertise.',
            'icon': 'restaurant',
            'iconColor': '#D97706',
            'backgroundColor': '#1A1008',
            'borderRadius': 16.0,
          },
        ),
        PageElement(
          elementType: ElementType.statsCounter,
          x: 10, y: 600, width: 115, height: 100,
          properties: {
            'value': '15+',
            'label': 'Years',
            'prefix': '',
            'suffix': '+',
            'backgroundColor': '#1A1008',
            'valueColor': '#D97706',
            'labelColor': '#AAAACC',
            'borderRadius': 16.0,
          },
        ),
        PageElement(
          elementType: ElementType.statsCounter,
          x: 135, y: 600, width: 115, height: 100,
          properties: {
            'value': '50K+',
            'label': 'Guests',
            'prefix': '',
            'suffix': '+',
            'backgroundColor': '#1A1008',
            'valueColor': '#D97706',
            'labelColor': '#AAAACC',
            'borderRadius': 16.0,
          },
        ),
        PageElement(
          elementType: ElementType.statsCounter,
          x: 260, y: 600, width: 115, height: 100,
          properties: {
            'value': '4.9',
            'label': 'Rating',
            'prefix': '⭐ ',
            'suffix': '',
            'backgroundColor': '#1A1008',
            'valueColor': '#D97706',
            'labelColor': '#AAAACC',
            'borderRadius': 16.0,
          },
        ),
        PageElement(
          elementType: ElementType.testimonial,
          x: 10, y: 715, width: 370, height: 140,
          properties: {
            'quote': '"Best dining experience in the city. The butter chicken was phenomenal!"',
            'authorName': 'Sneha Gupta',
            'authorRole': 'Food Blogger',
            'rating': 5,
            'backgroundColor': '#1A1008',
            'accentColor': '#D97706',
          },
        ),
        PageElement(
          elementType: ElementType.map,
          x: 10, y: 870, width: 370, height: 200,
          properties: {
            'address': 'Khan Market, New Delhi, India',
            'latitude': 28.6003,
            'longitude': 77.2273,
            'zoom': 15,
            'backgroundColor': '#1A1008',
            'borderRadius': 16.0,
            'height': 200.0,
          },
        ),
        PageElement(
          elementType: ElementType.footer,
          x: 0, y: 1085, width: 390, height: 110,
          properties: {
            'brandName': brandName,
            'tagline': 'Open daily 12pm – 11pm',
            'links': ['Menu', 'Reservations', 'Contact'],
            'backgroundColor': '#060402',
            'textColor': '#888877',
            'showSocial': true,
          },
        ),
      ],
    );
  }

  static SitePage _menuPage(String brandName) {
    return SitePage(
      name: 'Menu',
      elements: [
        PageElement(
          elementType: ElementType.navbar,
          x: 0, y: 0, width: 390, height: 60,
          properties: {
            'brandName': brandName,
            'backgroundColor': '#0D0808',
            'textColor': '#FFFFFF',
            'showCart': false,
            'showLogin': false,
            'menuItems': ['Home', 'Menu', 'Reservations'],
          },
        ),
        PageElement(
          elementType: ElementType.heading,
          x: 20, y: 75, width: 350, height: 50,
          properties: {
            'content': 'Our Menu',
            'fontSize': 26.0,
            'fontWeight': 'bold',
            'color': '#FFFFFF',
            'textAlign': 'center',
            'fontFamily': 'Inter',
          },
        ),
        PageElement(
          elementType: ElementType.accordion,
          x: 10, y: 135, width: 370, height: 200,
          properties: {
            'items': [
              {'title': '🥗 Starters', 'content': 'Bruschetta ₹299 • Soup of the Day ₹199 • Tandoori Paneer ₹349'},
              {'title': '🍛 Main Course', 'content': 'Butter Chicken ₹499 • Dal Makhani ₹349 • Biryani ₹399 • Pasta Alfredo ₹449'},
              {'title': '🍰 Desserts', 'content': 'Gulab Jamun ₹149 • Tiramisu ₹249 • Ice Cream Sundae ₹199'},
              {'title': '🍹 Drinks', 'content': 'Mango Lassi ₹129 • Fresh Lime Soda ₹99 • Coffee ₹149'},
            ],
            'backgroundColor': '#1A1008',
            'textColor': '#FFFFFF',
            'accentColor': '#D97706',
            'borderRadius': 12.0,
          },
        ),
        PageElement(
          elementType: ElementType.gallery,
          x: 10, y: 350, width: 370, height: 300,
          properties: {
            'images': <String>[],
            'columns': 2,
            'gap': 8.0,
            'borderRadius': 12.0,
            'backgroundColor': '#0D0808',
            'caption': 'Our Dishes',
          },
        ),
      ],
    );
  }

  static SitePage _reservationsPage(String brandName) {
    return SitePage(
      name: 'Reservations',
      elements: [
        PageElement(
          elementType: ElementType.navbar,
          x: 0, y: 0, width: 390, height: 60,
          properties: {
            'brandName': brandName,
            'backgroundColor': '#0D0808',
            'textColor': '#FFFFFF',
            'showCart': false,
            'showLogin': false,
            'menuItems': ['Home', 'Menu', 'Reservations'],
          },
        ),
        PageElement(
          elementType: ElementType.heading,
          x: 20, y: 75, width: 350, height: 50,
          properties: {
            'content': 'Reserve Your Table',
            'fontSize': 26.0,
            'fontWeight': 'bold',
            'color': '#FFFFFF',
            'textAlign': 'center',
            'fontFamily': 'Inter',
          },
        ),
        PageElement(
          elementType: ElementType.text,
          x: 20, y: 130, width: 350, height: 50,
          properties: {
            'content': 'Book your perfect dining experience. We recommend reserving at least 24 hours in advance.',
            'fontSize': 14.0,
            'fontWeight': 'normal',
            'color': '#99A0B8',
            'textAlign': 'center',
            'fontFamily': 'Inter',
          },
        ),
        PageElement(
          elementType: ElementType.contactForm,
          x: 10, y: 195, width: 370, height: 400,
          properties: {
            'title': '',
            'fields': ['name', 'phone', 'email', 'date', 'guests', 'message'],
            'submitLabel': 'Reserve Now',
            'backgroundColor': '#1A1008',
            'accentColor': '#D97706',
            'emailTarget': '',
          },
        ),
      ],
    );
  }
}
