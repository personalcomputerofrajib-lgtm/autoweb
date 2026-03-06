import '../models/website_project.dart';
import '../models/page_element.dart';
import '../models/element_type.dart';

class BusinessTemplate {
  static WebsiteProject create(String name) {
    return WebsiteProject(
      name: name,
      category: 'Business',
      pages: [_homePage(name), _servicesPage(name), _teamPage(name), _contactPage(name)],
      globalSettings: {
        'primaryColor': '#3B82F6',
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
            'backgroundColor': '#050A14',
            'textColor': '#FFFFFF',
            'showCart': false,
            'showLogin': false,
            'menuItems': ['Home', 'Services', 'Team', 'Contact'],
          },
        ),
        PageElement(
          elementType: ElementType.hero,
          x: 0, y: 60, width: 390, height: 300,
          properties: {
            'title': 'We Build Dreams Into Reality',
            'subtitle': 'A full-service agency specializing in growth, design & technology.',
            'buttonLabel': 'Our Services',
            'buttonAction': 'page:Services',
            'backgroundImageUrl': '',
            'backgroundColor': '#050A14',
            'overlayOpacity': 0.0,
            'textColor': '#FFFFFF',
          },
        ),
        PageElement(
          elementType: ElementType.heading,
          x: 20, y: 375, width: 350, height: 44,
          properties: {
            'content': 'Why Choose Us',
            'fontSize': 22.0,
            'fontWeight': 'bold',
            'color': '#FFFFFF',
            'textAlign': 'center',
            'fontFamily': 'Inter',
          },
        ),
        PageElement(
          elementType: ElementType.featureCard,
          x: 10, y: 428, width: 175, height: 130,
          properties: {
            'title': '10+ Years',
            'description': 'Industry experience.',
            'icon': 'workspace_premium',
            'iconColor': '#3B82F6',
            'backgroundColor': '#0A1428',
            'borderRadius': 16.0,
          },
        ),
        PageElement(
          elementType: ElementType.featureCard,
          x: 200, y: 428, width: 175, height: 130,
          properties: {
            'title': '500+ Clients',
            'description': 'Across 20 countries.',
            'icon': 'groups',
            'iconColor': '#3B82F6',
            'backgroundColor': '#0A1428',
            'borderRadius': 16.0,
          },
        ),
        PageElement(
          elementType: ElementType.featureCard,
          x: 10, y: 568, width: 175, height: 130,
          properties: {
            'title': '98% Satisfaction',
            'description': 'Client satisfaction rate.',
            'icon': 'thumb_up',
            'iconColor': '#3B82F6',
            'backgroundColor': '#0A1428',
            'borderRadius': 16.0,
          },
        ),
        PageElement(
          elementType: ElementType.featureCard,
          x: 200, y: 568, width: 175, height: 130,
          properties: {
            'title': '24/7 Support',
            'description': 'We\'re always here.',
            'icon': 'support_agent',
            'iconColor': '#3B82F6',
            'backgroundColor': '#0A1428',
            'borderRadius': 16.0,
          },
        ),
        PageElement(
          elementType: ElementType.footer,
          x: 0, y: 720, width: 390, height: 110,
          properties: {
            'brandName': brandName,
            'tagline': 'Building the future together.',
            'links': ['Services', 'Team', 'Privacy', 'Contact'],
            'backgroundColor': '#020509',
            'textColor': '#666677',
            'showSocial': true,
          },
        ),
      ],
    );
  }

  static SitePage _servicesPage(String brandName) {
    return SitePage(
      name: 'Services',
      elements: [
        PageElement(
          elementType: ElementType.navbar,
          x: 0, y: 0, width: 390, height: 60,
          properties: {
            'brandName': brandName,
            'backgroundColor': '#050A14',
            'textColor': '#FFFFFF',
            'showCart': false,
            'showLogin': false,
            'menuItems': ['Home', 'Services', 'Team', 'Contact'],
          },
        ),
        PageElement(
          elementType: ElementType.heading,
          x: 20, y: 75, width: 350, height: 50,
          properties: {
            'content': 'Our Services',
            'fontSize': 26.0,
            'fontWeight': 'bold',
            'color': '#FFFFFF',
            'textAlign': 'left',
            'fontFamily': 'Inter',
          },
        ),
        PageElement(
          elementType: ElementType.featureCard,
          x: 10, y: 135, width: 370, height: 100,
          properties: {
            'title': 'Web Design & Development',
            'description': 'Custom websites that convert visitors into customers.',
            'icon': 'web',
            'iconColor': '#3B82F6',
            'backgroundColor': '#0A1428',
            'borderRadius': 16.0,
          },
        ),
        PageElement(
          elementType: ElementType.featureCard,
          x: 10, y: 245, width: 370, height: 100,
          properties: {
            'title': 'Digital Marketing',
            'description': 'SEO, social media, and paid ads to grow your reach.',
            'icon': 'trending_up',
            'iconColor': '#3B82F6',
            'backgroundColor': '#0A1428',
            'borderRadius': 16.0,
          },
        ),
        PageElement(
          elementType: ElementType.featureCard,
          x: 10, y: 355, width: 370, height: 100,
          properties: {
            'title': 'Brand Strategy',
            'description': 'Build a brand identity that stands out and resonates.',
            'icon': 'lightbulb',
            'iconColor': '#3B82F6',
            'backgroundColor': '#0A1428',
            'borderRadius': 16.0,
          },
        ),
        PageElement(
          elementType: ElementType.featureCard,
          x: 10, y: 465, width: 370, height: 100,
          properties: {
            'title': 'Mobile App Development',
            'description': 'iOS and Android apps for your business.',
            'icon': 'phone_android',
            'iconColor': '#3B82F6',
            'backgroundColor': '#0A1428',
            'borderRadius': 16.0,
          },
        ),
        PageElement(
          elementType: ElementType.button,
          x: 60, y: 585, width: 270, height: 54,
          properties: {
            'label': 'Get A Free Quote',
            'backgroundColor': '#3B82F6',
            'textColor': '#FFFFFF',
            'borderRadius': 14.0,
            'fontSize': 16.0,
            'fontWeight': 'semibold',
            'action': 'page',
            'actionTarget': 'Contact',
            'icon': 'arrow_forward',
          },
        ),
      ],
    );
  }

  static SitePage _teamPage(String brandName) {
    return SitePage(
      name: 'Team',
      elements: [
        PageElement(
          elementType: ElementType.navbar,
          x: 0, y: 0, width: 390, height: 60,
          properties: {
            'brandName': brandName,
            'backgroundColor': '#050A14',
            'textColor': '#FFFFFF',
            'showCart': false,
            'showLogin': false,
            'menuItems': ['Home', 'Services', 'Team', 'Contact'],
          },
        ),
        PageElement(
          elementType: ElementType.heading,
          x: 20, y: 75, width: 350, height: 50,
          properties: {
            'content': 'Meet the Team',
            'fontSize': 26.0,
            'fontWeight': 'bold',
            'color': '#FFFFFF',
            'textAlign': 'left',
            'fontFamily': 'Inter',
          },
        ),
        PageElement(
          elementType: ElementType.teamCard,
          x: 10, y: 135, width: 370, height: 140,
          properties: {
            'name': 'Arjun Sharma',
            'role': 'CEO & Co-Founder',
            'imageUrl': '',
            'bio': 'Visionary leader with 12 years in digital transformation.',
            'social': {'twitter': '', 'linkedin': ''},
            'backgroundColor': '#0A1428',
          },
        ),
        PageElement(
          elementType: ElementType.teamCard,
          x: 10, y: 285, width: 370, height: 140,
          properties: {
            'name': 'Nisha Patel',
            'role': 'Design Director',
            'imageUrl': '',
            'bio': 'Award-winning designer who loves clean, purposeful UI.',
            'social': {'twitter': '', 'linkedin': ''},
            'backgroundColor': '#0A1428',
          },
        ),
        PageElement(
          elementType: ElementType.teamCard,
          x: 10, y: 435, width: 370, height: 140,
          properties: {
            'name': 'Kiran Dev',
            'role': 'Lead Engineer',
            'imageUrl': '',
            'bio': 'Full-stack engineer passionate about performance and scale.',
            'social': {'twitter': '', 'linkedin': ''},
            'backgroundColor': '#0A1428',
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
            'backgroundColor': '#050A14',
            'textColor': '#FFFFFF',
            'showCart': false,
            'showLogin': false,
            'menuItems': ['Home', 'Services', 'Team', 'Contact'],
          },
        ),
        PageElement(
          elementType: ElementType.heading,
          x: 20, y: 75, width: 350, height: 50,
          properties: {
            'content': 'Contact Us',
            'fontSize': 26.0,
            'fontWeight': 'bold',
            'color': '#FFFFFF',
            'textAlign': 'left',
            'fontFamily': 'Inter',
          },
        ),
        PageElement(
          elementType: ElementType.contactForm,
          x: 10, y: 135, width: 370, height: 400,
          properties: {
            'title': '',
            'fields': ['name', 'email', 'company', 'message'],
            'submitLabel': 'Send Enquiry',
            'backgroundColor': '#0A1428',
            'accentColor': '#3B82F6',
            'emailTarget': '',
          },
        ),
        PageElement(
          elementType: ElementType.faqItem,
          x: 10, y: 555, width: 370, height: 100,
          properties: {
            'question': 'How soon can you start my project?',
            'answer': 'We typically begin new projects within 1–2 weeks of onboarding.',
            'backgroundColor': '#0A1428',
            'accentColor': '#3B82F6',
            'expanded': false,
          },
        ),
        PageElement(
          elementType: ElementType.faqItem,
          x: 10, y: 665, width: 370, height: 100,
          properties: {
            'question': 'What is your pricing model?',
            'answer': 'We offer fixed-price projects and monthly retainers based on your needs.',
            'backgroundColor': '#0A1428',
            'accentColor': '#3B82F6',
            'expanded': false,
          },
        ),
      ],
    );
  }
}
