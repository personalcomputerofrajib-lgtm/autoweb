import '../models/website_project.dart';
import '../models/page_element.dart';
import '../models/element_type.dart';

class LandingPageTemplate {
  static WebsiteProject create(String name) {
    return WebsiteProject(
      name: name,
      category: 'Landing Page',
      pages: [_mainPage(name)],
      globalSettings: {
        'primaryColor': '#10B981',
        'fontFamily': 'Inter',
        'siteName': name,
        'favicon': '',
      },
    );
  }

  static SitePage _mainPage(String brandName) {
    return SitePage(
      name: 'Home',
      elements: [
        PageElement(
          elementType: ElementType.navbar,
          x: 0, y: 0, width: 390, height: 60,
          properties: {
            'brandName': brandName,
            'backgroundColor': '#050F0A',
            'textColor': '#FFFFFF',
            'showCart': false,
            'showLogin': false,
            'menuItems': ['Features', 'Pricing', 'Testimonials'],
          },
        ),
        PageElement(
          elementType: ElementType.hero,
          x: 0, y: 60, width: 390, height: 360,
          properties: {
            'title': 'The Product That Changes Everything',
            'subtitle': 'Join 10,000+ happy users who simplified their workflow.',
            'buttonLabel': 'Start Free Trial',
            'buttonAction': 'scroll',
            'backgroundImageUrl': '',
            'backgroundColor': '#050F0A',
            'overlayOpacity': 0.0,
            'textColor': '#FFFFFF',
          },
        ),
        PageElement(
          elementType: ElementType.heading,
          x: 20, y: 435, width: 350, height: 44,
          properties: {
            'content': '✨ Key Features',
            'fontSize': 22.0,
            'fontWeight': 'bold',
            'color': '#FFFFFF',
            'textAlign': 'center',
            'fontFamily': 'Inter',
          },
        ),
        PageElement(
          elementType: ElementType.featureCard,
          x: 10, y: 490, width: 370, height: 90,
          properties: {
            'title': 'Lightning Fast',
            'description': '10x faster than the competition. Your workflow won\'t miss a beat.',
            'icon': 'bolt',
            'iconColor': '#10B981',
            'backgroundColor': '#0C1A14',
            'borderRadius': 16.0,
          },
        ),
        PageElement(
          elementType: ElementType.featureCard,
          x: 10, y: 590, width: 370, height: 90,
          properties: {
            'title': 'Secure by Default',
            'description': 'Bank-grade encryption. Your data stays yours.',
            'icon': 'security',
            'iconColor': '#10B981',
            'backgroundColor': '#0C1A14',
            'borderRadius': 16.0,
          },
        ),
        PageElement(
          elementType: ElementType.featureCard,
          x: 10, y: 690, width: 370, height: 90,
          properties: {
            'title': 'Works Everywhere',
            'description': 'Web, iOS, Android — seamlessly synced.',
            'icon': 'devices',
            'iconColor': '#10B981',
            'backgroundColor': '#0C1A14',
            'borderRadius': 16.0,
          },
        ),
        PageElement(
          elementType: ElementType.heading,
          x: 20, y: 800, width: 350, height: 44,
          properties: {
            'content': 'Pricing Plans',
            'fontSize': 22.0,
            'fontWeight': 'bold',
            'color': '#FFFFFF',
            'textAlign': 'center',
            'fontFamily': 'Inter',
          },
        ),
        PageElement(
          elementType: ElementType.pricingCard,
          x: 10, y: 855, width: 175, height: 280,
          properties: {
            'planName': 'Starter',
            'price': 'Free',
            'period': 'forever',
            'features': ['5 projects', '1 GB storage', 'Email support'],
            'buttonLabel': 'Get Started',
            'isHighlighted': false,
            'backgroundColor': '#0C1A14',
            'accentColor': '#10B981',
          },
        ),
        PageElement(
          elementType: ElementType.pricingCard,
          x: 200, y: 855, width: 175, height: 280,
          properties: {
            'planName': 'Pro',
            'price': '₹499',
            'period': '/month',
            'features': ['Unlimited projects', '50 GB storage', 'Priority support', 'Analytics'],
            'buttonLabel': 'Start Trial',
            'isHighlighted': true,
            'backgroundColor': '#10B981',
            'accentColor': '#FFFFFF',
          },
        ),
        PageElement(
          elementType: ElementType.heading,
          x: 20, y: 1155, width: 350, height: 44,
          properties: {
            'content': 'What Users Say',
            'fontSize': 22.0,
            'fontWeight': 'bold',
            'color': '#FFFFFF',
            'textAlign': 'center',
            'fontFamily': 'Inter',
          },
        ),
        PageElement(
          elementType: ElementType.testimonial,
          x: 10, y: 1210, width: 370, height: 140,
          properties: {
            'quote': '"I doubled my team\'s productivity in a week. This tool is a game changer!"',
            'authorName': 'Vikram Nair',
            'authorRole': 'CTO at Flowtech',
            'rating': 5,
            'backgroundColor': '#0C1A14',
            'accentColor': '#10B981',
          },
        ),
        PageElement(
          elementType: ElementType.testimonial,
          x: 10, y: 1360, width: 370, height: 140,
          properties: {
            'quote': '"Setup took 5 minutes. Worth every rupee."',
            'authorName': 'Meena Reddy',
            'authorRole': 'Founder, DesignHaus',
            'rating': 5,
            'backgroundColor': '#0C1A14',
            'accentColor': '#10B981',
          },
        ),
        PageElement(
          elementType: ElementType.button,
          x: 60, y: 1520, width: 270, height: 54,
          properties: {
            'label': '🚀 Start Free Today',
            'backgroundColor': '#10B981',
            'textColor': '#FFFFFF',
            'borderRadius': 14.0,
            'fontSize': 16.0,
            'fontWeight': 'semibold',
            'action': 'none',
            'actionTarget': '',
            'icon': '',
          },
        ),
        PageElement(
          elementType: ElementType.footer,
          x: 0, y: 1595, width: 390, height: 100,
          properties: {
            'brandName': brandName,
            'tagline': 'Made with ❤️ in India.',
            'links': ['Privacy', 'Terms', 'Contact'],
            'backgroundColor': '#020906',
            'textColor': '#666677',
            'showSocial': true,
          },
        ),
      ],
    );
  }
}
