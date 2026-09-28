# 🧪 دليل شامل لأدوات اختبار التطبيقات 2026
## من الأخطر للأضعف - لا نسيان أي حاجة!

> **الهدف:** استخدام أدوات الاختبار من Termux بشكل احترافي لاختبار كل جوانب التطبيق

---

## 📊 مستويات الخطورة والأولويات

```
🔴 الأخطر (Critical)    → Penetration Testing, Security Vulnerabilities
🟠 خطير (High)          → Performance Issues, Data Leaks, Crash Testing
🟡 متوسط (Medium)       → Functional Bugs, UI/UX Issues
🟢 ضعيف (Low)           → Edge Cases, Minor UI Glitches, Cosmetic Issues
🔵 الأضعف (Minimal)     → Documentation, Comments, Code Quality
```

---

# 🔴 المستوى الأول: الاختبارات الخطيرة جداً (Security & Penetabilities)

## 1. **Burp Suite Community** - اختبار الأمان الشامل
```bash
# التثبيت في Termux
pkg install java
wget https://portswigger.net/burp/communitydownload
java -jar burpsuite_community.jar
```
**الفحوصات:**
- SQL Injection
- XSS (Cross-Site Scripting)
- CSRF (Cross-Site Request Forgery)
- Authentication Bypass
- Token Manipulation
- Session Hijacking

---

## 2. **OWASP ZAP** - اختبار الثغرات الأمنية
```bash
# التثبيت
pkg install wget
wget https://github.com/zaproxy/zaproxy/releases/download/v2.14.0/ZAP_2.14.0_Linux.tar.gz
tar -xzf ZAP_2.14.0_Linux.tar.gz
cd ZAP_2.14.0 && ./zap.sh
```
**الفحوصات:**
- SQL Injection Detection
- Cross-Site Scripting (XSS)
- Insecure Deserialization
- Broken Authentication
- Sensitive Data Exposure
- Security Misconfiguration

---

## 3. **Metasploit Framework** - اختبار الاختراق المتقدم
```bash
# التثبيت
pkg install metasploit
msfconsole
```
**الاستخدام:**
```bash
# البحث عن exploits
search wordpress

# استخدام exploit معين
use exploit/unix/webapp/wordpress_wp_plugin_upl
set RHOST target.com
set LHOST your_ip
exploit
```

---

## 4. **SQLmap** - كشف ثغرات SQL Injection
```bash
# التثبيت
pkg install python3
pip install sqlmap
# أو
git clone https://github.com/sqlmapproject/sqlmap.git
cd sqlmap && python3 sqlmap.py

# الاستخدام
sqlmap -u "http://target.com/page?id=1" --dbs
sqlmap -u "http://target.com/login" --forms --batch
```

---

## 5. **Wireshark** - تحليل حركة الشبكة
```bash
# التثبيت
pkg install wireshark tshark

# التقاط البيانات
tshark -i eth0 -w capture.pcap

# التحليل
wireshark capture.pcap
```
**الفحوصات:**
- Man-in-the-Middle Attacks
- Unencrypted Data Transmission
- Password Sniffing
- Network Traffic Analysis

---

## 6. **Nmap** - مسح الثغرات والمنافذ
```bash
# التثبيت
pkg install nmap

# المسح الأساسي
nmap target.com

# المسح المتقدم (NSE Scripts)
nmap -sV --script vuln target.com
nmap -A -T4 target.com
```

---

## 7. **SSLyze** - اختبار أمان SSL/TLS
```bash
# التثبيت
pip install sslyze

# الفحص
sslyze --regular target.com:443
```
**الفحوصات:**
- Weak Cipher Suites
- SSL/TLS Version Issues
- Certificate Validation
- Heartbleed Vulnerability

---

## 8. **Hydra** - اختبار كلمات المرور (Brute Force)
```bash
# التثبيت
pkg install hydra

# اختبار SSH
hydra -l username -P wordlist.txt ssh://target.com

# اختبار HTTP
hydra -l admin -P wordlist.txt http-post-form://target.com:80/login:user=^USER^&pass=^PASS^
```

---

---

# 🟠 المستوى الثاني: الاختبارات الخطيرة (Performance & Stability)

## 9. **Apache JMeter** - اختبار الأداء والتحمل
```bash
# التثبيت
pkg install java
wget https://jmeter.apache.org/download_jmeter.cgi
tar -xzf ApacheJMeter.tgz
cd apache-jmeter*/bin && ./jmeter.sh
```
**الاختبارات:**
- Load Testing (محاكاة آلاف المستخدمين)
- Stress Testing (الضغط على النظام)
- Spike Testing (قمم مفاجئة)
- Endurance Testing (الاختبار الطويل)

---

## 10. **Locust** - اختبار الحمل بلغة Python
```bash
# التثبيت
pip install locust

# ملف الاختبار (locustfile.py)
from locust import HttpUser, task, between

class WebsiteUser(HttpUser):
    wait_time = between(1, 3)
    
    @task
    def index(self):
        self.client.get("/")
    
    @task
    def login(self):
        self.client.post("/login", {"user": "test", "pass": "test"})

# التشغيل
locust -f locustfile.py --host=http://target.com
```

---

## 11. **Valgrind** - كشف تسريب الذاكرة
```bash
# التثبيت
pkg install valgrind

# الاستخدام
valgrind --leak-check=full ./your_app
valgrind --tool=callgrind ./your_app
```

---

## 12. **wrk** - اختبار الأداء بسرعة
```bash
# التثبيت
git clone https://github.com/wg/wrk.git
cd wrk && make

# الاستخدام
./wrk -t12 -c400 -d30s http://target.com
```

---

## 13. **Gatling** - اختبار الأداء المتقدم
```bash
# التثبيت
wget https://repo1.maven.org/maven2/io/gatling/gatling-charts-highcharts-bundle/3.9.5/gatling-charts-highcharts-bundle-3.9.5-bundle.zip
unzip *.zip
```

---

## 14. **Chaos Engineering Tools** - اختبار المرونة
```bash
# Gremlin (Cloud-based)
# Chaos Mesh (Kubernetes)
# LitmusChaos (Kubernetes)

# محاكاة التأخير
tc qdisc add dev eth0 root netem delay 100ms

# محاكاة فقدان الحزم
tc qdisc add dev eth0 root netem loss 10%
```

---

---

# 🟡 المستوى الثالث: الاختبارات المتوسطة (Functionality & UI)

## 15. **Appium** - اختبار التطبيقات المحمولة
```bash
# التثبيت
npm install -g appium
npm install -g appium-doctor

# التحقق من الإعدادات
appium-doctor

# بدء الخادم
appium

# اختبار بـ Python
from appium import webdriver

desired_caps = {
    'platformName': 'Android',
    'deviceName': 'emulator-5554',
    'appPackage': 'com.example.app',
    'appActivity': '.MainActivity'
}

driver = webdriver.Remote('http://localhost:4723', desired_caps)
driver.find_element_by_id('button_id').click()
```

---

## 16. **Selenium** - اختبار الويب الآلي
```bash
# التثبيت
pip install selenium

# اختبار بسيط
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

driver = webdriver.Chrome()
driver.get("http://target.com")

# البحث عن العنصر والضغط عليه
element = WebDriverWait(driver, 10).until(
    EC.presence_of_element_located((By.ID, "myElement"))
)
element.click()

# التحقق من النص
assert "Expected Text" in driver.page_source
driver.quit()
```

---

## 17. **Cypress** - اختبار واجهة المستخدم الحديث
```bash
# التثبيت
npm install cypress --save-dev
npx cypress open

# اختبار (spec.cy.js)
describe('Login Test', () => {
  it('Should login successfully', () => {
    cy.visit('http://target.com/login')
    cy.get('input[name="email"]').type('test@test.com')
    cy.get('input[name="password"]').type('password123')
    cy.get('button[type="submit"]').click()
    cy.url().should('include', '/dashboard')
  })
})
```

---

## 18. **Playwright** - اختبار المتصفح الشامل
```bash
# التثبيت
pip install playwright
playwright install

# اختبار
from playwright.sync_api import sync_playwright

with sync_playwright() as p:
    browser = p.chromium.launch()
    page = browser.new_page()
    page.goto("http://target.com")
    page.fill('input[name="user"]', 'testuser')
    page.fill('input[name="pass"]', 'testpass')
    page.click('button:has-text("Login")')
    assert page.url == "http://target.com/dashboard"
    browser.close()
```

---

## 19. **Postman** - اختبار API
```bash
# التثبيت (Linux)
wget https://dl.pstmn.io/download/latest/linux64 -O postman.tar.gz
tar -xzf postman.tar.gz
./Postman/Postman

# أو استخدام Newman (CLI)
npm install -g newman
newman run collection.json
```

**الفحوصات:**
- GET/POST/PUT/DELETE/PATCH
- Headers Validation
- Response Status Codes
- JSON Schema Validation
- Cookies & Session Management

---

## 20. **REST Client (VS Code)** - اختبار API سريع
```
### GET Request
GET http://api.target.com/users

### POST Request
POST http://api.target.com/login
Content-Type: application/json

{
  "email": "test@test.com",
  "password": "password123"
}

### Check Status
@status = 200
```

---

## 21. **GraphQL Playground** - اختبار GraphQL
```bash
# التثبيت
npm install -g graphql-playground-cli

# التشغيل
graphql-playground http://target.com/graphql
```

---

## 22. **Jest** - اختبار وحدة Unit Testing
```bash
# التثبيت
npm install --save-dev jest

# ملف الاختبار (sum.test.js)
function sum(a, b) {
  return a + b;
}

test('adds 1 + 2 to equal 3', () => {
  expect(sum(1, 2)).toBe(3);
});

# التشغيل
npm test
```

---

## 23. **PyTest** - اختبار Python
```bash
# التثبيت
pip install pytest

# اختبار (test_app.py)
def test_addition():
    assert 1 + 1 == 2

def test_login(client):
    response = client.post('/login', {'user': 'test', 'pass': 'test'})
    assert response.status_code == 200

# التشغيل
pytest
pytest -v
pytest --cov=app
```

---

---

# 🟢 المستوى الرابع: الاختبارات الضعيفة (Edge Cases & Details)

## 24. **Charles Proxy** - مراقبة الشبكة والتعديل
```bash
# التثبيت
wget https://www.charlesproxy.com/download/latest/charles-proxy-latest-linux64.tar.gz
tar -xzf charles-proxy-latest-linux64.tar.gz
./charles/bin/charles
```

---

## 25. **Accessibility Testing - axe DevTools**
```bash
# التثبيت (Chrome Extension أو NPM)
npm install --save-dev @axe-core/cli

# الاستخدام
axe https://target.com

# أو بـ Selenium
from axe_selenium_python import Axe

driver = webdriver.Chrome()
driver.get("http://target.com")
axe = Axe(driver)
axe.inject()
axe.run()
results = axe.results()
```

---

## 26. **LightHouse** - اختبار الأداء والـ SEO
```bash
# التثبيت
npm install -g lighthouse

# الاستخدام
lighthouse https://target.com --view

# بتقرير JSON
lighthouse https://target.com --output=json > report.json
```

---

## 27. **WebAIM Wave** - اختبار إمكانية الوصول
```bash
# أون لاين
https://wave.webaim.org/

# أو NPM
npm install -g @webaim/wave

wave https://target.com
```

---

## 28. **Mobile-Friendly Test (Google)**
```bash
# أون لاين
https://search.google.com/test/mobile-friendly
```

---

## 29. **GTmetrix** - تحليل سرعة الصفحة
```bash
# أون لاين
https://gtmetrix.com/

# أو بـ API
curl "https://api.gtmetrix.com/api/0.1/test?url=https://target.com"
```

---

## 30. **SpeedCurve** - مراقبة الأداء
```bash
# التثبيت والإعدادات
npm install -g speedcurve

speedcurve build
```

---

## 31. **New Relic** - مراقبة الأداء الشاملة
```bash
# التثبيت (Node.js)
npm install newrelic
# في ملف التطبيق
require('newrelic');
```

---

## 32. **DataDog** - المراقبة والتنبيهات
```bash
# التثبيت
pip install datadog

# الاستخدام
from datadog import initialize, api

options = {
    'api_key': 'YOUR_API_KEY',
    'app_key': 'YOUR_APP_KEY'
}

initialize(**options)
api.Metric.send(metric='custom.metric', points=100)
```

---

## 33. **ELK Stack** - تحليل السجلات
```bash
# التثبيت
docker run -d -p 9200:9200 -p 5601:5601 docker.elastic.co/kibana/kibana:8.0.0

# إرسال البيانات
curl -X POST "localhost:9200/logs/_doc?pretty" -H 'Content-Type: application/json' -d'
{
  "level": "ERROR",
  "message": "Application error",
  "timestamp": "2026-09-28T10:30:00Z"
}'
```

---

---

# 🔵 المستوى الخامس: الاختبارات الأضعف (Minor Issues & QA)

## 34. **SonarQube** - تحليل جودة الكود
```bash
# التثبيت
docker run -d -p 9000:9000 sonarqube

# الوصول
http://localhost:9000 (admin/admin)

# تحليل المشروع
sonar-scanner \
  -Dsonar.projectKey=my-app \
  -Dsonar.sources=. \
  -Dsonar.host.url=http://localhost:9000 \
  -Dsonar.login=your_token
```

---

## 35. **ESLint** - فحص أخطاء JavaScript
```bash
# التثبيت
npm install --save-dev eslint

# الإعدادات
npx eslint --init

# التحليل
npx eslint src/

# الإصلاح التلقائي
npx eslint src/ --fix
```

---

## 36. **Prettier** - تنسيق الكود
```bash
# التثبيت
npm install --save-dev prettier

# التنسيق
npx prettier --write src/
```

---

## 37. **Black** - تنسيق كود Python
```bash
# التثبيت
pip install black

# التنسيق
black app.py
```

---

## 38. **Pylint** - فحص كود Python
```bash
# التثبيت
pip install pylint

# التحليل
pylint app.py
```

---

## 39. **Git Hooks** - اختبار تلقائي قبل الـ Commit
```bash
# اعداد pre-commit hook
cat > .git/hooks/pre-commit << 'EOF'
#!/bin/bash
npm test
pytest
npx eslint src/
EOF

chmod +x .git/hooks/pre-commit
```

---

## 40. **Screenshot Testing** - اختبار لقطات الشاشة
```bash
# استخدام Percy
npm install --save-dev @percy/cli @percy/sdk-webdriverio

# اختبار
import { percySnapshot } from '@percy/sdk-webdriverio';

it('should look good', async () => {
  await driver.url('http://localhost:3000');
  await percySnapshot('homepage');
});
```

---

---

# 📋 جدول الأدوات السريع

| الأداة | الهدف | المستوى | الأوامر الأساسية |
|------|------|--------|-----------------|
| **Burp Suite** | Security Testing | 🔴 Critical | `java -jar burpsuite_community.jar` |
| **OWASP ZAP** | Vulnerability Scanning | 🔴 Critical | `./zap.sh` |
| **Metasploit** | Penetration Testing | 🔴 Critical | `msfconsole` |
| **SQLmap** | SQL Injection Detection | 🔴 Critical | `python3 sqlmap.py -u "url"` |
| **JMeter** | Load Testing | 🟠 High | `./jmeter.sh` |
| **Locust** | Performance Testing | 🟠 High | `locust -f locustfile.py` |
| **Selenium** | UI Automation | 🟡 Medium | `python3 -m pytest tests/` |
| **Cypress** | E2E Testing | 🟡 Medium | `npx cypress open` |
| **Postman** | API Testing | 🟡 Medium | `newman run collection.json` |
| **Jest** | Unit Testing | 🟡 Medium | `npm test` |
| **LightHouse** | Performance Audit | 🟢 Low | `lighthouse https://url` |
| **SonarQube** | Code Quality | 🔵 Minimal | `sonar-scanner` |
| **ESLint** | Code Linting | 🔵 Minimal | `npx eslint src/` |

---

# 🚀 خطة الاختبار الشاملة (من الأخطر للأضعف)

## اليوم الأول: الأمان (Security)
```bash
# 1. فحص الثغرات الأمنية
sqlmap -u "http://target.com/page?id=1" --dbs

# 2. اختبار SSL/TLS
sslyze --regular target.com:443

# 3. مسح المنافذ
nmap -sV --script vuln target.com

# 4. تحليل الشبكة
tshark -i eth0 -w capture.pcap
```

## اليوم الثاني: الأداء (Performance)
```bash
# 1. اختبار الحمل
./wrk -t12 -c400 -d30s http://target.com

# 2. اختبار التحمل
locust -f locustfile.py --host=http://target.com

# 3. مراقبة الذاكرة
valgrind --leak-check=full ./app

# 4. تحليل الأداء
lighthouse https://target.com --view
```

## اليوم الثال��: الوظائف (Functionality)
```bash
# 1. اختبار API
newman run collection.json

# 2. اختبار الواجهة
pytest tests/ui_tests.py

# 3. اختبار الهاتف
appium start

# 4. اختبار الإمكانية
axe https://target.com
```

## اليوم الرابع: جودة الكود (Code Quality)
```bash
# 1. تحليل الكود
sonar-scanner

# 2. فحص الأخطاء
npx eslint src/

# 3. تنسيق الكود
npx prettier --write src/

# 4. اختبار الوحدات
npm test
```

---

# 💾 ملفات الإعدادات الأساسية

## `setup.sh` - تثبيت جميع الأدوات
```bash
#!/bin/bash
set -e

echo "🚀 Installing Testing Suite..."

# تحديث النظام
apt update && apt upgrade -y

# الأدوات الأساسية
pkg install -y git curl wget python3 python3-pip nodejs openjdk-17-jdk

# أدوات الأمان
pip install sqlmap
pip install scrapy
pip install requests

# أدوات الاختبار
npm install -g newman
npm install -g jest
npm install -g cypress
npm install -g appium

# أدوات الأداء
pip install locust
pip install pytest

# أدوات التحليل
pip install pylint
pip install black

echo "✅ All tools installed successfully!"
echo "📖 Start testing with: ./run_tests.sh"
```

## `run_tests.sh` - تشغيل جميع الاختبارات
```bash
#!/bin/bash

echo "🧪 Running Complete Test Suite..."

# 1. Security Tests
echo "🔴 Running Security Tests..."
sqlmap -u "$TARGET_URL" --batch --dbs 2>&1 | tee security_report.txt

# 2. Performance Tests
echo "🟠 Running Performance Tests..."
./wrk -t12 -c400 -d30s "$TARGET_URL" | tee performance_report.txt

# 3. Functionality Tests
echo "🟡 Running Functionality Tests..."
npm test 2>&1 | tee functional_report.txt

# 4. Code Quality Tests
echo "🔵 Running Code Quality Tests..."
sonar-scanner | tee quality_report.txt

echo "✅ All tests completed!"
echo "📊 Reports generated in current directory"
```

---

# 🎯 نصائح مهمة للاختبار من Termux

1. **استخدم `tmux` أو `screen` لتشغيل أدوات متعددة في نفس الوقت**
```bash
tmux new-session -d -s testing
tmux send-keys -t testing "jmeter" Enter
tmux send-keys -t testing "locust -f locustfile.py" Enter
```

2. **استخدم `nohup` لتشغيل الأدوات في الخلفية**
```bash
nohup locust -f locustfile.py &
nohup newman run collection.json &
```

3. **حفظ النتائج في ملفات**
```bash
pytest > test_results.txt 2>&1
newman run collection.json --reporters cli,json > api_report.json
```

4. **استخدم `watch` لمراقبة النتائج مباشرة**
```bash
watch -n 1 'tail results.txt'
```

5. **دمج النتائج في ملف واحد**
```bash
cat security_report.txt performance_report.txt functional_report.txt > final_report.txt
```

---

# 📞 المراجع والمصادر

- [OWASP Testing Guide](https://owasp.org/www-project-web-security-testing-guide/)
- [Selenium Documentation](https://www.selenium.dev/documentation/)
- [Postman Learning Center](https://learning.postman.com/)
- [JMeter User Manual](https://jmeter.apache.org/usermanual/index.html)
- [Cypress Documentation](https://docs.cypress.io/)
- [Appium Tutorial](http://appium.io/docs/en/about-appium/intro/)

---

**آخر تحديث:** 2026-09-28
**الإصدار:** 1.0.0
**الحالة:** ✅ شامل وجاهز للاستخدام من Termux
