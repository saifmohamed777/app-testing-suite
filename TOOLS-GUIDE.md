# 📚 دليل الأدوات المثبتة

## أدوات الشبكة والأمان

### 1. **dig** - DNS Lookup
- الأمر: `dig example.com`
- الغرض: فحص سجلات DNS

### 2. **nmap** - Port & Vulnerability Scanning
- الأمر: `nmap -sV example.com`
- الغرض: مسح المنافذ والخدمات

### 3. **sslyze** - SSL/TLS Testing
- الأمر: `sslyze --regular example.com:443`
- الغرض: فحص شهادات وتشفير SSL

### 4. **sqlmap** - SQL Injection Detection
- الأمر: `sqlmap -u "http://example.com/page?id=1" --dbs`
- الغرض: اكتشاف ثغرات SQL Injection

### 5. **hydra** - Brute Force Testing
- الأمر: `hydra -l admin -P wordlist.txt ssh://target.com`
- الغرض: اختبار كلمات المرور

## أدوات الويب والأداء

### 6. **curl** - HTTP Client
- الأمر: `curl -I https://example.com`
- الغرض: طلب بيانات HTTP مع رؤوس

### 7. **lighthouse** - Performance & SEO Audit
- الأمر: `lighthouse https://example.com --view`
- الغرض: تحليل الأداء والـ SEO

### 8. **newman** - Postman Collection Runner
- الأمر: `newman run collection.json`
- الغرض: تشغيل اختبارات API تلقائيًا

## أدوات الاختبار التلقائي

### 9. **pytest** - Unit Testing
- الأمر: `pytest tests/`
- الغرض: اختبار وحدات الكود

### 10. **bandit** - Python Security Linter
- الأمر: `bandit -r src/`
- الغرض: كشف مشاكل الأمان في Python

### 11. **pip-audit** - Dependency Vulnerability Scanner
- الأمر: `pip-audit`
- الغرض: فحص مكتبات Python للثغرات

## أدوات إضافية

### 12. **axe** - Accessibility Testing
- الأمر: `axe https://example.com`
- الغرض: فحص إمكانية الوصول للمعاقين

### 13. **locust** - Load Testing
- الأمر: `locust -f locustfile.py --host=http://target.com`
- الغرض: اختبار الحمل والأداء

### 14. **cypress** - E2E Testing
- الأمر: `npx cypress open`
- الغرض: اختبارات نهاية إلى نهاية للويب

### 15. **appium** - Mobile Testing
- الأمر: `appium`
- الغرض: اختبار التطبيقات المحمولة

## الأوامر السريعة

### فحص شامل بأمر واحد
```bash
bash run-suite.sh
```

### فحص متقدم
```bash
bash advanced-suite.sh
```

### فحص مخصص
```bash
TARGET_URL=https://your-site.com bash run-suite.sh
```

## ملفات التقارير

- `01_dns.txt` - نتائج DNS
- `02_tls.json` - تحليل TLS
- `03_headers.txt` - رؤوس HTTP
- `05_ports.txt` - المنافذ المفتوحة
- `08_lighthouse.html` - تقرير الأداء
- `09_axe.json` - نتائج الإمكانية
- `13_bandit.json` - مشاكل الأمان في الكود

## نصائح مهمة

1. استخدم الأدوات فقط على الأنظمة التي تملكها أو لديك تصريح
2. راجع جميع التقارير قبل اتخاذ قرار
3. احفظ التقارير في مكان آمن
4. استخدم `AUTHORIZED=YES` فقط بعد التأكد من التصريح
