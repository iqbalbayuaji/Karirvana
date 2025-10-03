# Manual Firebase Console Import Guide

## Step 1: Create Collections
1. Go to Firebase Console → Firestore Database
2. Create collection: `course_categories`
3. Create collection: `courses`

## Step 2: Import Categories
Add these documents to `course_categories` collection:

### Document ID: `programming`
```json
{
  "id": "programming",
  "name": "Programming",
  "displayName": "Pemrograman",
  "description": "Kursus pemrograman dan pengembangan software",
  "icon": "code",
  "color": "#4F46E5",
  "isActive": true,
  "order": 1
}
```

### Document ID: `design`
```json
{
  "id": "design",
  "name": "Design",
  "displayName": "Desain",
  "description": "Kursus UI/UX dan desain grafis",
  "icon": "palette",
  "color": "#3B82F6",
  "isActive": true,
  "order": 2
}
```

### Document ID: `business`
```json
{
  "id": "business",
  "name": "Business",
  "displayName": "Bisnis",
  "description": "Kursus strategi bisnis dan manajemen",
  "icon": "business",
  "color": "#10B981",
  "isActive": true,
  "order": 3
}
```

### Document ID: `marketing`
```json
{
  "id": "marketing",
  "name": "Marketing",
  "displayName": "Pemasaran",
  "description": "Kursus digital marketing dan strategi pemasaran",
  "icon": "trending_up",
  "color": "#F59E0B",
  "isActive": true,
  "order": 4
}
```

### Document ID: `data_science`
```json
{
  "id": "data_science",
  "name": "Data Science",
  "displayName": "Data Science",
  "description": "Kursus analisis data dan machine learning",
  "icon": "analytics",
  "color": "#8B5CF6",
  "isActive": true,
  "order": 5
}
```

### Document ID: `mobile_development`
```json
{
  "id": "mobile_development",
  "name": "Mobile Development",
  "displayName": "Pengembangan Mobile",
  "description": "Kursus pengembangan aplikasi mobile",
  "icon": "phone_android",
  "color": "#EF4444",
  "isActive": true,
  "order": 6
}
```

## Step 3: Import Courses
Add these documents to `courses` collection:

### Document ID: `1`
**Title:** Flutter Development Masterclass
```json
{
  "id": "1",
  "title": "Flutter Development Masterclass",
  "instructor": "Dr. Ahmad Wijaya",
  "instructorBio": "Senior Flutter Developer dengan 8+ tahun pengalaman. Telah mengembangkan 50+ aplikasi mobile dan mengajar 10,000+ siswa.",
  "instructorImage": "assets/images/instructor_ahmad.jpg",
  "category": "Programming",
  "description": "Belajar Flutter dari dasar hingga mahir dengan project nyata. Kursus komprehensif yang mencakup semua aspek pengembangan aplikasi mobile dengan Flutter.",
  "imageUrl": "https://via.placeholder.com/300x200/4F46E5/FFFFFF?text=Flutter",
  "rating": 4.8,
  "totalStudents": 1250,
  "totalLessons": 45,
  "duration": "12 jam",
  "originalPrice": 350000,
  "discountedPrice": 175000,
  "isFree": false,
  "level": "Pemula",
  "discount": "50% Off",
  "showDiscount": true,
  "language": "Bahasa Indonesia",
  "hasCertificate": true,
  "totalReviews": 892,
  "requirements": [
    "Komputer dengan RAM minimal 8GB",
    "Koneksi internet stabil",
    "Dasar pemrograman (opsional)",
    "Android Studio atau VS Code"
  ],
  "whatYouWillLearn": [
    "Membangun aplikasi Flutter dari nol",
    "State management dengan Provider dan Bloc",
    "Integrasi API dan database",
    "Deployment ke Play Store dan App Store",
    "Best practices dalam pengembangan Flutter"
  ],
  "isActive": true
}
```

### Document ID: `2`
**Title:** UI/UX Design Fundamentals
```json
{
  "id": "2",
  "title": "UI/UX Design Fundamentals",
  "instructor": "Sarah Putri",
  "instructorBio": "UI/UX Designer berpengalaman 6+ tahun di startup dan korporasi. Spesialis dalam user research dan design thinking.",
  "instructorImage": "assets/images/instructor_sarah.jpg",
  "category": "Design",
  "description": "Pelajari prinsip desain UI/UX yang efektif dan modern. Dari research hingga prototyping.",
  "imageUrl": "https://via.placeholder.com/300x200/3B82F6/FFFFFF?text=UI%2FUX",
  "rating": 4.9,
  "totalStudents": 890,
  "totalLessons": 32,
  "duration": "8 jam",
  "originalPrice": 250000,
  "discountedPrice": 125000,
  "isFree": false,
  "level": "Pemula",
  "discount": "50% Off",
  "showDiscount": true,
  "language": "Bahasa Indonesia",
  "hasCertificate": true,
  "totalReviews": 743,
  "requirements": [
    "Figma atau Adobe XD",
    "Kreativitas dan minat pada design",
    "Tidak perlu pengalaman sebelumnya"
  ],
  "whatYouWillLearn": [
    "Prinsip dasar UI/UX Design",
    "User research dan persona",
    "Wireframing dan prototyping",
    "Design system dan style guide"
  ],
  "isActive": true
}
```

### Document ID: `3`
**Title:** Digital Marketing Strategy
```json
{
  "id": "3",
  "title": "Digital Marketing Strategy",
  "instructor": "Budi Santoso",
  "instructorBio": "Digital Marketing Expert dengan track record mengelola campaign untuk 100+ brand. Certified Google Ads dan Facebook Blueprint.",
  "instructorImage": "assets/images/instructor_budi.jpg",
  "category": "Marketing",
  "description": "Strategi pemasaran digital yang terbukti efektif untuk meningkatkan brand awareness dan penjualan.",
  "imageUrl": "https://via.placeholder.com/300x200/10B981/FFFFFF?text=Marketing",
  "rating": 4.7,
  "totalStudents": 2100,
  "totalLessons": 28,
  "duration": "6 jam",
  "originalPrice": 0,
  "discountedPrice": 0,
  "isFree": true,
  "level": "Pemula",
  "discount": "",
  "showDiscount": false,
  "language": "Bahasa Indonesia",
  "hasCertificate": true,
  "totalReviews": 1470,
  "requirements": [
    "Akses internet",
    "Akun media sosial",
    "Minat pada digital marketing"
  ],
  "whatYouWillLearn": [
    "Strategi content marketing",
    "Social media advertising",
    "Google Ads dan SEO",
    "Analytics dan reporting"
  ],
  "isActive": true
}
```

### Document ID: `4`
**Title:** Python for Data Science
```json
{
  "id": "4",
  "title": "Python for Data Science",
  "instructor": "Prof. Lisa Chen",
  "instructorBio": "Data Scientist dengan PhD dari Stanford. Berpengalaman 10+ tahun di industri tech dan telah menerbitkan 50+ paper penelitian.",
  "instructorImage": "assets/images/instructor_lisa.jpg",
  "category": "Data Science",
  "description": "Belajar Python untuk analisis data, machine learning, dan visualisasi data dengan library populer.",
  "imageUrl": "https://via.placeholder.com/300x200/8B5CF6/FFFFFF?text=Python",
  "rating": 4.9,
  "totalStudents": 1800,
  "totalLessons": 52,
  "duration": "15 jam",
  "originalPrice": 399000,
  "discountedPrice": 0,
  "isFree": false,
  "level": "Menengah",
  "discount": "",
  "showDiscount": false,
  "language": "Bahasa Indonesia",
  "hasCertificate": true,
  "totalReviews": 1260,
  "requirements": [
    "Dasar pemrograman Python",
    "Matematika dasar",
    "Jupyter Notebook"
  ],
  "whatYouWillLearn": [
    "Pandas dan NumPy",
    "Data visualization dengan Matplotlib",
    "Machine learning dengan Scikit-learn",
    "Statistical analysis"
  ],
  "isActive": true
}
```

### Document ID: `5`
**Title:** Business Strategy & Planning
```json
{
  "id": "5",
  "title": "Business Strategy & Planning",
  "instructor": "Michael Johnson",
  "instructorBio": "Former McKinsey consultant dan CEO startup yang sukses exit. MBA dari Harvard Business School.",
  "instructorImage": "assets/images/instructor_michael.jpg",
  "category": "Business",
  "description": "Pelajari cara membuat strategi bisnis yang efektif dan rencana bisnis yang solid.",
  "imageUrl": "https://via.placeholder.com/300x200/F59E0B/FFFFFF?text=Business",
  "rating": 4.6,
  "totalStudents": 950,
  "totalLessons": 35,
  "duration": "10 jam",
  "originalPrice": 300000,
  "discountedPrice": 180000,
  "isFree": false,
  "level": "Menengah",
  "discount": "40% Off",
  "showDiscount": true,
  "language": "Bahasa Indonesia",
  "hasCertificate": true,
  "totalReviews": 665,
  "requirements": [
    "Pengalaman bisnis dasar",
    "Minat pada entrepreneurship",
    "Akses ke studi kasus"
  ],
  "whatYouWillLearn": [
    "Strategic planning framework",
    "Market analysis dan competitive intelligence",
    "Financial modeling",
    "Business model canvas"
  ],
  "isActive": true
}
```

### Document ID: `6`
**Title:** React Native Development
```json
{
  "id": "6",
  "title": "React Native Development",
  "instructor": "Kevin Pratama",
  "instructorBio": "Senior Mobile Developer di unicorn startup. Expert React Native dengan 5+ tahun pengalaman dan contributor open source.",
  "instructorImage": "assets/images/instructor_kevin.jpg",
  "category": "Mobile Development",
  "description": "Bangun aplikasi mobile cross-platform dengan React Native. Dari basic hingga advanced concepts.",
  "imageUrl": "https://via.placeholder.com/300x200/EF4444/FFFFFF?text=React",
  "rating": 4.8,
  "totalStudents": 1100,
  "totalLessons": 48,
  "duration": "14 jam",
  "originalPrice": 349000,
  "discountedPrice": 0,
  "isFree": false,
  "level": "Menengah",
  "discount": "",
  "showDiscount": false,
  "language": "Bahasa Indonesia",
  "hasCertificate": true,
  "totalReviews": 770,
  "requirements": [
    "JavaScript ES6+",
    "React fundamentals",
    "Node.js dan npm"
  ],
  "whatYouWillLearn": [
    "React Native components",
    "Navigation dan state management",
    "Native modules integration",
    "App deployment"
  ],
  "isActive": true
}
```

## Step 4: Set Firestore Rules
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /courses/{courseId} {
      allow read: if request.auth != null;
    }
    match /course_categories/{categoryId} {
      allow read: if request.auth != null;
    }
  }
}
```
