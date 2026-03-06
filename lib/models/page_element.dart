import 'package:uuid/uuid.dart';
import 'element_type.dart';

class PageElement {
  final String id;
  final ElementType elementType;
  double x;
  double y;
  double width;
  double height;
  Map<String, dynamic> properties;
  List<PageElement> children;

  PageElement({
    String? id,
    required this.elementType,
    this.x = 0,
    this.y = 0,
    this.width = 300,
    this.height = 80,
    Map<String, dynamic>? properties,
    List<PageElement>? children,
  })  : id = id ?? const Uuid().v4(),
        properties = properties ?? _defaultProperties(elementType),
        children = children ?? [];

  static Map<String, dynamic> _defaultProperties(ElementType type) {
    switch (type) {
      case ElementType.text:
        return {
          'content': 'Your text here. Tap to edit.',
          'fontSize': 16.0,
          'fontWeight': 'normal',
          'color': '#FFFFFF',
          'textAlign': 'left',
          'fontFamily': 'Inter',
        };
      case ElementType.heading:
        return {
          'content': 'Section Heading',
          'fontSize': 28.0,
          'fontWeight': 'bold',
          'color': '#FFFFFF',
          'textAlign': 'center',
          'fontFamily': 'Inter',
        };
      case ElementType.image:
        return {
          'imageUrl': '',
          'placeholderColor': '#1E1E3A',
          'borderRadius': 12.0,
          'objectFit': 'cover',
          'altText': 'Image',
        };
      case ElementType.button:
        return {
          'label': 'Click Me',
          'backgroundColor': '#7C3AED',
          'textColor': '#FFFFFF',
          'borderRadius': 14.0,
          'fontSize': 15.0,
          'fontWeight': 'semibold',
          'action': 'none',
          'actionTarget': '',
          'icon': '',
        };
      case ElementType.productCard:
        return {
          'productName': 'Product Name',
          'price': '₹999',
          'originalPrice': '₹1,499',
          'imageUrl': '',
          'description': 'Short product description.',
          'badge': 'NEW',
          'backgroundColor': '#12122A',
          'borderRadius': 16.0,
        };
      case ElementType.navbar:
        return {
          'brandName': 'My Brand',
          'backgroundColor': '#0A0A1A',
          'textColor': '#FFFFFF',
          'showCart': true,
          'showLogin': true,
          'menuItems': ['Home', 'Shop', 'About', 'Contact'],
        };
      case ElementType.hero:
        return {
          'title': 'Welcome to My Website',
          'subtitle': 'Your compelling tagline goes here.',
          'buttonLabel': 'Get Started',
          'buttonAction': 'scroll',
          'backgroundImageUrl': '',
          'backgroundColor': '#1A0A3A',
          'overlayOpacity': 0.5,
          'textColor': '#FFFFFF',
        };
      case ElementType.contactForm:
        return {
          'title': 'Get In Touch',
          'fields': ['name', 'email', 'message'],
          'submitLabel': 'Send Message',
          'backgroundColor': '#12122A',
          'accentColor': '#7C3AED',
          'emailTarget': '',
        };
      case ElementType.section:
        return {
          'backgroundColor': '#0A0A1A',
          'paddingVertical': 40.0,
          'paddingHorizontal': 20.0,
          'borderRadius': 0.0,
        };
      case ElementType.divider:
        return {
          'color': '#2A2A4A',
          'thickness': 1.0,
          'style': 'solid',
        };
      case ElementType.testimonial:
        return {
          'quote': '"This product changed my life! Absolutely amazing."',
          'authorName': 'Jane Doe',
          'authorRole': 'Happy Customer',
          'rating': 5,
          'backgroundColor': '#12122A',
          'accentColor': '#7C3AED',
        };
      case ElementType.featureCard:
        return {
          'title': 'Feature Title',
          'description': 'Description of this amazing feature.',
          'icon': 'star',
          'iconColor': '#7C3AED',
          'backgroundColor': '#12122A',
          'borderRadius': 16.0,
        };
      case ElementType.teamCard:
        return {
          'name': 'Team Member',
          'role': 'Position / Role',
          'imageUrl': '',
          'bio': 'Short bio about this team member.',
          'social': {'twitter': '', 'linkedin': ''},
          'backgroundColor': '#12122A',
        };
      case ElementType.pricingCard:
        return {
          'planName': 'Pro Plan',
          'price': '₹499',
          'period': '/month',
          'features': ['Feature 1', 'Feature 2', 'Feature 3'],
          'buttonLabel': 'Get Started',
          'isHighlighted': false,
          'backgroundColor': '#12122A',
          'accentColor': '#7C3AED',
        };
      case ElementType.blogPostCard:
        return {
          'title': 'Blog Post Title',
          'excerpt': 'A short excerpt from the blog post...',
          'author': 'Author Name',
          'date': '2025-01-01',
          'category': 'Technology',
          'imageUrl': '',
          'readTime': '5 min read',
          'backgroundColor': '#12122A',
        };
      case ElementType.faqItem:
        return {
          'question': 'What is your refund policy?',
          'answer': 'We offer a 30-day no-questions-asked refund policy.',
          'backgroundColor': '#12122A',
          'accentColor': '#7C3AED',
          'expanded': false,
        };
      case ElementType.spacer:
        return {'height': 40.0};
      case ElementType.footer:
        return {
          'brandName': 'My Brand',
          'tagline': 'Building great things.',
          'links': ['Privacy', 'Terms', 'Contact'],
          'backgroundColor': '#06060F',
          'textColor': '#888899',
          'showSocial': true,
        };
      case ElementType.cartButton:
        return {
          'backgroundColor': '#7C3AED',
          'iconColor': '#FFFFFF',
          'badgeColor': '#FF4D6D',
          'position': 'top-right',
        };
      case ElementType.socialLinks:
        return {
          'platforms': ['instagram', 'twitter', 'facebook'],
          'style': 'icon',
          'color': '#7C3AED',
          'urls': {'instagram': '', 'twitter': '', 'facebook': ''},
        };
      case ElementType.video:
        return {
          'videoUrl': '',
          'thumbnailUrl': '',
          'autoplay': false,
          'loop': false,
          'backgroundColor': '#12122A',
          'borderRadius': 16.0,
          'caption': '',
        };
      case ElementType.map:
        return {
          'address': '123 Main Street, New York, NY',
          'latitude': 40.7128,
          'longitude': -74.0060,
          'zoom': 14,
          'backgroundColor': '#12122A',
          'borderRadius': 16.0,
          'height': 200.0,
        };
      case ElementType.countdown:
        return {
          'targetDate': '2026-01-01T00:00:00',
          'title': 'Coming Soon',
          'subtitle': 'Something exciting is launching',
          'backgroundColor': '#12122A',
          'textColor': '#FFFFFF',
          'accentColor': '#7C3AED',
          'showDays': true,
          'showHours': true,
          'showMinutes': true,
          'showSeconds': true,
        };
      case ElementType.gallery:
        return {
          'images': <String>[],
          'columns': 2,
          'gap': 8.0,
          'borderRadius': 12.0,
          'backgroundColor': '#0A0A1A',
          'caption': 'Gallery',
        };
      case ElementType.accordion:
        return {
          'items': [
            {'title': 'Section 1', 'content': 'Content for section 1.'},
            {'title': 'Section 2', 'content': 'Content for section 2.'},
            {'title': 'Section 3', 'content': 'Content for section 3.'},
          ],
          'backgroundColor': '#12122A',
          'textColor': '#FFFFFF',
          'accentColor': '#7C3AED',
          'borderRadius': 12.0,
        };
      case ElementType.statsCounter:
        return {
          'value': '1000+',
          'label': 'Happy Customers',
          'prefix': '',
          'suffix': '+',
          'backgroundColor': '#12122A',
          'valueColor': '#7C3AED',
          'labelColor': '#AAAACC',
          'borderRadius': 16.0,
        };
    }
  }

  PageElement copyWith({
    ElementType? elementType,
    double? x,
    double? y,
    double? width,
    double? height,
    Map<String, dynamic>? properties,
    List<PageElement>? children,
  }) {
    return PageElement(
      id: id,
      elementType: elementType ?? this.elementType,
      x: x ?? this.x,
      y: y ?? this.y,
      width: width ?? this.width,
      height: height ?? this.height,
      properties: properties ?? Map.from(this.properties),
      children: children ?? List.from(this.children),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'elementType': elementType.name,
      'x': x,
      'y': y,
      'width': width,
      'height': height,
      'properties': properties,
      'children': children.map((c) => c.toJson()).toList(),
    };
  }

  factory PageElement.fromJson(Map<String, dynamic> json) {
    return PageElement(
      id: json['id'],
      elementType: ElementType.values.firstWhere(
        (e) => e.name == json['elementType'],
        orElse: () => ElementType.text,
      ),
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
      width: (json['width'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
      properties: Map<String, dynamic>.from(json['properties'] ?? {}),
      children: (json['children'] as List<dynamic>? ?? [])
          .map((c) => PageElement.fromJson(c as Map<String, dynamic>))
          .toList(),
    );
  }
}
