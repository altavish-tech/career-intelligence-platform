# 🧪 Theme Toggle Testing Guide

## Quick Start Testing

### 1. Open the Application
```
http://localhost:3000
```

### 2. Locate Theme Toggle Button
- **Landing Page:** Top-right corner of Navbar (next to Login/Signup)
- **App Pages:** Top-right corner of Topbar (next to profile icon)
- **Icon:** Sun icon (☀️) in dark mode, Moon icon (🌙) in light mode

### 3. Test Basic Functionality
1. Click the theme toggle button
2. Page should instantly switch themes
3. Refresh the page - theme should persist
4. Navigate to different pages - theme should remain consistent

---

## 🎯 Detailed Testing Checklist

### A. Landing Page (/)
- [ ] Theme toggle visible in Navbar
- [ ] Hero section background changes
- [ ] Text colors change appropriately
- [ ] Feature cards have correct backgrounds
- [ ] "How It Works" section renders correctly
- [ ] Demo section visible in both themes
- [ ] CTA buttons maintain contrast
- [ ] Footer readable in both themes

### B. Authentication Pages
**Login (/auth/login)**
- [ ] Form background changes
- [ ] Input fields have correct colors
- [ ] Text is readable
- [ ] Buttons maintain proper contrast
- [ ] Links are visible

**Signup (/auth/signup)**
- [ ] Same checks as Login page
- [ ] All form fields visible
- [ ] Validation messages readable

### C. Dashboard (/dashboard)
- [ ] Sidebar theme changes
- [ ] Topbar theme changes
- [ ] Welcome card background changes
- [ ] Score circle visible in both themes
- [ ] Quick actions cards readable
- [ ] Recent activity section visible
- [ ] All icons maintain proper contrast

### D. Jobs Page (/jobs)
- [ ] Job cards background changes
- [ ] Search bar visible
- [ ] Filters readable
- [ ] Match percentage visible
- [ ] Company logos visible
- [ ] Salary information readable
- [ ] Tags have proper contrast

### E. Analytics Page (/analytics)
- [ ] Charts visible in both themes
- [ ] Chart tooltips readable
- [ ] Stats cards background changes
- [ ] Text colors appropriate
- [ ] Graph lines visible
- [ ] Legend readable

### F. Profile Page (/profile)
- [ ] Profile card background changes
- [ ] Avatar visible
- [ ] Form fields readable
- [ ] Section headers visible
- [ ] Save button maintains contrast
- [ ] All text readable

### G. Interview Pages
**Setup (/interview/setup)**
- [ ] Configuration cards visible
- [ ] Dropdown menus readable
- [ ] Start button visible
- [ ] Instructions readable

**Live (/interview/live)**
- [ ] Video feed visible
- [ ] Question card readable
- [ ] Timer visible
- [ ] Controls accessible
- [ ] Transcript readable

**Report (/interview/report/[id])**
- [ ] Score display visible
- [ ] Feedback cards readable
- [ ] Charts visible
- [ ] Recommendations readable

### H. Settings Page (/settings)
- [ ] Settings sections visible
- [ ] Toggle switches visible
- [ ] Input fields readable
- [ ] Save buttons visible
- [ ] Section dividers visible

### I. Roadmap Page (/roadmap)
- [ ] Timeline visible
- [ ] Milestone cards readable
- [ ] Progress indicators visible
- [ ] Text readable
- [ ] Icons visible

---

## 🎨 Visual Checks

### Light Mode Should Have:
- ✅ White/light gray backgrounds
- ✅ Dark text (slate-900)
- ✅ Light borders (slate-200)
- ✅ Clean, bright appearance
- ✅ Good contrast for readability

### Dark Mode Should Have:
- ✅ Dark backgrounds (slate-950)
- ✅ Light text (slate-50)
- ✅ Subtle borders (white with transparency)
- ✅ Elegant, modern appearance
- ✅ No eye strain

---

## 🔍 Edge Cases to Test

### 1. Theme Persistence
- [ ] Refresh page - theme persists
- [ ] Close browser and reopen - theme persists
- [ ] Navigate between pages - theme persists
- [ ] Open in new tab - theme matches

### 2. Performance
- [ ] Theme switches instantly (no lag)
- [ ] No flash of wrong theme on page load
- [ ] No layout shift during theme change
- [ ] Smooth transition animations

### 3. Accessibility
- [ ] Theme toggle keyboard accessible (Tab + Enter)
- [ ] Focus states visible in both themes
- [ ] Sufficient color contrast (WCAG AA)
- [ ] Screen reader announces theme change

### 4. Responsive Design
- [ ] Theme toggle visible on mobile
- [ ] Theme works on tablet
- [ ] Theme works on desktop
- [ ] No layout breaks in either theme

### 5. Browser Compatibility
- [ ] Chrome/Edge (Chromium)
- [ ] Firefox
- [ ] Safari
- [ ] Mobile browsers

---

## 🐛 Common Issues to Check

### Issue 1: Theme Not Persisting
**Symptom:** Theme resets to dark on refresh  
**Check:** Browser localStorage enabled  
**Fix:** Clear cache and try again

### Issue 2: Flash of Wrong Theme
**Symptom:** Brief flash of dark theme before light appears  
**Check:** Initial theme script in layout.tsx  
**Status:** Should be fixed ✅

### Issue 3: Some Elements Not Changing
**Symptom:** Some cards/text don't change color  
**Check:** Missing dark: classes  
**Action:** Report specific component

### Issue 4: Toggle Button Not Visible
**Symptom:** Can't find theme toggle  
**Check:** Screen size (might be hidden on mobile)  
**Location:** Top-right corner

### Issue 5: Poor Contrast
**Symptom:** Text hard to read in one theme  
**Check:** Specific component  
**Action:** Report for color adjustment

---

## 📊 Testing Report Template

```markdown
## Theme Toggle Test Report

**Tester:** [Your Name]
**Date:** [Date]
**Browser:** [Chrome/Firefox/Safari/Edge]
**Device:** [Desktop/Mobile/Tablet]

### Test Results:

#### Landing Page: ✅ / ❌
- Notes: 

#### Dashboard: ✅ / ❌
- Notes:

#### Jobs Page: ✅ / ❌
- Notes:

#### Analytics: ✅ / ❌
- Notes:

#### Profile: ✅ / ❌
- Notes:

#### Interview: ✅ / ❌
- Notes:

#### Settings: ✅ / ❌
- Notes:

### Issues Found:
1. [Issue description]
2. [Issue description]

### Overall Rating: [1-10]

### Recommendation: [Approve/Request Changes]
```

---

## 🚀 Quick Test Script

Run this quick 2-minute test:

1. **Open** http://localhost:3000
2. **Click** theme toggle (should switch instantly)
3. **Refresh** page (theme should persist)
4. **Navigate** to /dashboard
5. **Check** sidebar and cards
6. **Navigate** to /jobs
7. **Check** job cards
8. **Click** theme toggle again
9. **Navigate** to /profile
10. **Refresh** page (theme should still persist)

**Expected:** All steps work smoothly ✅

---

## 📸 Screenshot Checklist

For documentation, capture:
- [ ] Landing page (both themes)
- [ ] Dashboard (both themes)
- [ ] Jobs page (both themes)
- [ ] Theme toggle button location
- [ ] Mobile view (both themes)

---

## ✅ Sign-Off

After testing, confirm:
- [ ] All pages tested
- [ ] Both themes work correctly
- [ ] Theme persists across sessions
- [ ] No visual glitches
- [ ] Performance is good
- [ ] Ready for production

**Tested By:** _______________  
**Date:** _______________  
**Approved:** ✅ / ❌

---

*Happy Testing! 🎉*
