# 🧪 تشغيل حزمة الاختبارات من Termux

## تثبيت سريع

```bash
git clone https://github.com/saifmohamed777/app-testing-suite.git
cd app-testing-suite
bash install-termux.sh
```

## الإعداد والتشغيل

```bash
cp config.example config.env
nano config.env
# عدّل:
# AUTHORIZED=YES
# TARGET_URL=https://your-target.com

bash run-suite.sh
```

## ما يتم اختباره؟

1. **DNS Lookup** - فحص DNS وترجمة الاسم
2. **TLS Certificate** - تفاصيل الشهادة والتشفير
3. **HTTP Headers** - رؤوس الاستجابة
4. **Response Body** - محتوى الصفحة
5. **Port Scan** - المنافذ المفتوحة
6. **DNS Enumeration** - سجلات DNS
7. **Connection Speed** - سرعة الاتصال
8. **Performance** - تحليل الأداء
9. **Accessibility** - فحص إمكانية الوصول
10. **API Testing** - اختبار نقاط API
11. **SSL/TLS Details** - تفاصيل التشفير
12. **Common Paths** - المسارات الشائعة
13. **Source Code Analysis** - تحليل الكود
14. **Whois & DNS** - معلومات السجل
15. **Robots & Sitemap** - ملفات الموقع

## النتائج

جميع التقارير تُحفظ في مجلد `reports/` مع طابع زمني.

## ملاحظات أمان

- لا تشغّل إلا على مواقع/تطبيقات لديك تصريح اختبارها
- اقرأ كل التقارير بعناية قبل نشر أي تعديلات
- احفظ جميع التقارير في مكان آمن
