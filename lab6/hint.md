### **NAT (Network Address Translation)**

**Определение:** NAT (трансляция сетевых адресов) — это технология, используемая на маршрутизаторах для преобразования частных (внутренних) IP-адресов в публичные (внешние) и наоборот.
**Применение:** Используется для обеспечения доступа устройств локальной сети в Интернет при недостатке публичных IP-адресов, а также для повышения безопасности.
**Обоснование:** Частные IP-адреса не маршрутизируются в глобальной сети Интернет, поэтому без NAT устройства не могут выходить в сеть. NAT позволяет множеству устройств делить один внешний IP-адрес, скрывая внутреннюю структуру сети.

---

### **Публичный IP-адрес (Public IP address)**

**Определение:** Это IP-адрес, назначаемый устройству, доступному из глобальной сети Интернет. Он уникален и регистрируется через глобальные интернет-регистраторы.
**Применение:** Назначается серверам, маршрутизаторам или конечным пользователям, которым необходим прямой доступ из Интернета.
**Обоснование:** Такой адрес нужен, чтобы любое устройство в Интернете могло найти и связаться с данным узлом. Например, веб-сервер или маршрутизатор с NAT используют публичный IP на внешнем интерфейсе.

---

### **Частный IP-адрес (Private IP address)**

**Определение:** Это IP-адрес из диапазонов, зарезервированных для использования внутри локальных сетей. Они не маршрутизируются в глобальной сети. Диапазоны:

- 10.0.0.0 – 10.255.255.255
- 172.16.0.0 – 172.31.255.255
- 192.168.0.0 – 192.168.255.255
  **Применение:** Используются в домашних, корпоративных и учебных сетях.
  **Обоснование:** Такие адреса позволяют многим организациям использовать IP-сети, не конфликтуя с другими, и без необходимости регистрации уникального IP-адреса.

---

### **Статический NAT (Static NAT)**

**Определение:** Это тип NAT, при котором каждому внутреннему IP-адресу сопоставляется постоянный внешний IP-адрес.
**Применение:** Используется, когда необходимо обеспечить постоянный доступ из внешней сети к конкретному внутреннему устройству, например, веб-серверу или FTP-серверу.
**Обоснование:** Гарантирует, что внешний пользователь всегда попадёт на один и тот же внутренний адрес. Особенно важно при размещении внутренних сервисов, доступных извне.

---

### **Динамический NAT (Dynamic NAT)**

**Определение:** Это тип NAT, при котором внутренние IP-адреса динамически сопоставляются с одним из нескольких доступных внешних IP-адресов из заранее заданного пула.
**Применение:** Используется, когда организации имеют несколько внешних IP-адресов и хотят управлять выходом внутренних пользователей в сеть с их помощью.
**Обоснование:** Подходит для ситуаций, где нет необходимости в постоянном сопоставлении, но нужен контроль и разграничение по внешним адресам.

---

### **Перегруженный NAT (Overloaded NAT / PAT — Port Address Translation)**

**Определение:** Это форма NAT, при которой множество внутренних IP-адресов используют один внешний IP-адрес, а различие достигается за счёт номеров портов.
**Применение:** Наиболее широко используется в домашнем интернете и офисных сетях, когда у провайдера выделен только один внешний IP.
**Обоснование:** Позволяет всем пользователям локальной сети одновременно использовать Интернет через один публичный адрес, делая это экономично и эффективно.

---
