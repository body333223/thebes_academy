# Theeba Academy Portal — AI Design & Build Specification

Use this file as the single source of truth when rebuilding, extending, or generating new screens for the Theeba Academy mobile app. Follow every section exactly.

---

## 1. Project Identity

| Field | Value |
|---|---|
| App Name | Theeba Academy Portal |
| App Type | Mobile-first student portal (React web app rendered at ~390px wide) |
| Tagline | Empowering Future Leaders |
| Short Code | TA |
| Target Users | University students, academic staff |
| Tech Stack | React 19, Vite 8, TypeScript, Tailwind CSS v4 |

---

## 2. Color System

Use these exact hex values. Never substitute.

| Token | Hex | Usage |
|---|---|---|
| Navy (Primary) | `#1A2B5F` | Headers, nav bars, primary backgrounds, headings |
| Navy Dark | `#0F1A3D` | Deep backgrounds, status bars |
| Navy Light | `#2A3F7F` | Gradient endpoints, secondary surfaces |
| Orange (Accent) | `#FF6B2B` | CTAs, active states, badges, progress fill, alerts |
| Orange Light | `#FF8C55` | Gradient endpoints, hover states |
| Orange Pale | `#FFF0EA` | Card backgrounds tinted orange |
| Sky | `#E8EEFF` | Card backgrounds tinted blue, info surfaces |
| Mint | `#00C9A7` | Success states, third accent, ecology/health tones |
| Slate | `#64748B` | Body text, secondary labels |
| White | `#FFFFFF` | Card surfaces, modal backgrounds |
| Page BG | `#F8FAFC` | App page background |

### Gradients

```
Primary header gradient : linear-gradient(160deg, #1A2B5F 0%, #2A3F7F 100%)
Orange CTA gradient     : linear-gradient(90deg, #FF6B2B, #FF8C55)
Logo/icon gradient      : linear-gradient(135deg, #1A2B5F, #FF6B2B)
Splash background       : linear-gradient(160deg, #1A2B5F 0%, #2A3F7F 50%, #1A2B5F 100%)
```

### Subject / Category Color Map

Each academic subject or card category gets a consistent background + accent pair:

| Category | Background | Text Accent |
|---|---|---|
| Computer Science | `#E8EEFF` | `#1A2B5F` |
| Marketing / Business | `#FFF0EA` | `#FF6B2B` |
| Science / Health | `#E8FFF6` | `#00C9A7` |
| Mathematics / Engineering | `#F3E8FF` | `#7C3AED` |
| Languages / Arts | `#FEF3C7` | `#F59E0B` |
| Alerts / Urgent | `#FFE4E4` | `#EF4444` |

---

## 3. Typography

**Font Family:** `Poppins` (Google Fonts — import before all other CSS)

```css
@import url('https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap');
```

Apply globally:
```css
* { font-family: 'Poppins', system-ui, sans-serif; }
```

### Type Scale (inside 200px phone frame)

| Role | Size | Weight | Color |
|---|---|---|---|
| Screen title (white on navy) | `text-sm` (14px) | 700 | white |
| Card heading | `text-[11px]` | 700 | `#1E293B` |
| Body / list item | `text-[10px]` | 500–600 | `#334155` |
| Secondary label | `text-[9px]` | 400–500 | `#64748B` |
| Micro label / timestamp | `text-[8px]` | 400 | `#94A3B8` |
| Tiny badge / tag | `text-[7px]`–`text-[8px]` | 600 | varies |

---

## 4. Layout & Spacing

- Mobile canvas: **390 × 844 px** (renders inside a 220×440 phone frame at 0.5× scale for thumbnails)
- All screens are `h-full flex flex-col`
- Header zone: navy gradient, `px-4 pt-2 pb-4`, always contains `<StatusBar light />`
- Content zone: `flex-1 overflow-y-auto px-3 py-3 space-y-3`, `scrollbarWidth: 'none'`
- Bottom nav: fixed at bottom, `pb-14` padding on scrollable content
- Card radius: `rounded-2xl` (16px). Inner elements: `rounded-xl` (12px). Badges: `rounded-full`
- Card shadow: `shadow-sm`
- Standard card padding: `p-3`
- Grid gaps: `gap-2` (tight), `gap-3` (standard)

---

## 5. Reusable Components

### StatusBar
```tsx
function StatusBar({ light = false }) {
  // Shows "9:41" on left, "5G ●●●●" on right
  // light=true → white text (use on dark/navy headers)
  // light=false → navy text (use on white headers)
}
```

### BottomNav
5-tab navigation: Home (dashboard), Courses, Grades, Chat (messages), Profile.
- Active tab: `text-orange-500`
- Inactive: `text-slate-400`
- Background: white with `border-t border-slate-100`

### PhoneFrame (for prototype grid)
- Outer frame: `w-[200px] h-[400px] rounded-[28px] border-2 border-slate-200`
- Active state: `border-orange-500 scale-105`
- Inner content scaled at 50% for thumbnail display

### Progress Bar
```tsx
<div className="h-1.5 bg-slate-100 rounded-full overflow-hidden">
  <div className="h-full rounded-full" style={{ width: `${percent}%`, background: accentColor }} />
</div>
```

### Status Badge
```tsx
// Colors: green=completed/graded, blue=submitted/approved, orange=pending, red=urgent
<span className="text-[8px] font-semibold px-2 py-0.5 rounded-full bg-green-100 text-green-600">
  Graded
</span>
```

### Quick Link Tile (2×2 grid)
```tsx
<button className="flex flex-col items-center gap-1 p-2 rounded-2xl" style={{ background: tileBg }}>
  <div className="w-8 h-8 rounded-xl flex items-center justify-center" style={{ color: tileAccent }}>
    {icon}
  </div>
  <span className="text-[8px] font-semibold text-slate-600">{label}</span>
</button>
```

---

## 6. Icons

Use inline SVG icon components (no external icon library).
Standard props: `viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" className="w-5 h-5"`

Required icons: Home, Book, Star, User, Bell, Calendar, CreditCard, FileText, Map, MessageCircle, ChevronRight, ChevronLeft, TrendingUp, Upload, Lock, QrCode, Briefcase, Search, Eye, Fingerprint, BookOpen, Clock, Video, Award, Settings, Plus, CheckCircle, AlertCircle, Grid, Layers.

---

## 7. Imagery

Use Unsplash photos with this pattern:
```
https://images.unsplash.com/photo-{ID}?w={W}&h={H}&fit=crop&auto=format
```

| Usage | Unsplash ID | Dimensions |
|---|---|---|
| Student avatar (female) | `1494790108377-be9c29b29330` | 80×80 or 100×100 |
| Lecture / classroom | `1588196749597-9ff075ee6b5b` | 400×225 |

Always include descriptive `alt` text. Add a background color on image containers as fallback.

---

## 8. Screen Inventory (20 Screens)

### Group 1 — Onboarding & Auth
| Screen ID | Description |
|---|---|
| `splash` | Dark navy background with concentric circle rings, TA logo in orange gradient box, dot pagination, tagline |
| `onboarding` | Split layout: top half = emoji illustration on sky blue; bottom = feature title, description, dot progress, Get Started CTA |
| `login` | Navy header with TA logo, form fields (Student ID, Password with show/hide), Forgot Password link, Sign In orange CTA, biometric login option |

### Group 2 — Dashboard
| Screen ID | Description |
|---|---|
| `dashboard` | Navy header with student name + avatar + notification bell; 4-tile quick links grid; today's class cards (time + colored bar + room); upcoming deadlines widget; announcements feed |
| `notifications` | Grouped by Today / Yesterday; each item has emoji icon, title, body, timestamp; "Mark all read" action |
| `calendar` | Navy header with Academic/Social toggle; mini calendar grid (7-col); events list with colored left bar indicator |

### Group 3 — Courses & Academics
| Screen ID | Description |
|---|---|
| `courses` | Filter chips (All / In Progress / Completed / Upcoming); course cards with colored icon, progress bar, instructor, credits |
| `course-detail` | Navy header with course stats (progress%, grade, modules); tab bar (Syllabus / Assignments / Materials / Discussions / Grades); tab content below |
| `assignment` | Assignment brief card; drag-and-drop upload zone; comments textarea; Submit orange button |
| `classroom` | Dark navy/midnight background; 16:9 video frame with instructor name + viewer count overlay; control bar (mic/cam/chat/screen/hand); live chat feed; message input |

### Group 4 — Grades & Performance
| Screen ID | Description |
|---|---|
| `grades` | Navy header with GPA / CGPA / rank stats; semester filter chips; course grade cards (grade letter, GP, midterm/final scores) |
| `transcript` | GPA trend bar chart; horizontal progress bars per course; academic standing grid (credits earned/remaining, rank, honor roll) |

### Group 5 — Student Services
| Screen ID | Description |
|---|---|
| `eservices` | 2-col service grid (Request Certificate, Course Enrollment, File Appeal, Housing, Graduation, ID Replacement); recent requests list below |
| `payments` | Navy header with outstanding balance + Pay Now; saved payment methods list; transaction history (debit red, credit green) |

### Group 6 — Profile & Communication
| Screen ID | Description |
|---|---|
| `profile` | Centered avatar with orange border; name, ID, year/major/GPA stats; menu list (Academic Record, Payments, Digital ID, Career, Library, Settings) |
| `messages` | Search bar; conversation list with avatar initials, last message preview, timestamp, unread badge |

### Group 7 — Bonus Features
| Screen ID | Description |
|---|---|
| `student-id` | Full-width ID card with navy-to-orange gradient; student photo; QR code grid; Share + Download PDF buttons |
| `library` | Search bar; 3-col category grid with emoji icons and item counts; recently borrowed books list with due dates |
| `career` | 2-col service grid (Job Board, Internships, CV Builder, Mentorship); featured job listings with company logo, type badge, salary |
| `campus-map` | Stylized SVG map with dashed path lines between lettered building markers; "You are here" red dot; building directory list below |

---

## 9. Navigation Model

```
splash → onboarding → login → dashboard
dashboard ↔ notifications
dashboard ↔ calendar
dashboard ↔ courses → course-detail → assignment
                               ↓
                           classroom
dashboard → grades → transcript
profile → student-id
profile → payments
profile → library
profile → career
profile → transcript
```

Bottom nav is present on: `dashboard`, `courses`, `grades`, `messages`, `profile`
No bottom nav on: all other screens (use back arrow in header instead)

---

## 10. Student Persona (use for realistic placeholder data)

| Field | Value |
|---|---|
| Name | Rania Al-Mansouri |
| Student ID | S20210089 |
| Program | B.Sc. Computer Science |
| Year | 3rd Year |
| GPA | 3.78 |
| CGPA | 3.65 |
| Class Rank | 14 / 94 |
| Honor | Dean's List |
| Credits Earned | 72 |
| Credits Remaining | 48 |

### Courses (Semester 1, 2024–2025)
| Code | Name | Instructor | Credits | Progress | Grade |
|---|---|---|---|---|---|
| CS301 | Data Structures | Dr. Hassan Khoury | 3 | 68% | B+ (in progress) |
| MKT202 | Digital Marketing | Prof. Layla Ahmed | 3 | 82% | A |
| BUS210 | Business Ethics | Dr. Omar Farouk | 2 | 45% | B+ |
| MATH201 | Calculus II | Dr. Nadia Saleh | 4 | 91% | A+ |
| ENG101 | Technical Writing | Ms. Sara Bilal | 2 | 55% | B |

### Today's Timetable (Monday, Sep 22)
| Time | Subject | Room | Type |
|---|---|---|---|
| 9:00 | Data Structures | B-204 | Lecture |
| 11:00 | Digital Marketing | A-101 | Lab |
| 14:00 | Business Ethics | C-312 | Seminar |

---

## 11. Sample Prompt for AI Rebuild

Paste this into any AI code generator to reproduce the app:

```
Build a React + Vite + Tailwind CSS v4 mobile app prototype called "Theeba Academy Portal".

Design system:
- Font: Poppins (Google Fonts, all weights 300–800)
- Primary color: #1A2B5F (navy)
- Accent color: #FF6B2B (orange)
- Third accent: #00C9A7 (mint)
- Page background: #F8FAFC
- All cards: white, rounded-2xl, shadow-sm, p-3

Layout:
- Mobile-first, ~390px wide screens
- Each screen is h-full flex flex-col
- Headers: navy gradient background, white text, StatusBar at top
- Content: flex-1 overflow-y-auto px-3 space-y-3 with scrollbarWidth none
- Bottom navigation (5 tabs) on main screens, padding-bottom pb-14

Screens to build (20 total):
splash, onboarding, login, dashboard, courses, course-detail, assignment, classroom,
eservices, payments, grades, transcript, profile, messages, notifications, calendar,
student-id, library, career, campus-map

Student persona: Rania Al-Mansouri, ID S20210089, CS Year 3, GPA 3.78.

Wrap everything in a prototype showcase with:
1. An interactive phone demo (sticky left, full-size phone with working React state navigation)
2. A thumbnail grid (all screens grouped by section, each in a 200×400 phone frame)
3. A header with "Interactive" / "All Screens" toggle

Use only inline SVG icons (no icon library). Use Unsplash for photos.
```

---

## 12. File Structure

```
/
├── src/
│   ├── main.tsx          # React entrypoint, imports index.css, mounts App
│   ├── App.tsx           # All screens + prototype shell (single file)
│   └── index.css         # Google Fonts @import, Tailwind @import, global resets
├── index.html
├── vite.config.ts
├── package.json
└── DESIGN_SPEC.md        # ← this file
```

All 20 screens live in `src/App.tsx` as named function components.
Navigation is handled by a single `useState<string>` (`screen`) passed as `onNav` callbacks.

---

*Last updated: September 2024 · Theeba Academy Portal v1.0*
