enum ElementType {
  text,
  heading,
  image,
  button,
  productCard,
  navbar,
  hero,
  contactForm,
  section,
  divider,
  testimonial,
  featureCard,
  teamCard,
  pricingCard,
  blogPostCard,
  faqItem,
  spacer,
  footer,
  cartButton,
  socialLinks,
  // New element types
  video,
  map,
  countdown,
  gallery,
  accordion,
  statsCounter,
}

extension ElementTypeExtension on ElementType {
  String get displayName {
    switch (this) {
      case ElementType.text: return 'Text';
      case ElementType.heading: return 'Heading';
      case ElementType.image: return 'Image';
      case ElementType.button: return 'Button';
      case ElementType.productCard: return 'Product Card';
      case ElementType.navbar: return 'Navigation Bar';
      case ElementType.hero: return 'Hero Banner';
      case ElementType.contactForm: return 'Contact Form';
      case ElementType.section: return 'Section';
      case ElementType.divider: return 'Divider';
      case ElementType.testimonial: return 'Testimonial';
      case ElementType.featureCard: return 'Feature Card';
      case ElementType.teamCard: return 'Team Card';
      case ElementType.pricingCard: return 'Pricing Card';
      case ElementType.blogPostCard: return 'Blog Post';
      case ElementType.faqItem: return 'FAQ Item';
      case ElementType.spacer: return 'Spacer';
      case ElementType.footer: return 'Footer';
      case ElementType.cartButton: return 'Cart Button';
      case ElementType.socialLinks: return 'Social Links';
      case ElementType.video: return 'Video';
      case ElementType.map: return 'Map';
      case ElementType.countdown: return 'Countdown';
      case ElementType.gallery: return 'Gallery';
      case ElementType.accordion: return 'Accordion';
      case ElementType.statsCounter: return 'Stats Counter';
    }
  }

  String get iconName {
    switch (this) {
      case ElementType.text: return 'text_fields';
      case ElementType.heading: return 'title';
      case ElementType.image: return 'image';
      case ElementType.button: return 'smart_button';
      case ElementType.productCard: return 'shopping_bag';
      case ElementType.navbar: return 'menu';
      case ElementType.hero: return 'view_carousel';
      case ElementType.contactForm: return 'contact_mail';
      case ElementType.section: return 'view_agenda';
      case ElementType.divider: return 'horizontal_rule';
      case ElementType.testimonial: return 'format_quote';
      case ElementType.featureCard: return 'star';
      case ElementType.teamCard: return 'person';
      case ElementType.pricingCard: return 'payments';
      case ElementType.blogPostCard: return 'article';
      case ElementType.faqItem: return 'help';
      case ElementType.spacer: return 'space_bar';
      case ElementType.footer: return 'web';
      case ElementType.cartButton: return 'shopping_cart';
      case ElementType.socialLinks: return 'share';
      case ElementType.video: return 'videocam';
      case ElementType.map: return 'map';
      case ElementType.countdown: return 'timer';
      case ElementType.gallery: return 'grid_view';
      case ElementType.accordion: return 'expand_more';
      case ElementType.statsCounter: return 'bar_chart';
    }
  }

  String get category {
    switch (this) {
      case ElementType.text:
      case ElementType.heading:
      case ElementType.divider:
      case ElementType.spacer:
        return 'Content';
      case ElementType.image:
      case ElementType.hero:
      case ElementType.video:
      case ElementType.gallery:
        return 'Media';
      case ElementType.button:
      case ElementType.cartButton:
      case ElementType.socialLinks:
        return 'Actions';
      case ElementType.productCard:
      case ElementType.pricingCard:
        return 'Store';
      case ElementType.navbar:
      case ElementType.footer:
        return 'Navigation';
      case ElementType.contactForm:
      case ElementType.faqItem:
      case ElementType.accordion:
        return 'Forms';
      case ElementType.testimonial:
      case ElementType.featureCard:
      case ElementType.teamCard:
      case ElementType.blogPostCard:
      case ElementType.section:
      case ElementType.map:
      case ElementType.countdown:
      case ElementType.statsCounter:
        return 'Sections';
    }
  }
}
