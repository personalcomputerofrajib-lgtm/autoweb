import '../models/website_project.dart';
import '../models/page_element.dart';
import '../models/element_type.dart';

class PortfolioTemplate {
  static WebsiteProject create(String name) {
    return WebsiteProject(
      name: name,
      category: 'Portfolio',
      pages: [_homePage(name), _projectsPage(name), _aboutPage(name), _contactPage(name)],
      globalSettings: {
        'primaryColor': '#06B6D4',
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
            'backgroundColor': '#050510',
            'textColor': '#FFFFFF',
            'showCart': false,
            'showLogin': false,
            'menuItems': ['Home', 'Projects', 'About', 'Contact'],
          },
        ),
        PageElement(
          elementType: ElementType.hero,
          x: 0, y: 60, width: 390, height: 360,
          properties: {
            'title': 'Hi, I\'m a Creative Designer',
            'subtitle': 'I craft beautiful digital experiences that people love.',
            'buttonLabel': 'View My Work',
            'buttonAction': 'page:Projects',
            'backgroundImageUrl': '',
            'backgroundColor': '#050510',
            'overlayOpacity': 0.0,
            'textColor': '#FFFFFF',
          },
        ),
        PageElement(
          elementType: ElementType.heading,
          x: 20, y: 440, width: 350, height: 50,
          properties: {
            'content': 'My Skills',
            'fontSize': 22.0,
            'fontWeight': 'bold',
            'color': '#FFFFFF',
            'textAlign': 'left',
            'fontFamily': 'Inter',
          },
        ),
        PageElement(
          elementType: ElementType.featureCard,
          x: 10, y: 500, width: 175, height: 120,
          properties: {
            'title': 'UI Design',
            'description': 'Pixel-perfect interfaces.',
            'icon': 'design_services',
            'iconColor': '#06B6D4',
            'backgroundColor': '#0C0C20',
            'borderRadius': 16.0,
          },
        ),
        PageElement(
          elementType: ElementType.featureCard,
          x: 200, y: 500, width: 175, height: 120,
          properties: {
            'title': 'Development',
            'description': 'Clean, efficient code.',
            'icon': 'code',
            'iconColor': '#06B6D4',
            'backgroundColor': '#0C0C20',
            'borderRadius': 16.0,
          },
        ),
        PageElement(
          elementType: ElementType.featureCard,
          x: 10, y: 630, width: 175, height: 120,
          properties: {
            'title': 'Branding',
            'description': 'Memorable brand identities.',
            'icon': 'palette',
            'iconColor': '#06B6D4',
            'backgroundColor': '#0C0C20',
            'borderRadius': 16.0,
          },
        ),
        PageElement(
          elementType: ElementType.featureCard,
          x: 200, y: 630, width: 175, height: 120,
          properties: {
            'title': 'Motion',
            'description': 'Smooth animations.',
            'icon': 'animation',
            'iconColor': '#06B6D4',
            'backgroundColor': '#0C0C20',
            'borderRadius': 16.0,
          },
        ),
        PageElement(
          elementType: ElementType.footer,
          x: 0, y: 780, width: 390, height: 100,
          properties: {
            'brandName': brandName,
            'tagline': 'Available for freelance work.',
            'links': ['Projects', 'About', 'Contact'],
            'backgroundColor': '#030309',
            'textColor': '#888899',
            'showSocial': true,
          },
        ),
      ],
    );
  }

  static SitePage _projectsPage(String brandName) {
    return SitePage(
      name: 'Projects',
      elements: [
        PageElement(
          elementType: ElementType.navbar,
          x: 0, y: 0, width: 390, height: 60,
          properties: {
            'brandName': brandName,
            'backgroundColor': '#050510',
            'textColor': '#FFFFFF',
            'showCart': false,
            'showLogin': false,
            'menuItems': ['Home', 'Projects', 'About', 'Contact'],
          },
        ),
        PageElement(
          elementType: ElementType.heading,
          x: 20, y: 70, width: 350, height: 50,
          properties: {
            'content': 'My Projects',
            'fontSize': 28.0,
            'fontWeight': 'bold',
            'color': '#FFFFFF',
            'textAlign': 'left',
            'fontFamily': 'Inter',
          },
        ),
        PageElement(
          elementType: ElementType.image,
          x: 10, y: 130, width: 370, height: 200,
          properties: {
            'imageUrl': '',
            'placeholderColor': '#0C0C20',
            'borderRadius': 16.0,
            'objectFit': 'cover',
            'altText': 'Project Screenshot',
          },
        ),
        PageElement(
          elementType: ElementType.heading,
          x: 20, y: 340, width: 350, height: 40,
          properties: {
            'content': 'Mobile App Design',
            'fontSize': 18.0,
            'fontWeight': 'semibold',
            'color': '#FFFFFF',
            'textAlign': 'left',
            'fontFamily': 'Inter',
          },
        ),
        PageElement(
          elementType: ElementType.text,
          x: 20, y: 385, width: 350, height: 60,
          properties: {
            'content': 'A complete redesign of a fintech mobile application, improving user retention by 40%.',
            'fontSize': 14.0,
            'fontWeight': 'normal',
            'color': '#99A0B8',
            'textAlign': 'left',
            'fontFamily': 'Inter',
          },
        ),
        PageElement(
          elementType: ElementType.divider,
          x: 20, y: 455, width: 350, height: 1,
          properties: {'color': '#1E1E3A', 'thickness': 1.0, 'style': 'solid'},
        ),
        PageElement(
          elementType: ElementType.image,
          x: 10, y: 470, width: 370, height: 200,
          properties: {
            'imageUrl': '',
            'placeholderColor': '#0C0C20',
            'borderRadius': 16.0,
            'objectFit': 'cover',
            'altText': 'Project Screenshot 2',
          },
        ),
        PageElement(
          elementType: ElementType.heading,
          x: 20, y: 680, width: 350, height: 40,
          properties: {
            'content': 'Brand Identity',
            'fontSize': 18.0,
            'fontWeight': 'semibold',
            'color': '#FFFFFF',
            'textAlign': 'left',
            'fontFamily': 'Inter',
          },
        ),
        PageElement(
          elementType: ElementType.text,
          x: 20, y: 725, width: 350, height: 60,
          properties: {
            'content': 'Full brand system: logo, colors, typography, and guidelines for a tech startup.',
            'fontSize': 14.0,
            'fontWeight': 'normal',
            'color': '#99A0B8',
            'textAlign': 'left',
            'fontFamily': 'Inter',
          },
        ),
      ],
    );
  }

  static SitePage _aboutPage(String brandName) {
    return SitePage(
      name: 'About',
      elements: [
        PageElement(
          elementType: ElementType.navbar,
          x: 0, y: 0, width: 390, height: 60,
          properties: {
            'brandName': brandName,
            'backgroundColor': '#050510',
            'textColor': '#FFFFFF',
            'showCart': false,
            'showLogin': false,
            'menuItems': ['Home', 'Projects', 'About', 'Contact'],
          },
        ),
        PageElement(
          elementType: ElementType.image,
          x: 130, y: 80, width: 130, height: 130,
          properties: {
            'imageUrl': '',
            'placeholderColor': '#0C0C20',
            'borderRadius': 65.0,
            'objectFit': 'cover',
            'altText': 'Profile Photo',
          },
        ),
        PageElement(
          elementType: ElementType.heading,
          x: 20, y: 225, width: 350, height: 44,
          properties: {
            'content': 'About Me',
            'fontSize': 26.0,
            'fontWeight': 'bold',
            'color': '#FFFFFF',
            'textAlign': 'center',
            'fontFamily': 'Inter',
          },
        ),
        PageElement(
          elementType: ElementType.text,
          x: 20, y: 275, width: 350, height: 120,
          properties: {
            'content': 'I\'m a passionate designer and developer with 5+ years of experience creating digital products. I love turning complex problems into simple, beautiful solutions.',
            'fontSize': 15.0,
            'fontWeight': 'normal',
            'color': '#99A0B8',
            'textAlign': 'center',
            'fontFamily': 'Inter',
          },
        ),
        PageElement(
          elementType: ElementType.socialLinks,
          x: 100, y: 410, width: 190, height: 50,
          properties: {
            'platforms': ['instagram', 'twitter', 'linkedin'],
            'style': 'icon',
            'color': '#06B6D4',
            'urls': {'instagram': '', 'twitter': '', 'linkedin': ''},
          },
        ),
      ],
    );
  }

  static SitePage _contactPage(String brandName) {
    return SitePage(
      name: 'Contact',
      elements: [
        PageElement(
          elementType: ElementType.navbar,
          x: 0, y: 0, width: 390, height: 60,
          properties: {
            'brandName': brandName,
            'backgroundColor': '#050510',
            'textColor': '#FFFFFF',
            'showCart': false,
            'showLogin': false,
            'menuItems': ['Home', 'Projects', 'About', 'Contact'],
          },
        ),
        PageElement(
          elementType: ElementType.heading,
          x: 20, y: 80, width: 350, height: 50,
          properties: {
            'content': 'Let\'s Work Together',
            'fontSize': 26.0,
            'fontWeight': 'bold',
            'color': '#FFFFFF',
            'textAlign': 'center',
            'fontFamily': 'Inter',
          },
        ),
        PageElement(
          elementType: ElementType.contactForm,
          x: 10, y: 145, width: 370, height: 380,
          properties: {
            'title': '',
            'fields': ['name', 'email', 'subject', 'message'],
            'submitLabel': 'Send Message',
            'backgroundColor': '#0C0C20',
            'accentColor': '#06B6D4',
            'emailTarget': '',
          },
        ),
      ],
    );
  }
}
