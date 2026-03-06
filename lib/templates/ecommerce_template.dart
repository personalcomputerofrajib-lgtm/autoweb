import '../models/website_project.dart';
import '../models/page_element.dart';
import '../models/element_type.dart';

class EcommerceTemplate {
  static WebsiteProject create(String name) {
    return WebsiteProject(
      name: name,
      category: 'E-Commerce',
      pages: [_homePage(name), _shopPage(name), _cartPage(name), _checkoutPage(name)],
      globalSettings: {
        'primaryColor': '#7C3AED',
        'fontFamily': 'Inter',
        'siteName': name,
        'favicon': '',
        'showCart': true,
        'currency': '₹',
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
            'backgroundColor': '#0A0A1A',
            'textColor': '#FFFFFF',
            'showCart': true,
            'showLogin': true,
            'menuItems': ['Home', 'Shop', 'About', 'Contact'],
          },
        ),
        PageElement(
          elementType: ElementType.hero,
          x: 0, y: 60, width: 390, height: 300,
          properties: {
            'title': 'Shop the Latest Trends',
            'subtitle': 'Discover amazing products at unbeatable prices.',
            'buttonLabel': 'Shop Now',
            'buttonAction': 'page:Shop',
            'backgroundImageUrl': '',
            'backgroundColor': '#1A0A3A',
            'overlayOpacity': 0.4,
            'textColor': '#FFFFFF',
          },
        ),
        PageElement(
          elementType: ElementType.heading,
          x: 20, y: 380, width: 350, height: 50,
          properties: {
            'content': 'Featured Products',
            'fontSize': 24.0,
            'fontWeight': 'bold',
            'color': '#FFFFFF',
            'textAlign': 'left',
            'fontFamily': 'Inter',
          },
        ),
        PageElement(
          elementType: ElementType.productCard,
          x: 10, y: 440, width: 175, height: 260,
          properties: {
            'productName': 'Premium Headphones',
            'price': '₹2,999',
            'originalPrice': '₹4,999',
            'imageUrl': '',
            'description': 'Crystal clear sound.',
            'badge': 'HOT',
            'backgroundColor': '#12122A',
            'borderRadius': 16.0,
          },
        ),
        PageElement(
          elementType: ElementType.productCard,
          x: 200, y: 440, width: 175, height: 260,
          properties: {
            'productName': 'Smart Watch',
            'price': '₹5,499',
            'originalPrice': '₹7,999',
            'imageUrl': '',
            'description': 'Track health & fitness.',
            'badge': 'NEW',
            'backgroundColor': '#12122A',
            'borderRadius': 16.0,
          },
        ),
        PageElement(
          elementType: ElementType.testimonial,
          x: 10, y: 720, width: 370, height: 140,
          properties: {
            'quote': '"Best shopping experience ever! Got my order in 2 days."',
            'authorName': 'Priya Sharma',
            'authorRole': 'Verified Buyer',
            'rating': 5,
            'backgroundColor': '#12122A',
            'accentColor': '#7C3AED',
          },
        ),
        PageElement(
          elementType: ElementType.footer,
          x: 0, y: 880, width: 390, height: 120,
          properties: {
            'brandName': brandName,
            'tagline': 'Quality products, great prices.',
            'links': ['Shop', 'Privacy Policy', 'Terms', 'Contact'],
            'backgroundColor': '#06060F',
            'textColor': '#888899',
            'showSocial': true,
          },
        ),
      ],
    );
  }

  static SitePage _shopPage(String brandName) {
    return SitePage(
      name: 'Shop',
      elements: [
        PageElement(
          elementType: ElementType.navbar,
          x: 0, y: 0, width: 390, height: 60,
          properties: {
            'brandName': brandName,
            'backgroundColor': '#0A0A1A',
            'textColor': '#FFFFFF',
            'showCart': true,
            'showLogin': true,
            'menuItems': ['Home', 'Shop', 'About', 'Contact'],
          },
        ),
        PageElement(
          elementType: ElementType.heading,
          x: 20, y: 70, width: 350, height: 50,
          properties: {
            'content': 'All Products',
            'fontSize': 24.0,
            'fontWeight': 'bold',
            'color': '#FFFFFF',
            'textAlign': 'left',
            'fontFamily': 'Inter',
          },
        ),
        PageElement(
          elementType: ElementType.productCard,
          x: 10, y: 130, width: 175, height: 260,
          properties: {
            'productName': 'Premium Headphones',
            'price': '₹2,999',
            'originalPrice': '₹4,999',
            'imageUrl': '',
            'description': 'Crystal clear sound.',
            'badge': 'HOT',
            'backgroundColor': '#12122A',
            'borderRadius': 16.0,
          },
        ),
        PageElement(
          elementType: ElementType.productCard,
          x: 200, y: 130, width: 175, height: 260,
          properties: {
            'productName': 'Smart Watch',
            'price': '₹5,499',
            'originalPrice': '₹7,999',
            'imageUrl': '',
            'description': 'Track health & fitness.',
            'badge': 'NEW',
            'backgroundColor': '#12122A',
            'borderRadius': 16.0,
          },
        ),
        PageElement(
          elementType: ElementType.productCard,
          x: 10, y: 400, width: 175, height: 260,
          properties: {
            'productName': 'Laptop Backpack',
            'price': '₹1,299',
            'originalPrice': '₹1,999',
            'imageUrl': '',
            'description': 'Fits 15.6" laptops.',
            'badge': 'SALE',
            'backgroundColor': '#12122A',
            'borderRadius': 16.0,
          },
        ),
        PageElement(
          elementType: ElementType.productCard,
          x: 200, y: 400, width: 175, height: 260,
          properties: {
            'productName': 'Wireless Speaker',
            'price': '₹3,199',
            'originalPrice': '₹4,499',
            'imageUrl': '',
            'description': '360° immersive sound.',
            'badge': '',
            'backgroundColor': '#12122A',
            'borderRadius': 16.0,
          },
        ),
      ],
    );
  }

  static SitePage _cartPage(String brandName) {
    return SitePage(
      name: 'Cart',
      elements: [
        PageElement(
          elementType: ElementType.navbar,
          x: 0, y: 0, width: 390, height: 60,
          properties: {
            'brandName': brandName,
            'backgroundColor': '#0A0A1A',
            'textColor': '#FFFFFF',
            'showCart': true,
            'showLogin': true,
            'menuItems': ['Home', 'Shop', 'About', 'Contact'],
          },
        ),
        PageElement(
          elementType: ElementType.heading,
          x: 20, y: 70, width: 350, height: 50,
          properties: {
            'content': 'Your Cart',
            'fontSize': 24.0,
            'fontWeight': 'bold',
            'color': '#FFFFFF',
            'textAlign': 'left',
            'fontFamily': 'Inter',
          },
        ),
        PageElement(
          elementType: ElementType.text,
          x: 20, y: 130, width: 350, height: 60,
          properties: {
            'content': 'Items you add to your cart will appear here. Continue shopping to find great products!',
            'fontSize': 14.0,
            'fontWeight': 'normal',
            'color': '#888899',
            'textAlign': 'left',
            'fontFamily': 'Inter',
          },
        ),
        PageElement(
          elementType: ElementType.button,
          x: 20, y: 700, width: 350, height: 54,
          properties: {
            'label': 'Proceed to Checkout',
            'backgroundColor': '#7C3AED',
            'textColor': '#FFFFFF',
            'borderRadius': 14.0,
            'fontSize': 16.0,
            'fontWeight': 'semibold',
            'action': 'page',
            'actionTarget': 'Checkout',
            'icon': 'arrow_forward',
          },
        ),
      ],
    );
  }

  static SitePage _checkoutPage(String brandName) {
    return SitePage(
      name: 'Checkout',
      elements: [
        PageElement(
          elementType: ElementType.navbar,
          x: 0, y: 0, width: 390, height: 60,
          properties: {
            'brandName': brandName,
            'backgroundColor': '#0A0A1A',
            'textColor': '#FFFFFF',
            'showCart': false,
            'showLogin': false,
            'menuItems': [],
          },
        ),
        PageElement(
          elementType: ElementType.heading,
          x: 20, y: 70, width: 350, height: 50,
          properties: {
            'content': 'Checkout',
            'fontSize': 24.0,
            'fontWeight': 'bold',
            'color': '#FFFFFF',
            'textAlign': 'left',
            'fontFamily': 'Inter',
          },
        ),
        PageElement(
          elementType: ElementType.contactForm,
          x: 10, y: 130, width: 370, height: 400,
          properties: {
            'title': 'Shipping Information',
            'fields': ['name', 'email', 'phone', 'address', 'city', 'pincode'],
            'submitLabel': 'Place Order',
            'backgroundColor': '#12122A',
            'accentColor': '#7C3AED',
            'emailTarget': '',
          },
        ),
      ],
    );
  }
}
