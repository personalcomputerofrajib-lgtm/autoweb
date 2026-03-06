import '../models/website_project.dart';
import '../models/page_element.dart';
import '../models/element_type.dart';

class BlogTemplate {
  static WebsiteProject create(String name) {
    return WebsiteProject(
      name: name,
      category: 'Blog',
      pages: [_homePage(name), _postPage(name), _aboutPage(name)],
      globalSettings: {
        'primaryColor': '#F59E0B',
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
            'backgroundColor': '#0D0D0D',
            'textColor': '#FFFFFF',
            'showCart': false,
            'showLogin': false,
            'menuItems': ['Home', 'Posts', 'About', 'Subscribe'],
          },
        ),
        PageElement(
          elementType: ElementType.hero,
          x: 0, y: 60, width: 390, height: 220,
          properties: {
            'title': brandName,
            'subtitle': 'Stories, tutorials, and insights.',
            'buttonLabel': 'Read Latest',
            'buttonAction': 'scroll',
            'backgroundImageUrl': '',
            'backgroundColor': '#1A1006',
            'overlayOpacity': 0.0,
            'textColor': '#FFFFFF',
          },
        ),
        PageElement(
          elementType: ElementType.heading,
          x: 20, y: 295, width: 350, height: 44,
          properties: {
            'content': 'Latest Posts',
            'fontSize': 22.0,
            'fontWeight': 'bold',
            'color': '#FFFFFF',
            'textAlign': 'left',
            'fontFamily': 'Inter',
          },
        ),
        PageElement(
          elementType: ElementType.blogPostCard,
          x: 10, y: 345, width: 370, height: 180,
          properties: {
            'title': '10 Design Trends Dominating 2025',
            'excerpt': 'From glassmorphism to AI-driven layouts, these trends are reshaping the web...',
            'author': 'Ananya Verma',
            'date': '2025-06-01',
            'category': 'Design',
            'imageUrl': '',
            'readTime': '5 min read',
            'backgroundColor': '#1A1A1A',
          },
        ),
        PageElement(
          elementType: ElementType.blogPostCard,
          x: 10, y: 535, width: 370, height: 180,
          properties: {
            'title': 'Building Your First Flutter App',
            'excerpt': 'A step-by-step guide to getting started with Flutter and Dart for beginners...',
            'author': 'Rahul Mehta',
            'date': '2025-05-15',
            'category': 'Development',
            'imageUrl': '',
            'readTime': '8 min read',
            'backgroundColor': '#1A1A1A',
          },
        ),
        PageElement(
          elementType: ElementType.blogPostCard,
          x: 10, y: 725, width: 370, height: 180,
          properties: {
            'title': 'How to Grow Your Newsletter to 10K',
            'excerpt': 'Practical strategies I used to grow my newsletter from zero to ten thousand subscribers...',
            'author': 'Priya Sinha',
            'date': '2025-04-28',
            'category': 'Growth',
            'imageUrl': '',
            'readTime': '6 min read',
            'backgroundColor': '#1A1A1A',
          },
        ),
        PageElement(
          elementType: ElementType.footer,
          x: 0, y: 925, width: 390, height: 100,
          properties: {
            'brandName': brandName,
            'tagline': 'Ideas worth sharing.',
            'links': ['Home', 'About', 'Privacy'],
            'backgroundColor': '#080808',
            'textColor': '#666677',
            'showSocial': true,
          },
        ),
      ],
    );
  }

  static SitePage _postPage(String brandName) {
    return SitePage(
      name: 'Post',
      elements: [
        PageElement(
          elementType: ElementType.navbar,
          x: 0, y: 0, width: 390, height: 60,
          properties: {
            'brandName': brandName,
            'backgroundColor': '#0D0D0D',
            'textColor': '#FFFFFF',
            'showCart': false,
            'showLogin': false,
            'menuItems': ['Home', 'Posts', 'About'],
          },
        ),
        PageElement(
          elementType: ElementType.image,
          x: 0, y: 60, width: 390, height: 220,
          properties: {
            'imageUrl': '',
            'placeholderColor': '#1A1A1A',
            'borderRadius': 0.0,
            'objectFit': 'cover',
            'altText': 'Post Hero Image',
          },
        ),
        PageElement(
          elementType: ElementType.text,
          x: 20, y: 290, width: 350, height: 30,
          properties: {
            'content': 'Design  •  5 min read  •  June 1, 2025',
            'fontSize': 12.0,
            'fontWeight': 'normal',
            'color': '#F59E0B',
            'textAlign': 'left',
            'fontFamily': 'Inter',
          },
        ),
        PageElement(
          elementType: ElementType.heading,
          x: 20, y: 325, width: 350, height: 80,
          properties: {
            'content': '10 Design Trends Dominating 2025',
            'fontSize': 24.0,
            'fontWeight': 'bold',
            'color': '#FFFFFF',
            'textAlign': 'left',
            'fontFamily': 'Inter',
          },
        ),
        PageElement(
          elementType: ElementType.text,
          x: 20, y: 415, width: 350, height: 200,
          properties: {
            'content': 'Design is always evolving. What\'s exciting about 2025 is how AI tools are beginning to augment the creative process without replacing the human eye for aesthetics and user empathy. From glassmorphism making a comeback to bold typography, here are the trends you need to know.',
            'fontSize': 15.0,
            'fontWeight': 'normal',
            'color': '#CCCCDD',
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
            'backgroundColor': '#0D0D0D',
            'textColor': '#FFFFFF',
            'showCart': false,
            'showLogin': false,
            'menuItems': ['Home', 'Posts', 'About'],
          },
        ),
        PageElement(
          elementType: ElementType.heading,
          x: 20, y: 80, width: 350, height: 50,
          properties: {
            'content': 'About the Author',
            'fontSize': 24.0,
            'fontWeight': 'bold',
            'color': '#FFFFFF',
            'textAlign': 'left',
            'fontFamily': 'Inter',
          },
        ),
        PageElement(
          elementType: ElementType.image,
          x: 130, y: 140, width: 130, height: 130,
          properties: {
            'imageUrl': '',
            'placeholderColor': '#1A1A1A',
            'borderRadius': 65.0,
            'objectFit': 'cover',
            'altText': 'Author Photo',
          },
        ),
        PageElement(
          elementType: ElementType.text,
          x: 20, y: 285, width: 350, height: 120,
          properties: {
            'content': 'I write about design, tech, and building things on the internet. I\'ve been writing here for 3 years and have been read by over 50,000 people worldwide.',
            'fontSize': 15.0,
            'fontWeight': 'normal',
            'color': '#CCCCDD',
            'textAlign': 'center',
            'fontFamily': 'Inter',
          },
        ),
      ],
    );
  }
}
