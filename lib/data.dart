import 'models.dart';

const int bookingOpenHour = 9;
const int bookingCloseHour = 18;
const int bookingSlotMinutes = 30;
const int bookingWindowDays = 30;

const businessInfo = BusinessInfo(
  name: 'PSSalon',
  tagline: 'Unisex Salon',
  address: "11941 Reisterstown Rd, Reisterstown, MD 21136",
  phone: "(443) 744-8163",
  hours: "Daily 9:00 AM - 6:00 PM",
);

final seedServices = <Service>[
  const Service(
    id: 'svc_haircut',
    name: 'Haircut',
    price: 20,
    durationMinutes: 30,
    description: 'Clean, precise cut tailored to your style.',
  ),
  const Service(
    id: 'svc_haircut_beard',
    name: 'Haircut + Beard',
    price: 30,
    durationMinutes: 45,
    description: 'Signature cut with beard detailing.',
  ),
  const Service(
    id: 'svc_special',
    name: 'Special Haircut',
    price: 28,
    durationMinutes: 45,
    description: 'Extended session for styling or consultation.',
  ),
  const Service(
    id: 'svc_straighten',
    name: 'Straightening',
    price: 20,
    durationMinutes: 30,
    description: 'Smooth finish and polished look.',
  ),
  const Service(
    id: 'svc_facial',
    name: 'Facial',
    price: 35,
    durationMinutes: 45,
    description: 'Relaxing facial treatment for fresh skin.',
  ),
  const Service(
    id: 'svc_facial_massage',
    name: 'Facial Massage',
    price: 35,
    durationMinutes: 45,
    description: 'Soothing massage for tension relief.',
  ),
];

final seedStaff = <StaffMember>[
  const StaffMember(
    id: 'staff_jack',
    name: 'Jack',
    specialty: 'Classic cuts and fades',
  ),
  const StaffMember(
    id: 'staff_mark',
    name: 'Mark',
    specialty: 'Beard shaping and detailing',
  ),
  const StaffMember(
    id: 'staff_emily',
    name: 'Emily',
    specialty: 'Styling and straightening',
  ),
];

final seedReviews = <Review>[
  const Review(
    id: 'rev_1',
    author: 'David R.',
    source: 'Google Reviews',
    rating: 5,
    text: 'Clean shop, sharp cut, and friendly service. Highly recommend.',
  ),
  const Review(
    id: 'rev_2',
    author: 'Maria L.',
    source: 'Website Reviews',
    rating: 5,
    text: 'Booked quickly and loved the attention to detail.',
  ),
  const Review(
    id: 'rev_3',
    author: 'Kevin S.',
    source: 'Google Reviews',
    rating: 4,
    text: 'Great experience and solid pricing. Will be back.',
  ),
];

final seedGallery = <GalleryItem>[
  const GalleryItem(
    id: 'gal_1',
    title: 'Classic Cut',
    subtitle: 'Clean lines and sharp finish',
    imagePath: 'assets/gallery/classic_cut.png',
  ),
  const GalleryItem(
    id: 'gal_2',
    title: 'Modern Fade',
    subtitle: 'Precision blend and taper',
    imagePath: 'assets/gallery/modern_fade.png',
  ),
  const GalleryItem(
    id: 'gal_3',
    title: 'Beard Detail',
    subtitle: 'Crisp shaping and trim',
    imagePath: 'assets/gallery/beard_detail.png',
  ),
  const GalleryItem(
    id: 'gal_4',
    title: 'Straightening',
    subtitle: 'Smooth and polished',
    imagePath: 'assets/gallery/straightening.png',
  ),
  const GalleryItem(
    id: 'gal_5',
    title: 'Facial Care',
    subtitle: 'Refresh and relax',
    imagePath: 'assets/gallery/facial_care.png',
  ),
  const GalleryItem(
    id: 'gal_6',
    title: 'Style Finish',
    subtitle: 'Modern and refined',
    imagePath: 'assets/gallery/style_finish.png',
  ),
];
