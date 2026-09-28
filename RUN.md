# تشغيل حزمة الاختبارات من Termux

هذا المستودع يوفر مشغّلًا واحدًا لاختبارات CLI غير تدميرية. لا يمكن تشغيل **كل** أدوات الاختبار معًا حرفيًا: أدوات GUI مثل Burp/ZAP/Charles، ومحاكيات Android، وأدوات تتطلب Docker أو صلاحيات root تحتاج بيئة منفصلة. المشغّل يستخدم البدائل القابلة للتشغيل من Termux ويترك تقريرًا لكل أداة.

## الاستخدام السريع

```bash
pkg install git
 git clone https://github.com/saifmohamed777/app-testing-suite.git
cd app-testing-suite
bash install-termux.sh
cp config.example config.env
nano config.env
# غيّر AUTHORIZED=YES فقط بعد التأكد من وجود التفويض
bash run-suite.sh
```

بعد التنفيذ ستجد التقارير داخل `reports/<timestamp>/`.

## ما الذي يتم تشغيله؟

بالترتيب: `dig` لفحص DNS، `sslyze` لفحص TLS، `curl` للرؤوس والاستجابة، `nmap` لمسح محدود لأكثر 100 منفذ، `feroxbuster` لاكتشاف مسارات بمعدل منخفض، `lighthouse` للأداء، `axe` لإمكانية الوصول، `newman` لمجموعة API إن عرّفتها، ثم `bandit` و`pip-audit` و`pytest` عند تحديد `SOURCE_DIR`.

الأدوات المتعمدة عدم تشغيلها تلقائيًا هي brute-force وSQL injection exploitation وMetasploit وطلبات الحمل العالية؛ لأنها قد تسبب ضررًا أو توقف الخدمة. شغّلها يدويًا فقط في مختبر معزول وبتفويض صريح.

## تشغيله في الخلفية

```bash
tmux new -s app-test
bash run-suite.sh
# Ctrl-b ثم d للخروج وتركه يعمل
tmux attach -t app-test
```

## ملاحظات Termux

- أدوات GUI وChrome قد لا تعمل على كل هاتف؛ استخدم جهازًا أو بيئة Linux/CI عند الحاجة.
- لا تضع كلمات مرور أو مفاتيح API داخل المستودع.
- راجع كل نتيجة يدويًا، واضبط حدود المعدل قبل اختبار خادم إنتاج.
- `config.env` مستثنى من Git عبر `.gitignore` المقترح أدناه؛ لا ترفعه للمستودع.
